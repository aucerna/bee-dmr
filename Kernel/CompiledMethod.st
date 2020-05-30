"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompiledMethod,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'astcodes',
		'nativeCode',
		'class',
		'selector',
		'source',
		'format'
	],
	#classVars : [
		'Flags'
	],
	#category : #Kernel
}

{ #category : #inspecting }
CompiledMethod class >> aspects [
	^#(#astcodeString #disassembledText)
]

{ #category : #initialization }
CompiledMethod class >> initializeFormatFlags [
	Flags := PoolDictionary newConstantPool.
	Flags
		at: 'ArgCount' put: (1 thru: 6);
		at: 'BlockCount' put: (7 thru: 17);
		at: 'TempCount' put: (18 thru: 28);
		at: 'TypeField' put: (29 thru: 31);
		at: 'EnvCount' put: (32 thru: 42);
		at: 'Debuggable' put: (1 bitShift: 28);
		at: 'DMR' put: (1 bitShift: 29);
		at: 'HasBlock' put: (1 bitShift: 30)
]

{ #category : #initialization }
CompiledMethod class >> maxArgCount [
	^(2 raisedTo: ArgCount length) - 1
]

{ #category : #initialization }
CompiledMethod class >> maxBlockCount [
	^(2 raisedTo: BlockCount length) - 1
]

{ #category : #initialization }
CompiledMethod class >> maxTempCount [
	^(2 raisedTo: TempCount length) - 1
]

{ #category : #'instance creation' }
CompiledMethod class >> new: anInteger [
	| cm |
	cm := super new: anInteger.
	^cm initialize
]

{ #category : #comparing }
CompiledMethod >> ~ aCompiledMethod [
	self literals = aCompiledMethod literals ifFalse: [^false].
	^astcodes = aCompiledMethod astcodes
]

{ #category : #comparing }
CompiledMethod >> = anObject [
	^self == anObject
]

{ #category : #queries }
CompiledMethod >> addSymbolsIn: anArray to: aSet [
	anArray do: [:elem | 
		elem isSymbol
			ifTrue: [aSet add: elem]
			ifFalse: [elem class == Array ifTrue: [self addSymbolsIn: elem to: aSet]]]
]

{ #category : #accessing }
CompiledMethod >> argumentCount [
	^format bitsAt: ArgCount
]

{ #category : #accessing }
CompiledMethod >> argumentCount: anInteger [
	format := format bitsAt: ArgCount put: anInteger
]

{ #category : #converting }
CompiledMethod >> asOverridden [
	^self
]

{ #category : #accessing }
CompiledMethod >> beDMRVersion [
	format := format bitOr: DMR
]

{ #category : #accessing }
CompiledMethod >> blockCount [
	^format bitsAt: BlockCount
]

{ #category : #accessing }
CompiledMethod >> blockCount: anInteger [
	anInteger > 0 ifTrue: [format := format bitOr: HasBlock].
	format := format bitsAt: BlockCount put: anInteger
]

{ #category : #enumerating }
CompiledMethod >> blocks [
	self hasBlocks ifFalse: [^#()].
	^self select: [:literal | literal isBlock]
]

{ #category : #enumerating }
CompiledMethod >> blocksDo: aBlock [
	self
		select: [:b | b isBlock and: [b method == self]]
		thenDo: [:b | aBlock evaluateWith: b]
]

{ #category : #accessing }
CompiledMethod >> astcodes [
	^astcodes
]

{ #category : #accessing }
CompiledMethod >> astcodes: aByteArray [
	astcodes := aByteArray
]

{ #category : #testing }
CompiledMethod >> canBeInstalled [
	^self isExpression not
]

{ #category : #accessing }
CompiledMethod >> classBinding [
	^class
]

{ #category : #accessing }
CompiledMethod >> classBinding: aClass [
	class := aClass
]

{ #category : #queries }
CompiledMethod >> currentVersion [
	^class compiledMethodAt: selector
]

{ #category : #private }
CompiledMethod >> dmrVersion [
	^nil
]

{ #category : #accessing }
CompiledMethod >> environmentCount [
	^format bitsAt: EnvCount
]

{ #category : #accessing }
CompiledMethod >> environmentCount: anInteger [
	format bitsAt: EnvCount put: anInteger
]

{ #category : #evaluation }
CompiledMethod >> executeOn: receiver withArguments: anArray [
	| size |
	self prepareForExecution.
	size := anArray basicSize.
	self argumentCount = size ifFalse: [^self error: 'incorrect arity'].
	anArray _expandInStackSized: size.
	^receiver _invoke: self validNativeCodeAddress _asNative
]

{ #category : #accessing }
CompiledMethod >> format [
	^format
]

{ #category : #accessing }
CompiledMethod >> format: anInteger [
	format := anInteger
]

{ #category : #testing }
CompiledMethod >> hasBlocks [
	^self blockCount > 0
]

{ #category : #services }
CompiledMethod >> hasEnvironment [
	^self environmentCount > 0
]

{ #category : #comparing }
CompiledMethod >> hash [
	^selector hashWith: class
]

{ #category : #accessing }
CompiledMethod >> hasNativeCode [
	^nativeCode != nil
]

{ #category : #initialization }
CompiledMethod >> initialize [
	super initialize.
	format := 0
]

{ #category : #actions }
CompiledMethod >> install [
	class addSelector: selector withMethod: self
]

{ #category : #accessing }
CompiledMethod >> invalidateNativeCode [
	nativeCode := nil.
	self blocksDo: [:b | b invalidateNativeCode]
]

{ #category : #testing }
CompiledMethod >> isCallback [
	^false
]

{ #category : #testing }
CompiledMethod >> isCompiledMethod [
	^true
]

{ #category : #testing }
CompiledMethod >> isCurrentVersion [
	^class notNil and: [self == (class compiledMethodAt: selector)]
]

{ #category : #testing }
CompiledMethod >> isDebuggable [
	^format isOnBit: Debuggable
]

{ #category : #accessing }
CompiledMethod >> isDMRVersion [
	^format isOnBit: DMR
]

{ #category : #accessing }
CompiledMethod >> isDoit [
	^false
]

{ #category : #testing }
CompiledMethod >> isExpression [
	^false
]

{ #category : #testing }
CompiledMethod >> isFFIMethod [
	^false
]

{ #category : #unclassified }
CompiledMethod >> isNativized [
	^false == (nativeCode == nil)
]

{ #category : #testing }
CompiledMethod >> isOverridden [
	^false
]

{ #category : #accessing }
CompiledMethod >> literalIndexFrom: grossIndex [
	| instVars index |
	grossIndex _isSmallInteger ifFalse: [^self outOfBoundsIndex: grossIndex].
	instVars := self class instSize.
	(1 <= grossIndex and: [grossIndex <= (self _size - instVars)])
		ifFalse: [^self outOfBoundsIndex: grossIndex].
	index := grossIndex + instVars.
	^index
]

{ #category : #accessing }
CompiledMethod >> literals [
	^Array withAll: self
]

{ #category : #accessing }
CompiledMethod >> method [
	^self
]

{ #category : #accessing }
CompiledMethod >> nativeCode [
	^nativeCode
]

{ #category : #accessing }
CompiledMethod >> nativeCode: code [
	nativeCode := code
]

{ #category : #accessing }
CompiledMethod >> nativeCodeAddress [
	nativeCode isNil ifTrue: [self nativize].
	nativeCode nativeCodeAddress
]

{ #category : #services }
CompiledMethod >> nativize [
	nativeCode := Smalltalk nativizer nativeCodeFor: self
]

{ #category : #copying }
CompiledMethod >> postCopy [
	super postCopy.
	self
		withIndexDo: [:b :i | | c |
			b isBlock ifTrue: [
				c := b copy method: self.
				self at: i put: c]];
		updateNativeCode
]

{ #category : #unclassified }
CompiledMethod >> prepareForExecution [
	self isNativized ifFalse: [self nativize].
	nativeCode isFresh ifFalse: [
		nativeCode acquireReferences.
		self refreshBlocks]
]

{ #category : #accessing }
CompiledMethod >> primitiveNumber [
	^0
]

{ #category : #printing }
CompiledMethod >> printOn: aStream [
	aStream
		print: class;
		nextPutAll: '>>';
		print: selector
]

{ #category : #unclassified }
CompiledMethod >> refreshBlocks [
	| blocks |
	blocks := self blocks.
	1 to: blocks size do: [:index | | block |
		block := blocks at: index.
		block nativeCode refresh]
]

{ #category : #accessing }
CompiledMethod >> selector [
	^selector
]

{ #category : #accessing }
CompiledMethod >> selector: aSymbol [
	selector := aSymbol.
	nativeCode notNil ifTrue: [self invalidateNativeCode; nativize]
]

{ #category : #accessing }
CompiledMethod >> selectorAt: index [
	^self at: self size - index + 1
]

{ #category : #accessing }
CompiledMethod >> sendSites [
	^nativeCode sendSites
]

{ #category : #'source code support' }
CompiledMethod >> sourceObject [
	^source
]

{ #category : #accessing }
CompiledMethod >> tempCount [
	^format bitsAt: TempCount
]

{ #category : #accessing }
CompiledMethod >> tempCount: anInteger [
	format := format bitsAt: TempCount put: anInteger
]

{ #category : #accessing }
CompiledMethod >> timestamp [
	| s |
	s := self sourceReference.
	^(s respondsTo: #timestamp) ifTrue: [s timestamp]
]

{ #category : #accessing }
CompiledMethod >> type [
	self ASSERT: false.
	^format bitsAt: TypeField
]

{ #category : #accessing }
CompiledMethod >> type: anInteger [
	self ASSERT: false.
	format := format bitsAt: TypeField put: anInteger.
	anInteger > 3
		ifTrue: [format := (format negated bitAnd: 16r7FFFFFFF) negated]
]

{ #category : #accessing }
CompiledMethod >> updateNativeCode [
	nativeCode ifNil: [^self].
	self invalidateNativeCode; prepareForExecution
]

{ #category : #unclassified }
CompiledMethod >> validNativeCodeAddress [
	^nativeCode code _asSmallInteger
]

