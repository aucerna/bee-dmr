"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OInstruction,
	#superclass : #ONode,
	#instVars : [
		'prev',
		'next'
	],
	#category : #IR
}

{ #category : #visitor }
OInstruction >> acceptVisitor: aVisitor [
	| following current |
	current := self.
	[
		following := current next.
		current isEnd]
		whileFalse: [
			current basicAcceptVisitor: aVisitor.
			current := current next ifNil: [following]]
]

{ #category : #'adding / removing' }
OInstruction >> addLast: anInstruction [
	next addLast: anInstruction
]

{ #category : #'adding / removing' }
OInstruction >> addNext: anInstruction [
	^self afterInsert: anInstruction
]

{ #category : #'adding / removing' }
OInstruction >> afterConnect: anInstruction [
	anInstruction prev: self.
	next := anInstruction
]

{ #category : #'adding / removing' }
OInstruction >> afterInsert: anInstruction [
	anInstruction afterConnect: next.
	self afterConnect: anInstruction
]

{ #category : #'adding / removing' }
OInstruction >> afterInsert: start to: end [
	end afterConnect: next.
	self afterConnect: start
]

{ #category : #'adding / removing' }
OInstruction >> afterInsertAll: anInstruction [
	self afterInsert: anInstruction to: anInstruction last
]

{ #category : #services }
OInstruction >> assureBoundBy: binder [
	
]

{ #category : #inquiries }
OInstruction >> basicBlock [
	^prev ifNotNil: [prev basicBlock]
]

{ #category : #'adding / removing' }
OInstruction >> beforeInsert: anInstruction [
	prev afterConnect: anInstruction.
	^anInstruction afterConnect: self
]

{ #category : #'adding / removing' }
OInstruction >> beforeInsertAll: anInstruction [
	| last |
	last := anInstruction "last".
	last next: self.
	anInstruction prev: prev.
	prev next: anInstruction.
	prev := last.
	self shouldBeImplemented
]

{ #category : #copying }
OInstruction >> copyTo: copy with: map [
	super copyTo: copy with: map.
	prev ifNotNil: [copy prev: (prev duplicateWith: map)].
	next ifNotNil: [copy next: (next duplicateWith: map)]
]

{ #category : #enumerating }
OInstruction >> detect: aBlock [
	^self detect: aBlock ifNone: [self errorAbsentObject]
]

{ #category : #enumerating }
OInstruction >> detect: aBlock ifNone: absentBlock [
	^(aBlock value: self)
		ifTrue: [self]
		ifFalse: [next detect: aBlock ifNone: absentBlock]
]

{ #category : #services }
OInstruction >> dissolveDeep [
	prev ifNil: [^self].
	super dissolveDeep
]

{ #category : #services }
OInstruction >> dissolveReplacingWith: anInstruction [
	anInstruction afterConnect: next.
	prev afterConnect: anInstruction.
	prev := next := nil.
	self
		operandsDo: [:instruction | instruction
			removeUseBy: self;
			dissolveIfUseless];
		replaceAllUsesWith: anInstruction
]

{ #category : #enumerating }
OInstruction >> do: aBlock [
	| following |
	following := next.
	aBlock value: self.
	next ifNil: [following do: aBlock] ifNotNil: [next do: aBlock]
]

{ #category : #inquiries }
OInstruction >> firstNonPhi [
	| current |
	current := self.
	[current isPhi] whileTrue: [current := current next].
	^current
]

{ #category : #testing }
OInstruction >> hasNext [
	^true
]

{ #category : #testing }
OInstruction >> hasPrev [
	^true
]

{ #category : #testing }
OInstruction >> isInstruction [
	^true
]

{ #category : #testing }
OInstruction >> isScheduled [
	^prev !== nil or: [next !== nil]
]

{ #category : #inquiries }
OInstruction >> last [
	^next last
]

{ #category : #inquiries }
OInstruction >> lastPhi [
	| current |
	current := self.
	[current next isPhi] whileTrue: [current := current next].
	^current
]

{ #category : #inquiries }
OInstruction >> lastValue [
	| last |
	last := self last.
	^last isJump ifTrue: [last prev] ifFalse: [last]
]

{ #category : #testing }
OInstruction >> livesAfter: anInstruction [
	anInstruction
		nextDetect: [:instruction | instruction usesResultOf: self]
		ifNone: [^false].
	^true
]

{ #category : #testing }
OInstruction >> livesAfter: anInstruction orOutOf: aBasicBlock [
	^(self livesAfter: anInstruction) or: [self livesOutOfBlock: aBasicBlock]
]

{ #category : #testing }
OInstruction >> livesOutOfBlock: aBasicBlock [
	aBasicBlock successorsPostOrder
		reverseDo: [:block | (block usesResultOf: self) ifTrue: [^true]].
	^false
]

{ #category : #accessing }
OInstruction >> next [
	^next
]

{ #category : #accessing }
OInstruction >> next: anInstruction [
	self DENY: (self isJump and: [anInstruction isEnd not]).
	next := anInstruction
]

{ #category : #enumerating }
OInstruction >> nextDetect: aBlock ifNone: absentBlock [
	^next detect: aBlock ifNone: absentBlock
]

{ #category : #accessing }
OInstruction >> prev [
	^prev
]

{ #category : #accessing }
OInstruction >> prev: anInstruction [
	prev := anInstruction
]

{ #category : #printing }
OInstruction >> printBackwardOn: aStream [
	aStream size > 1000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	prev printBackwardOn: aStream.
	aStream nextPutAll: self basicPrintString; cr
]

{ #category : #printing }
OInstruction >> printForwardOn: aStream [
	aStream size > 100000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream nextPutAll: self basicPrintString; cr.
	next printForwardOn: aStream
]

{ #category : #printing }
OInstruction >> printForwardOn: aStream using: names [
	aStream size > 10000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream
		nextPutAll: (names at: self ifAbsent: '?');
		nextPutAll: ' := ';
		nextPutAll: (self printStringUsing: names);
		cr.
	next printForwardOn: aStream using: names
]

{ #category : #enumerating }
OInstruction >> realReverseDo: aBlock [
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following realReverseDo: aBlock]
		ifNotNil: [prev realReverseDo: aBlock]
]

{ #category : #'adding / removing' }
OInstruction >> remove [
	prev afterConnect: next.
	prev := next := nil
]

{ #category : #services }
OInstruction >> replaceIn: block inlining: anOBlockClosure into: inlinerFunction [
	| return after result exit jump |
	anOBlockClosure moveTemporariesTo: inlinerFunction.
	anOBlockClosure receiver
		replaceAllUsesWith: anOBlockClosure parent receiver;
		dissolve.
	return := anOBlockClosure returnValue.
	after := block splitAfter: self.
	block endWithJumpTo: anOBlockClosure start.
	result := return source.
	exit := return basicBlock.
	jump := return next.
	self replaceAllUsesWith: result; dissolve.
	return dissolve.
	jump dissolve.
	exit endWithJumpTo: after.
	anOBlockClosure stop replaceAllUsesWith: inlinerFunction stop.
	^result -> after
]

{ #category : #services }
OInstruction >> replaceWithCopyOf: value [
	| instruction |
	instruction := ((value isUsedOnlyBy: self) andNot: [value isPhi])
		ifTrue: [value remove]
		ifFalse: [value newCopy].
	self dissolveReplacingWith: instruction.
	^instruction
]

{ #category : #enumerating }
OInstruction >> reverseDo: aBlock [
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following reverseDo: aBlock]
		ifNotNil: [prev reverseDo: aBlock]
]

{ #category : #enumerating }
OInstruction >> successorsDo: aBlock [
	
]

{ #category : #inquiries }
OInstruction >> targets [
	^OrderedCollection new
]

{ #category : #services }
OInstruction >> useDistanceTo: value [
	| count |
	count := 0.
	self do: [:instruction | 
		(instruction usesResultOf: value) ifTrue: [^count].
		count := count + 1].
	^Number infinity
]

