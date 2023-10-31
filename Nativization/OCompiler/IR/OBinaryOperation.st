"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBinaryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'left',
		'right'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OBinaryOperation class >> left: left right: right [
	^self new left: left; right: right
]

{ #category : #'instance creation' }
OBinaryOperation class >> left: left right: right name: selector [
	^self new
		left: left;
		right: right;
		name: selector
]

{ #category : #inquiries }
OBinaryOperation >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^named == #left ifTrue: [left] ifFalse: [right]
]

{ #category : #services }
OBinaryOperation >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	^operandName = #left
		ifTrue: [left := instruction]
		ifFalse: [right := instruction]
]

{ #category : #visitor }
OBinaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitBinary: self
]

{ #category : #printing }
OBinaryOperation >> basicPrintString [
	^'[' , left primitivePrintString , ' ' , name , ' '
		, right primitivePrintString
		, ']'
]

{ #category : #testing }
OBinaryOperation >> canHaveSideEffects [
	^name = #_transferControlTo:
]

{ #category : #private }
OBinaryOperation >> commuted [
	^self class left: right right: left name: name
]

{ #category : #copying }
OBinaryOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	left isONode ifTrue: [copy left: (left duplicateWith: map)].
	right isONode ifTrue: [copy right: (right duplicateWith: map)]
]

{ #category : #services }
OBinaryOperation >> invertOperation [
	name == #'<' ifTrue: [^name := #'>'].
	name == #'<=' ifTrue: [^name := #'>='].
	name == #'>' ifTrue: [^name := #'<'].
	name == #'>=' ifTrue: [^name := #'<='].
	(#(+ * & | bitAnd: bitOr: = == != ~= !==) includes: name) ifTrue: [^name].
	self _ASSERT: false
]

{ #category : #testing }
OBinaryOperation >> isBoolean [
	^self isComparison
]

{ #category : #testing }
OBinaryOperation >> isCommutative [
	^false
]

{ #category : #accessing }
OBinaryOperation >> left [
	^left
]

{ #category : #accessing }
OBinaryOperation >> left: anInstruction [
	left ifNotNil: [left removeUse: self at: #left].
	left := anInstruction.
	left addUse: self at: #left
]

{ #category : #services }
OBinaryOperation >> negateOperation [
	name == #'<' ifTrue: [^name := #'>='].
	name == #'<=' ifTrue: [^name := #'>'].
	name == #'>' ifTrue: [^name := #'<='].
	name == #'>=' ifTrue: [name := #'<']
]

{ #category : #enumerating }
OBinaryOperation >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: left; value: right
]

{ #category : #printing }
OBinaryOperation >> printStringUsing: names [
	^(names at: left ifAbsent: ['?']) , ' ' , name , ' '
		, (names at: right ifAbsent: ['?'])
]

{ #category : #accessing }
OBinaryOperation >> right [
	^right
]

{ #category : #accessing }
OBinaryOperation >> right: anInstruction [
	right ifNotNil: [right removeUse: self at: #right].
	right := anInstruction.
	right addUse: self at: #right
]

{ #category : #services }
OBinaryOperation >> swapOperands [
	| temp |
	temp := left.
	self left: right; right: temp
]

{ #category : #testing }
OBinaryOperation >> usesResultOf: anInstruction [
	^left == anInstruction or: [right == anInstruction]
]

