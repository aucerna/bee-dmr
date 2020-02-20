Class {
	#name : #Closure,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'#block',
		'#homeFrame'
	],
	#classVars : [
		'#Indexes'
	],
	#category : #Kernel
}

{ #category : #initialization }
Closure class >> initializeIndexes [
	Indexes := PoolDictionary newConstantPool
]

{ #category : #gs }
Closure class >> newFrom: aBlock [
	| size closure |
]

{ #category : #private }
Closure class >> receiverIndex [
	^ReceiverIndex
]

{ #category : #handling }
Closure >> _return: result [
	self canReturn ifFalse: [^self cannotReturn].
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
]

{ #category : #errors }
Closure >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self outOfBoundsIndex: anInteger].
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
]

{ #category : #evaluating }
Closure >> cull: a cull: b [
	^self argumentCount < 2
]

{ #category : #services }
Closure >> do: aClosure [
	1 to: self size do: [:index | | slot |
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
]

{ #category : #handling }
Closure >> evaluateFor: anObject [
	^self value: anObject
]

{ #category : #handling }
Closure >> evaluateWith: value [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
]

{ #category : #handling }
Closure >> evaluateWith: anObject with: anotherObject [
	block argumentCount = 2
]

{ #category : #evaluating }
Closure >> evaluateWithArguments: anArray [
	| n args |
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

{ #category : #handling }
Closure >> forkThread [
	^Thread newOn: self
]

{ #category : #handling }
Closure >> hasMethodEnvironment [
	^self size >= ParentEnvironmentIndex
]

{ #category : #evaluating }
Closure >> ifCurtailed: exceptionClosure [
	| success |
]

{ #category : #testing }
Closure >> isBlockClosure [
	"
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

{ #category : #accessing }
Closure >> methodFrame [
	^homeFrame methodFrame
]

{ #category : #handling }
Closure >> needsArgument [
	^self argumentCount > 0
]

{ #category : #handling }
Closure >> newProcess [
	^Process sending: #value to: self
]

{ #category : #handling }
Closure >> newProcessWith: anArray [
	| message |
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
	^self on: exception1 , exception2 do: [:ex | | handler |
]

{ #category : #handling }
Closure >> printOn: aStream [
	self class printOn: aStream.
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
]

{ #category : #handling }
Closure >> spawnAndWait [
	| s result |
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
]

{ #category : #handling }
Closure >> value: value [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
]

{ #category : #handling }
Closure >> value: first value: second [
	block argumentCount = 2 ifFalse: [^self arityError: 2].
]

{ #category : #handling }
Closure >> value: first value: second value: third [
	block argumentCount = 3 ifFalse: [^self arityError: 3].
]

{ #category : #evaluating }
Closure >> value: arg1
	^self valueWithArguments: {arg1. arg2. arg3. arg4}
]

{ #category : #evaluating }
Closure >> valueSelector [
	^block valueSelector
]

{ #category : #handling }
Closure >> valueWithArguments: arguments [
	| size |
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
