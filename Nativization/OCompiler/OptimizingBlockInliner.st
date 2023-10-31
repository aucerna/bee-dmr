"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingBlockInliner,
	#superclass : #Object,
	#instVars : [
		'inlinerFunction'
	],
	#category : #OCompiler
}

{ #category : #testing }
OptimizingBlockInliner >> canBeInlined [
	^true
]

{ #category : #services }
OptimizingBlockInliner >> inline: anOMessageSend in: block [
	| selector inliner |
	selector := anOMessageSend selector asString copy replace: $: with: $_.
	inliner := #inline , selector capitalized , ':in:'.
	^self perform: inliner asSymbol with: anOMessageSend with: block
]

{ #category : #accessing }
OptimizingBlockInliner >> inlinerFunction: anOFunction [
	inlinerFunction := anOFunction
]

{ #category : #accessing }
OptimizingBlockInliner >> inliners [
	^#(#value #value: #whileTrue:)
]

{ #category : #services }
OptimizingBlockInliner >> inlineValue: message in: block [
	| closure |
	closure := message receiver.
	closure isBlockClosure ifFalse: [^block].
	^message
		replaceIn: block
		inlining: closure duplicate metaprocess
		into: inlinerFunction
]

{ #category : #services }
OptimizingBlockInliner >> inlineValue_: message in: block [
	| closure duplicated |
	closure := message receiver.
	closure isBlockClosure ifFalse: [^block].
	duplicated := closure duplicate metaprocess.
	duplicated argument first replaceAllUsesWith: message arguments first.
	^message replaceIn: block inlining: duplicated into: inlinerFunction
]

{ #category : #services }
OptimizingBlockInliner >> inlineWhileTrue_: message in: block [
	| antecedent consequent antecedentStart consequentStart antecedentLast consequentLast join antecedentReturn consequentReturn |
	antecedent := message receiver.
	consequent := message arguments first.
	antecedentStart := antecedent start.
	consequentStart := consequent start.
	antecedentLast := antecedentStart lastBlock.
	consequentLast := consequentStart lastBlock.
	antecedentReturn := antecedent returnValue.
	consequentReturn := consequent returnValue.
	antecedentReturn isNonLocal ifFalse: [antecedentReturn dissolve].
	consequentReturn isNonLocal ifFalse: [consequentReturn dissolve].
	join := block splitAfter: message.
	block endWithJumpTo: antecedentStart.
	antecedentLast
		endWithJumpFalseTo: join
		skipping: consequentStart
		if: consequentLast lastValue.
	consequentLast endWithJumpTo: antecedentStart.
	message dissolve.
	^antecedent -> join
]

