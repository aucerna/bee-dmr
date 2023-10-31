"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBlockClosure,
	#superclass : #OFunction,
	#instVars : [
		'parent',
		'parentEnvironments'
	],
	#category : #IR
}

{ #category : #enumerating }
OBlockClosure >> atOperand: operandName [
	(super atOperand: operandName) ifNotNil: [:op | ^op].
	^operandName == #parent ifTrue: [parent]
]

{ #category : #enumerating }
OBlockClosure >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName == #parent ifTrue: [parent := instruction]
]

{ #category : #copying }
OBlockClosure >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		parentEnvironments: (parentEnvironments
			collect: [:temp | temp duplicateWith: map]);
		parent: parent;
		start: (start duplicateWith: map);
		stop: (stop duplicateWith: map)
]

{ #category : #services }
OBlockClosure >> dissolveDeep [
	start withSuccessorsDo: [:block | block dissolveAllInstructions].
	super dissolveDeep
]

{ #category : #copying }
OBlockClosure >> duplicate [
	| map result |
	map := IdentityDictionary new.
	result := self class new.
	map
		at: self put: result;
		at: start put: result start.
	start
		withSuccessorsDo: [:block | 
			map at: block put: block class new.
			block instructionsDo: [:inst | map at: inst put: inst class new]];
		withSuccessorsDo: [:block | 
			block
				copyTo: (map at: block) with: map;
				instructionsDo: [:inst | | mapped |
					mapped := map at: inst.
					inst copyTo: mapped with: map]].
	self copyTo: result with: map.
	^result validateOperandsAndUses
]

{ #category : #services }
OBlockClosure >> explicitReturn: value from: anOBasicBlock [
	self nonLocalReturn: value from: anOBasicBlock
]

{ #category : #services }
OBlockClosure >> implicitReturn: last from: anOBasicBlock [
	| value |
	value := last ifNil: [| constant |
		constant := nil asMoveConstant.
		anOBasicBlock add: constant].
	self localReturn: value from: anOBasicBlock
]

{ #category : #initialization }
OBlockClosure >> initialize [
	super initialize.
	parentEnvironments := OrderedCollection new
]

{ #category : #testing }
OBlockClosure >> isBlockClosure [
	^true
]

{ #category : #testing }
OBlockClosure >> isUseless [
	self usesDo: [:use | | user |
		user := use user.
		user isProjection
			ifTrue: [user isUseless ifFalse: [^false]]
			ifFalse: [^false]].
	^true
]

{ #category : #inquiries }
OBlockClosure >> lastBlock [
	^start lastBlock
]

{ #category : #moving }
OBlockClosure >> lowerIn: aBasicBlock [
	super lowerIn: aBasicBlock.
	parentEnvironments do: [:env | env lowerLoad]
]

{ #category : #accessing }
OBlockClosure >> method [
	^parent method
]

{ #category : #enumerating }
OBlockClosure >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: parent
]

{ #category : #accessing }
OBlockClosure >> parent [
	^parent
]

{ #category : #accessing }
OBlockClosure >> parent: anOFunction [
	parent := anOFunction.
	anOFunction addUse: self at: #parent
]

{ #category : #accessing }
OBlockClosure >> parentEnvironments [
	^parentEnvironments
]

{ #category : #accessing }
OBlockClosure >> parentEnvironments: aCollection [
	parentEnvironments := aCollection
]

{ #category : #printing }
OBlockClosure >> primitivePrintOn: aStream [
	aStream nextPutAll: '{Block '.
	start primitivePrintOn: aStream.
	aStream nextPutAll: '}'
]

{ #category : #validation }
OBlockClosure >> validateOperandsAndUses [
	start
		instructionsWithSuccessorsDo: [:inst | inst
			validateUses;
			validateOperands]
]

