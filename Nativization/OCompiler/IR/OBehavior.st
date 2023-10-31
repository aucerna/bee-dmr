"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBehavior,
	#superclass : #OInstruction,
	#instVars : [
		'object'
	],
	#category : #IR
}

{ #category : #inquiries }
OBehavior >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^named == #object ifTrue: [object]
]

{ #category : #inquiries }
OBehavior >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName = #object ifTrue: [object := instruction]
]

{ #category : #visitor }
OBehavior >> basicAcceptVisitor: aVisitor [
	^aVisitor visitBehavior: self
]

{ #category : #copying }
OBehavior >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy object: (object duplicateWith: map)
]

{ #category : #moving }
OBehavior >> lowerIn: aBasicBlock [
	self
		usesDo: [:use | | inst |
			inst := use user.
			inst isLoad
				ifTrue: [self lowerLoad: inst in: aBasicBlock]
				ifFalse: [self lowerStore: inst]];
		dissolve
]

{ #category : #private }
OBehavior >> lowerLoad: aLoad in: aBasicBlock [
	| constant test behavior |
	constant := SmallInteger instanceBehavior asMoveConstant.
	test := OIsSmallInteger receiver: object.
	aLoad beforeInsert: constant; beforeInsert: test.
	aBasicBlock
		splitAfter: self
		if: test
		evaluating: [:smibb :heapbb :mergebb | | header |
			header := OLoadOperation base: object longSlotAtImm: 0.
			heapbb add: header.
			behavior := OPhi new.
			mergebb addFront: behavior.
			behavior
				addVariable: constant from: smibb;
				addVariable: header from: heapbb].
	aLoad replaceAllUsesWith: behavior; dissolve
]

{ #category : #accessing }
OBehavior >> object [
	^object
]

{ #category : #accessing }
OBehavior >> object: anONode [
	object := anONode.
	anONode addUse: self at: #object
]

{ #category : #enumerating }
OBehavior >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: object
]

{ #category : #printing }
OBehavior >> primitivePrintString [
	^'{behavior}'
]

