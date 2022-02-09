"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingBlockInliner,
	#superclass : #Object,
	#instVars : [
		'firstBlock'
	],
	#category : #OCompiler
}

{ #category : #private }
OptimizingBlockInliner >> closureArgumentsIn: aBasicBlock count: anInteger [
	| result remaining |
	result := OrderedCollection new.
	remaining := anInteger.
	aBasicBlock instructionsDo: [:i | 
		remaining = 0 ifTrue: [^result].
		result add: i.
		remaining := remaining - 1].
	^result
]

{ #category : #unclassified }
OptimizingBlockInliner >> doInline [
	self inlineInnerBlocksOf: firstBlock
]

{ #category : #unclassified }
OptimizingBlockInliner >> inline: aMessageSend in: block [
	^self performInlinerFor: aMessageSend in: block
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineAnd_: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	join
		insertPhiOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	block endWithJumpFalseTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfFalse_: message in: block [
	| closure first lastSkipped join nilval |
	closure := message arguments first.
	first := closure firstBlock.
	self inlineInnerBlocksOf: first.
	lastSkipped := first lastBlock.
	join := block splitAfter: message.
	nilval := OLoadConstant valued: nil.
	message afterInsert: nilval.
	join insertPhiOf: lastSkipped and: block replacing: message.
	block endWithJumpTrueTo: join skipping: first if: message receiver.
	lastSkipped endWithJumpTo: join.
	first addPredecessor: block.
	join addPredecessor: lastSkipped; addPredecessor: block.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfTrue_: message in: block [
	| closure firstSkipped lastSkipped join nilval |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	nilval := OLoadConstant valued: nil.
	message afterInsert: nilval.
	join insertPhiOf: lastSkipped and: block replacing: message.
	block endWithJumpFalseTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: lastSkipped; addPredecessor: block.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfTrue_ifFalse_: message in: block [
	| positive negative firstTrue firstFalse lastTrue lastFalse join |
	positive := message arguments first.
	negative := message arguments second.
	firstTrue := positive firstBlock.
	firstFalse := negative firstBlock.
	self inlineInnerBlocksOf: firstTrue and: firstFalse.
	lastTrue := firstTrue lastBlock.
	lastFalse := firstFalse lastBlock.
	join := block splitAfter: message.
	join insertPhiOf: lastTrue and: lastFalse replacing: message.
	block
		endWithJumpFalseTo: firstFalse
		skipping: firstTrue
		if: message receiver.
	lastTrue endWithJumpTo: join.
	lastFalse endWithJumpTo: join.
	firstTrue addPredecessor: block.
	firstFalse addPredecessor: block.
	join addPredecessor: lastTrue; addPredecessor: lastFalse.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock [
	"
	We inline backwards because it is simpler. Going forward would
	require tracking which is the current basic block after each inlined
	block closure
	"
	basicBlock postOrderDo: [:block | 
		block
			instructionsReverseDo: [:instruction | (self shouldInline: instruction)
				ifTrue: [self inline: instruction in: block]]]
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock1 and: basicBlock2 [
	self inlineInnerBlocksOf: basicBlock1; inlineInnerBlocksOf: basicBlock2
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock1 and: basicBlock2 and: basicBlock3 [
	self
		inlineInnerBlocksOf: basicBlock1;
		inlineInnerBlocksOf: basicBlock2;
		inlineInnerBlocksOf: basicBlock3
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineOr_: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	join
		insertPhiOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	block endWithJumpTrueTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inliners [
	^#(ifTrue: ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue: and: or: #to:do: value value: whileTrue:)
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineTo_do_: message in: block [
	| start end closure first last join head phi compare increment |
	start := message receiver.
	end := message arguments first.
	closure := message arguments second.
	first := closure firstBlock.
	self inlineInnerBlocksOf: first.
	last := first lastBlock.
	join := block splitAfter: message.
	head := OBasicBlock new.
	block endWithJumpTo: head.
	head addPredecessor: block; addPredecessor: last.
	first addPredecessor: head.
	join addPredecessor: head.
	phi := OPhi new addVariable: start from: block.
	compare := OBinaryVariableOperation left: phi right: end name: #'<='.
	head
		add: phi;
		add: compare;
		endWithJumpFalseTo: join skipping: first if: compare.
	increment := OBinaryConstantOperation left: phi right: 1 name: #'+'.
	last add: increment; endWithJumpTo: head.
	phi addVariable: increment from: last.
	message dissolve.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineValue: message in: block [
	| closure entry exit after |
	closure := message receiver.
	closure isBlockClosure ifFalse: [^self].
	entry := closure firstBlock duplicate.
	self inlineInnerBlocksOf: entry.
	exit := entry lastBlock.
	after := block splitAfter: message.
	block endWithJumpTo: entry.
	exit endWithJumpTo: after.
	entry addPredecessor: block.
	after addPredecessor: exit.
	message replaceAllUsesWith: exit lastValue; dissolve.
	closure isUseless ifTrue: [closure firstBlock dissolveAllInstructions].
	^after
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineValue_: message in: block [
	| closure args arg1 entry exit after closureArgs |
	closure := message receiver.
	args := message arguments.
	arg1 := args first.
	closure isBlockClosure ifFalse: [^self].
	entry := closure firstBlock duplicate.
	self inlineInnerBlocksOf: entry.
	exit := entry lastBlock.
	closureArgs := self closureArgumentsIn: entry count: 1.
	closureArgs first replaceAllUsesWith: arg1; dissolve.
	after := block splitAfter: message.
	block endWithJumpTo: entry.
	exit endWithJumpTo: after.
	entry addPredecessor: block.
	after addPredecessor: exit.
	message replaceAllUsesWith: exit lastValue; dissolve.
	closure isUseless ifTrue: [closure firstBlock dissolveAllInstructions].
	^after
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineWhileTrue_: message in: block [
	| antecedent consequent firstAntecedent firstConsequent lastAntecedent lastConsequent join |
	antecedent := message receiver.
	consequent := message arguments first.
	firstAntecedent := antecedent firstBlock.
	firstConsequent := consequent firstBlock.
	self inlineInnerBlocksOf: firstAntecedent and: firstConsequent.
	lastAntecedent := firstAntecedent lastBlock.
	lastConsequent := firstConsequent lastBlock.
	join := block splitAfter: message.
	block endWithJumpTo: firstAntecedent.
	lastAntecedent
		endWithJumpFalseTo: join
		skipping: firstConsequent
		if: lastAntecedent lastValue.
	lastConsequent endWithJumpTo: firstAntecedent.
	message dissolve.
	firstAntecedent addPredecessor: block; addPredecessor: lastConsequent.
	firstConsequent addPredecessor: lastAntecedent.
	join addPredecessor: lastAntecedent.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> on: block [
	firstBlock := block
]

{ #category : #private }
OptimizingBlockInliner >> performInlinerFor: messageSend in: block [
	| selector inliner |
	selector := messageSend selector asString copy replace: $: with: $_.
	inliner := #inline , selector capitalized , ':in:'.
	^self perform: inliner asSymbol with: messageSend with: block
]

{ #category : #unclassified }
OptimizingBlockInliner >> shouldInline: anInstruction [
	^anInstruction isMessageSend
		and: [self inliners includes: anInstruction selector]
]

