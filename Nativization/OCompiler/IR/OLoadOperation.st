"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OLoadOperation,
	#superclass : #OMemoryOperation,
	#category : #IR
}

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction byteAt: anInteger [
	^self new
		name: #_byteAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction byteAtImm: anInteger [
	^self new
		name: #_byteAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction longSlotAt: anInteger [
	^self new
		name: #_longSlotAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction longSlotAtImm: anInteger [
	^self new
		name: #_longSlotAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction slotAt: anInteger [
	^self new
		name: #_basicAt:;
		base: anInstruction;
		index: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction slotAtImm: anInteger [
	^self new
		name: #_basicAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #'instance creation' }
OLoadOperation class >> base: anInstruction uLongAtImm: anInteger [
	^self new
		name: #_uLongAt:;
		base: anInstruction;
		indexImm: anInteger
]

{ #category : #visitor }
OLoadOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitLoad: self
]

{ #category : #printing }
OLoadOperation >> basicPrintString [
	^'[' , base primitivePrintString , ' ' , name , ' '
		, index primitivePrintString
		, ']'
]

{ #category : #testing }
OLoadOperation >> canHaveSideEffects [
	^false
]

{ #category : #private }
OLoadOperation >> findDominatingStore [
	| current |
	current := self prev.
	[current notNil] whileTrue: [
		(current isStore and: [current writesAddressReadBy: self])
			ifTrue: [^current].
		current := (current class == OBasicBlock and: [current hasOnePredecessor])
			ifTrue: [current predecessors first lastInstruction]
			ifFalse: [current prev]].
	^nil
]

{ #category : #testing }
OLoadOperation >> isLoad [
	^true
]

{ #category : #services }
OLoadOperation >> optimized [
	^self findDominatingStore ifNil: [self] ifNotNil: [:store | store value]
]

{ #category : #printing }
OLoadOperation >> printStringUsing: names [
	| b i |
	b := names at: base ifAbsent: ['?'].
	i := index isONode
		ifTrue: [names at: index ifAbsent: ['?']]
		ifFalse: [index printString].
	^'{#' , b , ' ' , name , ', ' , i , '}'
]

