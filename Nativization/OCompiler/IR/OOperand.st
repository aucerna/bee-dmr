"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OOperand,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'name',
		'nextUse'
	],
	#category : #IR
}

{ #category : #unclassified }
OOperand class >> at: anInstruction named: operandName [
	^self new instruction: anInstruction; name: operandName
]

{ #category : #unclassified }
OOperand class >> valued: anInstruction [
	^self new value: anInstruction
]

{ #category : #unclassified }
OOperand class >> valued: anInstruction in: containingInstruction [
	^self new value: anInstruction; instruction: containingInstruction
]

{ #category : #'adding / removing' }
OOperand >> addUse: anOperand [
	self DENY: self == anOperand.
	nextUse ifNil: [nextUse := anOperand] ifNotNil: [nextUse addUse: anOperand]
]

{ #category : #inquiries }
OOperand >> definition [
	^instruction atOperand: name
]

{ #category : #accessing }
OOperand >> instruction [
	^instruction
]

{ #category : #accessing }
OOperand >> instruction: anInstruction [
	instruction := anInstruction
]

{ #category : #accessing }
OOperand >> name [
	^name
]

{ #category : #accessing }
OOperand >> name: operandName [
	name := operandName
]

{ #category : #accessing }
OOperand >> nextUse [
	^nextUse
]

{ #category : #accessing }
OOperand >> nextUse: anOOperand [
	nextUse := anOOperand
]

{ #category : #printing }
OOperand >> printOn: aStream [
	aStream
		nextPutAll: '[op #' , name printString , '@' , instruction printString
			, ']'
]

{ #category : #'adding / removing' }
OOperand >> removeUse: anOperand [
	nextUse instruction == anOperand
		ifTrue: [
			nextUse := nextUse nextUse.
			anOperand nextUse: nil]
		ifFalse: [nextUse removeUse: anOperand]
]

{ #category : #'adding / removing' }
OOperand >> removeUse: anInstruction at: aName [
	(nextUse instruction == anInstruction and: [nextUse name = aName])
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUse: anInstruction at: aName]
]

{ #category : #'adding / removing' }
OOperand >> removeUseBy: anInstruction [
	nextUse instruction == anInstruction
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUseBy: anInstruction]
]

{ #category : #'adding / removing' }
OOperand >> removeUsesSuchThat: aBlock [
	[nextUse notNil and: [aBlock value: nextUse]]
		whileTrue: [nextUse := nextUse nextUse].
	nextUse ifNotNil: [nextUse removeUsesSuchThat: aBlock]
]

{ #category : #services }
OOperand >> replaceAllUsesWith: otherInstruction [
	| following |
	following := nextUse.
	self transferUseTo: otherInstruction.
	following ifNotNil: [following replaceAllUsesWith: otherInstruction]
]

{ #category : #services }
OOperand >> replaceUsesBy: user with: otherInstruction [
	| following |
	following := nextUse.
	instruction == user ifTrue: [self transferUseTo: otherInstruction].
	following ifNotNil: [following replaceUsesBy: user with: otherInstruction]
]

{ #category : #services }
OOperand >> transferUseTo: otherInstruction [
	self DENY: otherInstruction class == OOperand.
	self definition removeUse: self.
	instruction atOperand: name put: otherInstruction.
	otherInstruction addUse: self
]

{ #category : #accessing }
OOperand >> user [
	^instruction
]

{ #category : #enumerating }
OOperand >> usersDo: aBlock [
	aBlock value: self user.
	nextUse ifNotNil: [nextUse usersDo: aBlock]
]

{ #category : #enumerating }
OOperand >> usesDo: aBlock [
	aBlock value: self.
	nextUse ifNotNil: [nextUse usesDo: aBlock]
]

{ #category : #validation }
OOperand >> validate [
	| set op |
	set := IdentitySet new.
	op := self.
	[op notNil] whileTrue: [
		(set includes: op) ifTrue: [self error: 'invalid operand'].
		set add: op.
		op := op nextUse]
]

