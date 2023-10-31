"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OStoreOperation,
	#superclass : #OMemoryOperation,
	#instVars : [
		'value'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction byteAt: indexInstruction put: anotherInstruction [
	^self new
		name: #_byteAt:put:;
		base: anInstruction;
		index: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction byteAtImm: anInteger put: anotherInstruction [
	^self new
		name: #_byteAt:put:;
		base: anInstruction;
		indexImm: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction longSlotAt: indexInstruction put: anotherInstruction [
	^self new
		name: #_longSlotAt:put:;
		base: anInstruction;
		index: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction longSlotAtImm: indexInstruction put: anotherInstruction [
	^self new
		name: #_longSlotAt:put:;
		base: anInstruction;
		indexImm: indexInstruction;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction slotAt: anInteger put: anotherInstruction [
	^self new
		name: #_basicAt:put:;
		base: anInstruction;
		index: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction slotAtImm: anInteger put: anotherInstruction [
	^self new
		name: #_basicAt:put:;
		base: anInstruction;
		indexImm: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction uLongAt: anInteger put: anotherInstruction [
	^self new
		name: #_uLongAt:put:;
		base: anInstruction;
		index: anInteger;
		value: anotherInstruction
]

{ #category : #'instance creation' }
OStoreOperation class >> base: anInstruction uLongAtImm: indexInstruction put: anotherInstruction [
	^self new
		name: #_uLongAt:put:;
		base: anInstruction;
		indexImm: indexInstruction;
		value: anotherInstruction
]

{ #category : #accessing }
OStoreOperation >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^value
]

{ #category : #services }
OStoreOperation >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^value := instruction
]

{ #category : #visitor }
OStoreOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitStore: self
]

{ #category : #printing }
OStoreOperation >> basicPrintString [
	| b |
	b := base isONode
		ifTrue: [base primitivePrintString]
		ifFalse: [base printString].
	^'[' , b , ' ' , name , ' ' , index primitivePrintString , ', '
		, value primitivePrintString
		, ']'
]

{ #category : #copying }
OStoreOperation >> copyTo: copy with: map [
	| v |
	super copyTo: copy with: map.
	v := value isONode ifTrue: [value duplicateWith: map] ifFalse: [value].
	copy value: v
]

{ #category : #testing }
OStoreOperation >> isStore [
	^true
]

{ #category : #enumerating }
OStoreOperation >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: value
]

{ #category : #printing }
OStoreOperation >> printStringUsing: names [
	| b i v |
	b := names at: base ifAbsent: '?'.
	i := index isONode
		ifTrue: [names at: index ifAbsent: '?']
		ifFalse: [index printString].
	v := value isONode
		ifTrue: [names at: value ifAbsent: '?']
		ifFalse: [value printString].
	^'{#' , b , ' ' , name , ', ' , i , ',' , v , '}'
]

{ #category : #testing }
OStoreOperation >> usesResultOf: anInstruction [
	^value == anInstruction or: [super usesResultOf: anInstruction]
]

{ #category : #accessing }
OStoreOperation >> value [
	^value
]

{ #category : #accessing }
OStoreOperation >> value: anInstruction [
	value := anInstruction.
	anInstruction addUse: self at: #value
]

{ #category : #accessing }
OStoreOperation >> valueImm: anObject [
	value := anObject
]

{ #category : #testing }
OStoreOperation >> writesAddressReadBy: anOLoad [
	| loadIndex constant |
	base == anOLoad base ifFalse: [^false].
	name == anOLoad name ifFalse: [^false].
	loadIndex := anOLoad index.
	(index isONode not or: [index isConstant]) ifTrue: [
		constant := index value.
		^loadIndex isONode
			ifTrue: [loadIndex isConstant and: [loadIndex value == constant]]
			ifFalse: [loadIndex == constant]].
	^index == anOLoad index
]

