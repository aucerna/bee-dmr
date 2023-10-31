"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingCFGSimplifier,
	#superclass : #Object,
	#instVars : [
		'method',
		'stop',
		'returnBlock'
	],
	#category : #OCompiler
}

{ #category : #'adding / removing' }
OptimizingCFGSimplifier >> addPredecessor: predecessor like: middle to: final [
	final phisDo: [:phi | | source |
		source := phi atOperand: middle.
		phi addVariable: source from: predecessor].
	^final
]

{ #category : #testing }
OptimizingCFGSimplifier >> canSimplify: block [
	block == stop ifTrue: [^false].
	(block successors includes: stop) ifTrue: [^false].
	^true
]

{ #category : #services }
OptimizingCFGSimplifier >> clean: anOMethod [
	| all |
	method := anOMethod.
	stop := method stop.
	returnBlock := method returnValue basicBlock.
	all := method start successorsPostOrder.
	[self simplify] whileTrue: [all do: [:block | block dissolveIfUnreachable]]
]

{ #category : #private }
OptimizingCFGSimplifier >> hoistBranchIn: succ to: pred [
	| jump branch condition new target1 target2 |
	jump := pred lastInstruction.
	branch := succ lastInstruction.
	condition := branch variable.
	succ
		phisDo: [:phi | condition := phi atOperand: pred];
		removePredecessor: pred.
	target1 := self addPredecessor: pred like: succ to: branch target.
	target2 := self addPredecessor: pred like: succ to: branch implicitTarget.
	jump remove.
	new := pred
		endWith: branch class
		to: target1
		skipping: target2
		if: condition.
	jump replaceAllUsesWith: new
]

{ #category : #services }
OptimizingCFGSimplifier >> simplify [
	| changed |
	changed := false.
	method start postOrderDo: [:block | 
		(self canSimplify: block) ifTrue: [
			changed := (self tryFoldingRedundantBranch: block) or: changed.
			changed := (self tryRemovingEmptyBlock: block) or: changed.
			changed ifFalse: [
				changed := self tryCombining: block.
				changed
					ifFalse: [changed := (self tryHoistingBranch: block) or: changed]]]].
	^changed
]

{ #category : #private }
OptimizingCFGSimplifier >> tryCombining: block [
	| last following |
	last := block lastInstruction.
	last isUnconditionalJump ifFalse: [^false].
	following := last target.
	following == returnBlock ifTrue: [^false].
	following hasMultiplePredecessors ifTrue: [^false].
	following phisDo: [:phi | phi removeIfPossible].
	last dissolve.
	following moveAllTo: block.
	^true
]

{ #category : #private }
OptimizingCFGSimplifier >> tryFoldingRedundantBranch: block [
	| last |
	last := block lastInstruction.
	(last isConditionalJump and: [last target == last implicitTarget])
		ifTrue: [| jump |
			jump := OJump to: last target.
			last dissolveReplacingWith: jump.
			^true].
	(last isConditionalJump and: [last variable isConstant]) ifTrue: [
		last replaceWithUnconditional: last variable value in: block.
		^true].
	^false
]

{ #category : #private }
OptimizingCFGSimplifier >> tryHoistingBranch: block [
	| last following |
	last := block lastInstruction.
	(last isUnconditionalJump and: [
		following := last target.
		following isEmptyBranch or: [following isEmptyPhiBranch]])
		ifTrue: [
			self hoistBranchIn: following to: block.
			^true].
	^false
]

{ #category : #private }
OptimizingCFGSimplifier >> tryRemovingEmptyBlock: block [
	| following |
	block isEmptyJump ifTrue: [
		following := block lastInstruction target.
		block predecessors do: [:predecessor | 
			predecessor lastInstruction retargetFrom: block to: following.
			following addPredecessor: predecessor].
		following incorporatePhisFrom: block; removePredecessor: block.
		^true].
	^false
]

