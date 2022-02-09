"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingValueNumbering,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'currentBlock',
		'names',
		'hashes',
		'hashesOut'
	],
	#category : #OCompiler
}

{ #category : #private }
OptimizingValueNumbering >> addNewName: instruction [
	^names at: instruction put: '{v' , names size printString , '}'
]

{ #category : #private }
OptimizingValueNumbering >> hashOfLoadConstant: instruction [
	^[instruction value printString] on: Error do: [^nil]
]

{ #category : #private }
OptimizingValueNumbering >> hashOfUnary: instruction [
	| receiver |
	receiver := self nameOf: instruction receiver.
	^receiver , instruction name
]

{ #category : #testing }
OptimizingValueNumbering >> isCommutative: name [
	^name = #'+' or: [name = #'*']
]

{ #category : #testing }
OptimizingValueNumbering >> isStillAlive: block [
	^block withPredecessors includes: firstBlock
]

{ #category : #accessing }
OptimizingValueNumbering >> nameOf: instruction [
	^names at: instruction
]

{ #category : #accessing }
OptimizingValueNumbering >> resultOfBinaryWithConstants: aBinaryInstruction [
	| operation left right |
	operation := aBinaryInstruction name.
	left := aBinaryInstruction left value.
	right := aBinaryInstruction right value.
	operation = #'+' ifTrue: [^left + right].
	operation = #'-' ifTrue: [^left - right].
	operation = #'*' ifTrue: [^left * right].
	operation = #'//' ifTrue: [^left // right].
	operation = #'=' ifTrue: [^left = right].
	self halt
]

{ #category : #private }
OptimizingValueNumbering >> unifyPredecessorHashes [
	| incoming any |
	hashes := Dictionary new.
	currentBlock predecessors size = 0 ifTrue: [^self].
	incoming := currentBlock predecessors
		collect: [:pred | hashesOut at: pred ifAbsent: [Dictionary new]].
	any := incoming removeLast.
	any keysAndValuesDo: [:hash :value | | unanimous |
		unanimous := incoming
			conform: [:dict | dict
				at: hash
				ifAbsent: false
				ifPresent: [:prev | prev = value]].
		unanimous ifTrue: [hashes at: hash put: value]]
]

{ #category : #private }
OptimizingValueNumbering >> updateMemory: store as: storeHash andLoads: loadHash [
	"
	easy: hashes at: storeHash ifPresent: [:mapping | (mapping value livesInSameBlockThan: store)  ifTrue: [mapping value dissolve]]
	hard: hashes at: storeHash ifPresent: [:mapping | postDominatorTree does: blockOf dominate: currentBlock ifTrue: [mapping value dissolve]]
	"
	hashes at: loadHash put: store
]

{ #category : #private }
OptimizingValueNumbering >> valueBranchTo: aBasicBlock [
	| source last comparison hash name |
	aBasicBlock predecessors size != 1 ifTrue: [^self].
	source := aBasicBlock predecessors first.
	last := source lastInstruction.
	last isConditionalJump ifFalse: [^self].
	comparison := last variable.
	name := self nameOf: comparison.
	hash := 'branch' , name.
	last target == aBasicBlock
		ifTrue: [hashes at: hash put: last isJumpTrue]
		ifFalse: [hashes at: hash put: last isJumpFalse]
]

{ #category : #private }
OptimizingValueNumbering >> valueOf: hash be: instruction [
	hashes at: hash ifPresent: [:value | | copy |
		copy := instruction replaceWithCopyOf: value.
		self addNewName: copy.
		^copy == value ifFalse: [
			(copy isUnaryOperation and: [copy name = #copy])
				ifTrue: [hashes at: (self hashOfUnary: copy) put: instruction].
			copy isConstant
				ifTrue: [hashes at: (self hashOfLoadConstant: copy) put: instruction]]].
	hashes at: hash put: instruction
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitBinaryWithConstant: instruction [
	| left right hash temp value replacement |
	left := self nameOf: instruction left.
	right := instruction right printString.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	(instruction left isConstant and: instruction name != #_basicAt:) ifTrue: [
		value := self resultOfBinaryWithConstants: instruction.
		replacement := OLoadConstant valued: value.
		instruction dissolveReplacingWith: replacement.
		^self
			addNewName: replacement;
			visitLoadConstant: replacement;
			valueOf: hash be: replacement].
	self valueOf: hash be: instruction
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitBinaryWithVariable: instruction [
	| left right hash temp |
	left := self nameOf: instruction left.
	right := self nameOf: instruction right.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	self valueOf: hash be: instruction
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitBranch: branch [
	| hash receiver |
	receiver := self nameOf: branch variable.
	hash := 'branch' , receiver.
	hashes at: hash ifPresent: [:outcome | 
		outcome isBoolean
			ifTrue: [branch replaceWithUnconditional: outcome in: currentBlock]]
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitJump: aJumpInstruction [
	
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitJumpFalse: branch [
	self visitBranch: branch
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitJumpTrue: branch [
	self visitBranch: branch
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitLoad: load [
	| base index indexHash hash |
	base := self nameOf: load base.
	index := load index.
	indexHash := index isInstruction
		ifTrue: [self nameOf: index]
		ifFalse: [index printString].
	hash := base , load name , indexHash.
	self valueOf: hash be: load
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitLoadConstant: instruction [
	| hash |
	hash := self hashOfLoadConstant: instruction.
	hash ifNil: [self].
	self valueOf: hash be: instruction
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitLoadImplicit: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitMessageSend: instruction [
	| loads |
	loads := names keys select: [:instr | 
		instr isPrimitiveOperation
			and: [#(_basicAt: _byteAt: _basicFlags) includes: instr name]].
	loads do: [:load | hashes removeAllSuchThat: [:value | value = load]]
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitNullary: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitPhi: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitReturn: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitStore: store [
	| receiver index indexHash value valueHash hash load selector |
	receiver := self nameOf: store base.
	index := store index.
	indexHash := index isInstruction
		ifTrue: [self nameOf: index]
		ifFalse: [index printString].
	value := store value.
	valueHash := self nameOf: value.
	hash := receiver , store name , indexHash , valueHash.
	selector := store name allButLast: 4.
	load := receiver , selector , indexHash.
	self updateMemory: value as: hash andLoads: load
]

{ #category : #'visitor protocol' }
OptimizingValueNumbering >> visitUnary: instruction [
	| hash |
	(#(push) includes: instruction name) ifTrue: [^self].
	hash := self hashOfUnary: instruction.
	self valueOf: hash be: instruction
]

{ #category : #private }
OptimizingValueNumbering >> workFrom: aBasicBlock [
	| count |
	hashes := Dictionary new.
	hashesOut := Dictionary new.
	names := Dictionary new.
	firstBlock := aBasicBlock.
	count := 0.
	aBasicBlock instructionsWithSuccessorsDo: [:inst | 
		names at: inst put: '{v' , count printString , '}'.
		count := count + 1].
	aBasicBlock withSuccessorsPostOrder
		reverseDo: [:block | self workOn: block]
]

{ #category : #private }
OptimizingValueNumbering >> workOn: aBlock [
	(self isStillAlive: aBlock) ifFalse: [^self].
	currentBlock := aBlock.
	self unifyPredecessorHashes.
	self valueBranchTo: aBlock.
	currentBlock firstInstruction acceptVisitor: self.
	hashesOut at: aBlock put: hashes copy
]

