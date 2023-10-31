"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OTernaryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'receiver',
		'left',
		'right'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OTernaryOperation class >> receiver: receiver
left: left
right: right
name: selector [
	^self new
		receiver: receiver;
		left: left;
		right: right;
		name: selector
]

{ #category : #inquiries }
OTernaryOperation >> atOperand: named [
	(super atOperand: named) ifNotNil: [:op | ^op].
	^named == #receiver
		ifTrue: [receiver]
		ifFalse: [named == #left ifTrue: [left] ifFalse: [right]]
]

{ #category : #services }
OTernaryOperation >> atOperand: operandName put: instruction [
	(super atOperand: operandName put: instruction) ifNotNil: [^self].
	operandName = #receiver ifTrue: [^receiver := instruction].
	^operandName = #left
		ifTrue: [left := instruction]
		ifFalse: [right := instruction]
]

{ #category : #visitor }
OTernaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitTernary: self
]

{ #category : #printing }
OTernaryOperation >> basicPrintString [
	^'['
		, (receiver isONode
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ' '
		, left primitivePrintString
		, ', '
		, right primitivePrintString
		, ']'
]

{ #category : #testing }
OTernaryOperation >> isTernaryOperation [
	^true
]

{ #category : #accessing }
OTernaryOperation >> left [
	^left
]

{ #category : #accessing }
OTernaryOperation >> left: value [
	left := value.
	left isONode ifTrue: [left addUse: self at: #left]
]

{ #category : #enumerating }
OTernaryOperation >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: receiver.
	left isONode ifTrue: [aBlock value: left].
	aBlock value: right
]

{ #category : #printing }
OTernaryOperation >> printStringUsing: names [
	^(receiver isONode
		ifTrue: [names at: receiver]
		ifFalse: [receiver printString]) , ' ' , name , ' '
		, (left isONode ifTrue: [names at: left] ifFalse: [left printString])
		, ', '
		, (right isONode ifTrue: [names at: right] ifFalse: [right printString])
]

{ #category : #accessing }
OTernaryOperation >> receiver [
	^receiver
]

{ #category : #accessing }
OTernaryOperation >> receiver: value [
	receiver := value.
	receiver addUse: self at: #receiver
]

{ #category : #accessing }
OTernaryOperation >> right [
	^right
]

{ #category : #accessing }
OTernaryOperation >> right: value [
	right := value.
	right addUse: self at: #right
]

{ #category : #testing }
OTernaryOperation >> usesResultOf: anInstruction [
	^receiver == anInstruction
		or: [left == anInstruction or: [right == anInstruction]]
]

