"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Closure,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'block',
		'homeFrame'
	],
	#classVars : [
		'Indexes'
	],
	#category : #Kernel
}

{ #category : #initialization }
Closure class >> initializeIndexes [
	Indexes := PoolDictionary newConstantPool
		at: 'ReceiverIndex' put: 1;
		at: 'ParentEnvironmentIndex' put: 2;
		yourself
]

{ #category : #gs }
Closure class >> newFrom: aBlock [
	| size closure |
	#atomic.
	size := aBlock _size - 1.
	closure := self allocate: size * WordSize size: size.
	closure _beNamed; _beArrayed.
	self nil: size slotsOf: closure.
	closure _basicAt: 1 put: aBlock.
	Smalltalk memory rememberIfNotYoung: closure.
	^closure
]

{ #category : #private }
Closure class >> receiverIndex [
	^ReceiverIndex
]

{ #category : #handling }
Closure >> _return: result [
	self canReturn ifFalse: [^self cannotReturn].
	^ActiveProcess returnTo: homeFrame current with: result
]

{ #category : #comparing }
Closure >> = aBlockClosure [
	self == aBlockClosure ifTrue: [^true].
	self class == aBlockClosure class ifFalse: [^false].
	self size = aBlockClosure size ifFalse: [^false].
	block == aBlockClosure block ifFalse: [^false].
	^true
]

{ #category : #accessing }
Closure >> argumentCount [
	^block argumentCount
]

{ #category : #accessing }
Closure >> arity [
	^block arity
]

{ #category : #errors }
Closure >> arityError: anInteger [
	| arity msg count |
	arity := block argumentCount.
	count := anInteger = 0 ifTrue: ['none'] ifFalse: [anInteger asString].
	msg := 'The ' , self class name , ' expects ' , arity printString
		, (' argument' pluralize: arity > 1)
		, ', but was called with '
		, count.
	^self error: msg
]

{ #category : #private }
Closure >> block [
	^block
]

{ #category : #accessing }
Closure >> blockNumber [
	^block blockNumber
]

{ #category : #converting }
Closure >> canReturn [
	| env |
	homeFrame == nil ifTrue: [^false].
	homeFrame stackPointer < self _thisContext ifTrue: [^false].
	homeFrame hasBlocks ifFalse: [^false].
	env := self methodEnvironment.
	homeFrame environment == env ifTrue: [^true].
	^homeFrame methodEnvironment == env
]

{ #category : #evaluating }
Closure >> cull: a cull: b [
	^self argumentCount < 2
		ifTrue: [self cull: a]
		ifFalse: [self value: a value: b]
]

{ #category : #services }
Closure >> do: aClosure [
	1 to: self size do: [:index | | slot |
		slot := self at: index.
		aClosure value: slot]
]

{ #category : #handling }
Closure >> ensure: aBlock [
	^ActiveProcess evaluate: self ensuring: aBlock
]

{ #category : #handling }
Closure >> evaluate [
	^self value
]

{ #category : #handling }
Closure >> evaluateAtomically [
	| enabled |
	enabled := Processor enableInterrupts: false.
	^self ensure: [Processor enableInterrupts: enabled]
]

{ #category : #handling }
Closure >> evaluateFor: anObject [
	^self value: anObject
]

{ #category : #handling }
Closure >> evaluateWith: value [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
]

{ #category : #handling }
Closure >> evaluateWith: anObject with: anotherObject [
	block argumentCount = 2
		ifFalse: [^super evaluateWith: anObject with: anotherObject].
	self _transferControlTo: block blockNativeCode
]

{ #category : #evaluating }
Closure >> evaluateWithArguments: anArray [
	| n args |
	n := self argumentCount.
	n = 0 ifTrue: [^self value].
	args := anArray size > n
		ifTrue: [anArray copyFrom: 1 to: n]
		ifFalse: [anArray].
	^self valueWithArguments: args
]

{ #category : #handling }
Closure >> fork [
	^self newProcess fork
]

{ #category : #handling }
Closure >> forkAt: aNumber [
	^self forkAt: aNumber named: 'forked from block'
]

{ #category : #handling }
Closure >> forkAt: aNumber named: aString [
	^self newProcess name: aString; priority: aNumber; fork
]

{ #category : #handling }
Closure >> forkNamed: aString [
	^self forkAt: Processor activePriority named: aString
]

{ #category : #comparing }
Closure >> hash [
	| hash s |
	s := self size.
	hash := (s hashMultiply: 16r19660D) bitXor: block hash.
	1
		to: s
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i) hash].
	^hash
]

{ #category : #handling }
Closure >> hasMethodEnvironment [
	^self size >= ParentEnvironmentIndex
]

{ #category : #accessing }
Closure >> homeFrame [
	^homeFrame
]

{ #category : #accessing }
Closure >> homeFrame: aStackFrameCursor [
	homeFrame := aStackFrameCursor
]

{ #category : #evaluating }
Closure >> ifCurtailed: aBlock [
	| success |
	success := false.
	^[| value |
		value := self value.
		success := true.
		value]
		ensure: [success ifFalse: [aBlock value]]
]

{ #category : #'file in/out' }
Closure >> invalidate [
	| error |
	error := [nil error: 'trying to execute invalid closure'].
	block := error block
]

{ #category : #accessing }
Closure >> invalidateHome [
	homeFrame := nil
]

{ #category : #testing }
Closure >> isBlockClosure [
	"
	FIXME: fix senders and remove me
	"
	^true
]

{ #category : #testing }
Closure >> isClosure [
	^true
]

{ #category : #handling }
Closure >> method [
	^block method
]

{ #category : #accessing }
Closure >> method: aCompiledMethod [
	block := aCompiledMethod at: block templateIndex
]

{ #category : #handling }
Closure >> methodEnvironment [
	^self at: ParentEnvironmentIndex
]

{ #category : #handling }
Closure >> methodEnvironment: environment [
	self at: ParentEnvironmentIndex put: environment
]

{ #category : #handling }
Closure >> needsArgument [
	^self argumentCount > 0
]

{ #category : #accessing }
Closure >> numArgs [
	^self argumentCount
]

{ #category : #handling }
Closure >> on: aClass do: aClosure [
	^ExceptionHandler handle: aClass with: aClosure during: self
]

{ #category : #handling }
Closure >> on: exception1
do: closure1
on: exception2
do: closure2 [
	^self on: exception1 , exception2 do: [:ex | | handler |
		handler := (exception1 includesException: ex)
			ifTrue: [closure1]
			ifFalse: [closure2].
		handler evaluateWith: ex]
]

{ #category : #handling }
Closure >> printOn: aStream [
	self class printOn: aStream.
	aStream nextPut: $(.
	block basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field |
			field := self at: i.
			field printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #handling }
Closure >> receiver [
	^self at: ReceiverIndex
]

{ #category : #handling }
Closure >> receiver: anObject [
	self at: ReceiverIndex put: anObject
]

{ #category : #handling }
Closure >> repeat [
	[true] whileTrue: [self value]
]

{ #category : #handling }
Closure >> repeatUntil: aBlock [
	[
		self value.
		aBlock value] whileFalse
]

{ #category : #handling }
Closure >> spawnAndWait [
	| s result |
	s := Semaphore new.
	[result := self ensure: [s signal]] fork.
	s wait.
	^result
]

{ #category : #accessing }
Closure >> tempCount [
	^block tempCount
]

{ #category : #accessing }
Closure >> templateIndex [
	^block templateIndex
]

{ #category : #handling }
Closure >> value [
	block argumentCount = 0 ifFalse: [^self arityError: 0].
	self _transferControlTo: block blockNativeCode
]

{ #category : #handling }
Closure >> value: value [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
]

{ #category : #handling }
Closure >> value: first value: second [
	block argumentCount = 2 ifFalse: [^self arityError: 2].
	self _transferControlTo: block blockNativeCode
]

{ #category : #handling }
Closure >> value: first value: second value: third [
	block argumentCount = 3 ifFalse: [^self arityError: 3].
	self _transferControlTo: block blockNativeCode
]

{ #category : #evaluating }
Closure >> value: arg1
value: arg2
value: arg3
value: arg4 [
	^self valueWithArguments: {arg1. arg2. arg3. arg4}
]

{ #category : #evaluating }
Closure >> valueSelector [
	^block valueSelector
]

{ #category : #handling }
Closure >> valueWithArguments: arguments [
	| size |
	size := arguments basicSize.
	block argumentCount = size ifFalse: [^self arityError: size].
	arguments _expandInStackSized: size.
	^self _invoke: block blockNativeCode
]

{ #category : #handling }
Closure >> whileFalse [
	^[self value] whileFalse: []
]

{ #category : #handling }
Closure >> whileFalse: aBlock [
	[self value] whileFalse: [aBlock value]
]

{ #category : #handling }
Closure >> whileTrue [
	^[self value] whileTrue: []
]

{ #category : #handling }
Closure >> whileTrue: aBlock [
	[self value] whileTrue: [aBlock value]
]

