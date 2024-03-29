"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CompiledBlock,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'method',
		'format',
		'nativeCode'
	],
	#classVars : [
		'Formats'
	],
	#category : #Kernel
}

{ #category : #initialization }
CompiledBlock class >> ArgCountStretch [
	^ArgCount
]

{ #category : #initialization }
CompiledBlock class >> ensureFormatCorrectness [
	self
		ASSERT: Id end <= SmallInteger maximum;
		ASSERT: ArgCount end <= SmallInteger maximum;
		ASSERT: TempCount end <= SmallInteger maximum;
		DENY: (Id intersects: ArgCount);
		DENY: (Id intersects: TempCount);
		DENY: (ArgCount intersects: TempCount)
]

{ #category : #'instance creation' }
CompiledBlock class >> fromArray: anArray [
	| block |
	block := self new: anArray size - 2.
	^block loadFrom: anArray
]

{ #category : #initialization }
CompiledBlock class >> IdStretch [
	^Id
]

{ #category : #initialization }
CompiledBlock class >> initializeFormatFlags [
	"
	self initializeFormatFlags.
	self compileAll.
	self class compileAll
	"
	Flags := PoolDictionary newConstantPool
		at: 'ArgCount' put: (1 thru: 8);
		at: 'TempCount' put: (9 thru: 16);
		at: 'Id' put: (17 thru: 24);
		at: 'CapturesSelf' put: (1 bitShift: 25 - 1);
		at: 'EnvCount' put: (26 thru: 31);
		yourself.
]

{ #category : #initialization }
CompiledBlock class >> maxArgCount [
	^(2 raisedTo: ArgCount length) - 1
]

{ #category : #initialization }
CompiledBlock class >> maxTempCount [
	^(2 raisedTo: TempCount length) - 1
]

{ #category : #initialization }
CompiledBlock class >> TempCountStretch [
	^TempCount
]

{ #category : #accessing }
CompiledBlock >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : #accessing }
CompiledBlock >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> arity [
	^self argumentCount
]

{ #category : #accessing }
CompiledBlock >> aspects [
	^#(#arity
		#blockNumber
		#method
		#hasMethodEnvironment
		#tempCount
		#templateIndex)
]

{ #category : #comparing }
CompiledBlock >> basicPrintOn: aStream [
	method printOn: aStream.
	aStream
		nextPutAll: '. Block number: ';
		nextPutAll: self blockNumber printString;
		nextPutAll: ', ';
		nextPutAll: self argumentCount printString;
		nextPutAll: ' args, ';
		nextPutAll: self tempCount printString;
		nextPutAll: ' temps. '
]

{ #category : #accessing }
CompiledBlock >> bindMethod: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #accessing }
CompiledBlock >> blockCode [
	^nativeCode code
]

{ #category : #accessing }
CompiledBlock >> blockNativeCode [
	"
	required to let the optimizing compiler inline this code
	without confusing with CompiledMethod>>#nativeCode
	"
	^nativeCode
]

{ #category : #accessing }
CompiledBlock >> blockNumber [
	^format bitsAt: Id
]

{ #category : #accessing }
CompiledBlock >> blockNumber: anInteger [
	format := format bitsAt: Id put: anInteger
]

{ #category : #accessing }
CompiledBlock >> format [
	^format
]

{ #category : #testing }
CompiledBlock >> hasMethodEnvironment [
	^self size >= 2 and: [(self at: 2) notNil]
]

{ #category : #comparing }
CompiledBlock >> hasReceiver [
	| index |
	index := Closure receiverIndex.
	^self size >= index andNot: [(self at: index) isNil]
]

{ #category : #accessing }
CompiledBlock >> initialize [
	super initialize.
	format := 0
]

{ #category : #accessing }
CompiledBlock >> invalidateNativeCode [
	nativeCode := nil
]

{ #category : #testing }
CompiledBlock >> isBlock [
	^true
]

{ #category : #testing }
CompiledBlock >> isCallback [
	^method isCallback
]

{ #category : #testing }
CompiledBlock >> isDebuggable [
	^method isDebuggable
]

{ #category : #comparing }
CompiledBlock >> loadFrom: anArray [
	method := anArray at: 1.
	format := anArray at: 2.
	3 to: anArray size do: [:i | | ai |
		ai := anArray at: i.
		self at: i - 2 put: ai]
]

{ #category : #private }
CompiledBlock >> maxArity [
	^(1 bitShift: ArgCount length) - 1
]

{ #category : #private }
CompiledBlock >> maxBlockNumber [
	^(1 bitShift: Id length) - 1
]

{ #category : #accessing }
CompiledBlock >> method [
	^method
]

{ #category : #accessing }
CompiledBlock >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #comparing }
CompiledBlock >> nativeCode [
	^nativeCode
]

{ #category : #comparing }
CompiledBlock >> nativeCode: code [
	code block: self.
	nativeCode := code
]

{ #category : #comparing }
CompiledBlock >> printOn: aStream [
	self class printOn: aStream.
	aStream nextPut: $(.
	self basicPrintOn: aStream.
	(1 to: self size)
		do: [:i | | field tag rest |
			field := self at: i.
			field ifNil: [aStream nextPutAll: 'nil'] ifNotNil: [
				tag := field bitShift: -27.
				rest := field bitAnd: 16r7FFFFFF.
				aStream
					nextPut: $[;
					nextPutAll: tag asString;
					space;
					nextPutAll: rest asString;
					nextPut: $]]]
		separatedBy: [aStream space].
	aStream nextPut: $)
]

{ #category : #accessing }
CompiledBlock >> tempCount [
	^format bitsAt: TempCount
]

{ #category : #accessing }
CompiledBlock >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : #accessing }
CompiledBlock >> templateIndex [
	| n |
	n := self blockNumber.
	^method literals
		findFirst: [:literal | literal isBlock and: [literal blockNumber = n]]
		ifAbsent: [self ASSERT: false]
]

{ #category : #private }
CompiledBlock >> temporaryLimit [
	^(1 bitShift: TempCount length) - 1
]

{ #category : #isEvaluating }
CompiledBlock >> valueSelector [
	| arity |
	arity := self arity.
	arity = 0 ifTrue: [^#value].
	arity = 1 ifTrue: [^#value:].
	arity = 2 ifTrue: [^#value:value:].
	arity = 3 ifTrue: [^#value:value:value:].
	arity = 4 ifTrue: [^#value:value:value:value:].
	self ASSERT: false.
	^#valueWithArguments:
]

