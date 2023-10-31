"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ONullaryOperation,
	#superclass : #OPrimitiveOperation,
	#category : #IR
}

{ #category : #'instance creation' }
ONullaryOperation class >> named: aString [
	^self new name: aString
]

{ #category : #accessing }
ONullaryOperation >> atOperand: operandName [
	^self error: 'operation has no operands'
]

{ #category : #services }
ONullaryOperation >> atOperand: operandName put: value [
	^self error: 'operation has no operands'
]

{ #category : #visitor }
ONullaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitNullary: self
]

{ #category : #enumerating }
ONullaryOperation >> operandsDo: aBlock [
	
]

{ #category : #printing }
ONullaryOperation >> primitivePrintString [
	^'{' , name , '}'
]

{ #category : #testing }
ONullaryOperation >> usesResultOf: anInstruction [
	^false
]

