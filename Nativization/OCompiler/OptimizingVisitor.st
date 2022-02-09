"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingVisitor,
	#superclass : #ParseTreeVisitor,
	#instVars : [
		'method',
		'firstBlock',
		'currentBlock',
		'locals',
		'abi'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingVisitor class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OptimizingVisitor >> abi: anAbi [
	abi := anAbi
]

{ #category : #unclassified }
OptimizingVisitor >> defineActivationRecord [
	| frame |
	frame := OActivationContext named: #activationRecord.
	frame temporaries: method tempCount.
	currentBlock add: frame
]

{ #category : #unclassified }
OptimizingVisitor >> defineBlockArguments: anSBlock [
	anSBlock isInlined
		ifTrue: [self defineInlinedBlockArguments: anSBlock]
		ifFalse: [
			self
				error: 'non-inlined blocks not yet supported';
				defineRealBlockArguments: anSBlock]
]

{ #category : #unclassified }
OptimizingVisitor >> defineInlinedBlockArguments: anSBlock [
	| args |
	args := anSBlock argumentIndexes collect: [:i | self loadStackTemporary: i].
	locals add: args
]

{ #category : #unclassified }
OptimizingVisitor >> defineMethodArguments: anInteger [
	| frame load |
	frame := firstBlock firstInstruction.
	frame argumentCount: anInteger.
	anInteger to: 1 by: -1 do: [:i | 
		load := OLoadOperation base: frame slotAtImm: i + 2.
		currentBlock add: load]
]

{ #category : #unclassified }
OptimizingVisitor >> defineRealBlockArguments: anSBlock [
	| block count frame load |
	block := method at: anSBlock index.
	count := block argumentCount.
	count = 0 ifTrue: [^self].
	frame := firstBlock activationRecord.
	1 to: count do: [:i | 
		load := OLoadOperation base: frame slotAtImm: i + 2.
		currentBlock add: load]
]

{ #category : #unclassified }
OptimizingVisitor >> defineSelf [
	| definition |
	definition := OLoadImplicit named: #self.
	currentBlock add: definition
]

{ #category : #unclassified }
OptimizingVisitor >> initialize [
	firstBlock := OBasicBlock new.
	currentBlock := firstBlock.
	locals := OrderedCollection new
]

{ #category : #unclassified }
OptimizingVisitor >> inlinedBlockArgument: anInteger [
	"
	Remember that we only support inlined blocks for now
	"
	| index |
	index := -1 - anInteger.
	locals
		reverseDo: [:args | args
			detect: [:inst | inst index = index]
			ifFound: [:inst | ^inst]].
	self _ASSERT: false
]

{ #category : #unclassified }
OptimizingVisitor >> insertReturnSelf [
	| receiver frame instruction |
	receiver := firstBlock firstInstruction next.
	frame := firstBlock firstInstruction.
	instruction := OReturn new
		source: receiver;
		frame: frame;
		argumentsCount: method argumentCount.
	currentBlock add: instruction.
	^instruction
]

{ #category : #unclassified }
OptimizingVisitor >> loadStackTemporary: anInteger [
	| frame index load |
	frame := firstBlock activationRecord.
	index := -1 - anInteger.
	load := OLoadOperation base: frame slotAtImm: index.
	currentBlock add: load.
	^load
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadArgument: anSBinding [
	^anSBinding isInlined
		ifTrue: [self inlinedBlockArgument: anSBinding index]
		ifFalse: [
			anSBinding environment
				ifNotNil: [self error: 'non-inlined closure arguments not yet supported'].
			firstBlock activationRecord argumentAt: anSBinding index]
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadAssociationValue: anAssociation [
	| global read name |
	name := anAssociation key asString asSymbol.
	name == #WordSize ifTrue: [^self lowerLoadConstant: abi wordSize].
	name == #WordSizeShift ifTrue: [^self lowerLoadConstant: abi wordSizeShift].
	global := OLoadConstant valued: anAssociation.
	read := OLoadOperation base: global slotAtImm: 1.
	currentBlock add: global; add: read.
	^read
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadConstant: anObject [
	| load |
	load := OLoadConstant valued: anObject.
	currentBlock add: load.
	^load
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadInstanceVar: anSBinding [
	| receiver index load |
	receiver := firstBlock activationRecord receiver.
	index := anSBinding index.
	load := OLoadOperation base: receiver slotAtImm: index.
	currentBlock add: load.
	^load
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadLiteral: anSBinding [
	| constant |
	constant := OLoadConstant valued: anSBinding value.
	currentBlock add: constant.
	^constant
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadSelf [
	^firstBlock activationRecord receiver
]

{ #category : #unclassified }
OptimizingVisitor >> lowerLoadTemporary: anSBinding [
	"
	TODO: support environment/closure temporaries
	"
	^self loadStackTemporary: anSBinding index
]

{ #category : #private }
OptimizingVisitor >> lowerSpecialABI: aMethodNode [
	| literals i actual next load names frame |
	literals := method literals.
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #savePreviousSelf ifTrue: [
		firstBlock activationRecord doSavePreviousSelf.
		load := firstBlock firstInstruction detect: [:inst | inst isConstant].
		load dissolve.
		literals := literals copyFrom: 2].
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #specialABIBegin ifFalse: [^self].
	frame := firstBlock activationRecord.
	i := 2.
	names := aMethodNode arguments collect: [:arg | arg name asSymbol].
	[(literals at: i) == #specialABIEnd]
		whileFalse: [| name register implicit argument regname index |
			name := literals at: i.
			regname := literals at: i + 1.
			register := self registerNamed: regname.
			name = #self ifTrue: [frame receiver register: register] ifFalse: [
				implicit := (OLoadImplicit named: name) register: register.
				index := names indexOf: name.
				argument := frame argumentAt: index.
				argument dissolveReplacingWith: implicit].
			i := i + 2].
	actual := firstBlock firstInstruction detect: [:inst | inst isConstant].
	[
		next := actual next.
		actual dissolve.
		actual isConstant and: [actual value == #specialABIEnd]]
		whileFalse: [actual := next]
]

{ #category : #unclassified }
OptimizingVisitor >> lowerStore: anSBinding with: operation [
	| binding |
	binding := anSBinding binding.
	binding isTemporary
		ifTrue: [^self lowerStoreTemporary: binding with: operation].
	binding isInstVar
		ifTrue: [^self lowerStoreInstanceVar: binding with: operation].
	binding refersToAssoc
		ifTrue: [^self lowerStoreAssociationValue: binding with: operation].
	self _ASSERT: false
]

{ #category : #unclassified }
OptimizingVisitor >> lowerStoreAssociationValue: anSBinding with: value [
	| global write |
	global := OLoadConstant valued: anSBinding association.
	write := OStoreOperation base: global slotAtImm: 1 put: value.
	currentBlock add: global; add: write
]

{ #category : #unclassified }
OptimizingVisitor >> lowerStoreInstanceVar: anSBinding with: value [
	| this write |
	this := firstBlock activationRecord receiver.
	write := OStoreOperation base: this slotAtImm: anSBinding index put: value.
	currentBlock add: write
]

{ #category : #unclassified }
OptimizingVisitor >> lowerStoreTemporary: anSBinding with: value [
	| frame index store |
	frame := firstBlock activationRecord.
	index := -1 - anSBinding index.
	store := OStoreOperation base: frame slotAtImm: index put: value.
	currentBlock add: store
]

{ #category : #unclassified }
OptimizingVisitor >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #unclassified }
OptimizingVisitor >> registerNamed: regname [
	^abi perform: regname
]

{ #category : #unclassified }
OptimizingVisitor >> staticBindingFor: aDynamicBinding [
	^method classBinding staticBindingFor: aDynamicBinding name
]

{ #category : #unclassified }
OptimizingVisitor >> undefineBlockArguments [
	locals removeLast
]

{ #category : #unclassified }
OptimizingVisitor >> visit: aParseNode [
	super visit: aParseNode.
	^firstBlock
]

{ #category : #unclassified }
OptimizingVisitor >> visitAssignment: anAssignmentNode [
	| result |
	result := anAssignmentNode expression acceptVisitor: self.
	anAssignmentNode assignees do: [:node | self lowerStore: node with: result]
]

{ #category : #unclassified }
OptimizingVisitor >> visitBlock: aBlockNode [
	| previous cfg |
	previous := currentBlock.
	cfg := OBasicBlock new.
	currentBlock := cfg.
	self
		defineBlockArguments: aBlockNode;
		visitScript: aBlockNode;
		undefineBlockArguments.
	currentBlock := previous.
	^OBlockClosure containing: cfg
]

{ #category : #unclassified }
OptimizingVisitor >> visitCascade: aCascadeNode [
	| receiver arguments send block |
	block := currentBlock.
	receiver := aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:msg | 
		arguments := msg arguments collect: [:node | node acceptVisitor: self].
		send := OMessageSend
			receiver: receiver
			selector: msg selector value asSymbol
			arguments: arguments.
		block add: send].
	^send
]

{ #category : #unclassified }
OptimizingVisitor >> visitCascadeReceiver: aCascadeReceiverNode [
	^aCascadeReceiverNode receiver acceptVisitor: self
]

{ #category : #unclassified }
OptimizingVisitor >> visitIdentifier: anIdentifierNode [
	| binding static |
	binding := anIdentifierNode binding.
	binding isTemporary ifTrue: [^self lowerLoadTemporary: binding].
	binding isArgument ifTrue: [^self lowerLoadArgument: binding].
	binding isSelf ifTrue: [^self lowerLoadSelf].
	binding isLiteral ifTrue: [^self lowerLoadLiteral: binding].
	static := binding.
	static isInstVar ifTrue: [^self lowerLoadInstanceVar: static].
	static refersToAssoc ifTrue: [
		^static isConstant
			ifTrue: [self lowerLoadConstant: static association value]
			ifFalse: [self lowerLoadAssociationValue: static association]].
	self _ASSERT: false
]

{ #category : #unclassified }
OptimizingVisitor >> visitLiteral: aLiteralNode [
	| load |
	load := OLoadConstant valued: aLiteralNode value.
	currentBlock add: load.
	^load
]

{ #category : #unclassified }
OptimizingVisitor >> visitMessage: aMessageNode [
	| receiver arguments send block |
	block := currentBlock.
	receiver := aMessageNode receiver acceptVisitor: self.
	arguments := aMessageNode arguments
		collect: [:node | node acceptVisitor: self].
	send := OMessageSend
		receiver: receiver
		selector: aMessageNode selector value asSymbol
		arguments: arguments.
	block add: send.
	^send
]

{ #category : #unclassified }
OptimizingVisitor >> visitMethod: anSMethod [
	| last |
	self
		defineActivationRecord;
		defineSelf;
		defineMethodArguments: anSMethod argumentCount;
		visitScript: anSMethod.
	last := currentBlock lastValue.
	last isReturn ifFalse: [self insertReturnSelf].
	self lowerSpecialABI: anSMethod
]

{ #category : #unclassified }
OptimizingVisitor >> visitNumericLiteral: aNumericLiteralNode [
	^self visitLiteral: aNumericLiteralNode
]

{ #category : #unclassified }
OptimizingVisitor >> visitReturn: aReturnNode [
	| source frame instruction |
	source := aReturnNode expression acceptVisitor: self.
	frame := firstBlock firstInstruction.
	instruction := OReturn new
		source: source;
		frame: frame;
		argumentsCount: method argumentCount.
	currentBlock add: instruction.
	^instruction
]

{ #category : #unclassified }
OptimizingVisitor >> visitScript: aScriptNode [
	aScriptNode statements do: [:node | node acceptVisitor: self]
]

{ #category : #unclassified }
OptimizingVisitor >> visitSelector: aSelectorNode [
	
]

