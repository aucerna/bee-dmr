"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OConditionalJump,
	#superclass : #OJump,
	#instVars : [
		'variable',
		'implicitTarget'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OConditionalJump class >> variable: operation target: explicitTarget implicitTarget: implicitTarget [
	^self new
		variable: operation;
		target: explicitTarget;
		implicitTarget: implicitTarget
]

{ #category : #inquiries }
OConditionalJump >> atOperand: name [
	(super atOperand: name) ifNotNil: [:op | ^op].
	^variable
]

{ #category : #services }
OConditionalJump >> atOperand: name put: instruction [
	(super atOperand: name put: instruction) ifNotNil: [^self].
	^variable := instruction
]

{ #category : #copying }
OConditionalJump >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		target: (target duplicateWith: map);
		implicitTarget: (implicitTarget duplicateWith: map);
		variable: (variable duplicateWith: map)
]

{ #category : #services }
OConditionalJump >> dissolve [
	implicitTarget removePredecessor: self basicBlock.
	super dissolve
]

{ #category : #services }
OConditionalJump >> dissolveDeep [
	super dissolveDeep.
	implicitTarget dissolveIfUnreachable
]

{ #category : #accessing }
OConditionalJump >> implicitTarget [
	^implicitTarget
]

{ #category : #accessing }
OConditionalJump >> implicitTarget: aBasicBlock [
	implicitTarget := aBasicBlock
]

{ #category : #testing }
OConditionalJump >> isConditionalJump [
	^true
]

{ #category : #enumerating }
OConditionalJump >> operandsDo: aBlock [
	super operandsDo: aBlock.
	aBlock value: variable
]

{ #category : #services }
OConditionalJump >> replaceWithUnconditional: condition in: basicBlock [
	| fixed removed jump |
	self isJumpTrue == condition
		ifTrue: [
			fixed := target.
			removed := implicitTarget]
		ifFalse: [
			fixed := implicitTarget.
			removed := target].
	jump := OJump to: fixed.
	self dissolveReplacingWith: jump.
	removed removePredecessor: basicBlock; dissolveIfUnreachable
]

{ #category : #services }
OConditionalJump >> retargetFrom: aBasicBlock to: otherBasicBlock [
	target == aBasicBlock ifTrue: [target := otherBasicBlock].
	implicitTarget == aBasicBlock ifTrue: [implicitTarget := otherBasicBlock]
]

{ #category : #enumerating }
OConditionalJump >> successorsDo: aBlock [
	aBlock value: target.
	aBlock value: implicitTarget
]

{ #category : #inquiries }
OConditionalJump >> targets [
	^super targets add: implicitTarget; yourself
]

{ #category : #testing }
OConditionalJump >> usesResultOf: anInstruction [
	^variable == anInstruction
]

{ #category : #accessing }
OConditionalJump >> variable [
	^variable
]

{ #category : #accessing }
OConditionalJump >> variable: operand [
	variable := operand.
	variable addUse: self at: #variable
]

