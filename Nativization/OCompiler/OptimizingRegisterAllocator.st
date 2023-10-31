"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingRegisterAllocator,
	#superclass : #Object,
	#instVars : [
		'abi',
		'liveRanges',
		'unifiedLiveRanges',
		'expirations',
		'allocation',
		'free',
		'used',
		'usedOut',
		'locals',
		'currentBlock',
		'method'
	],
	#category : #OCompiler
}

{ #category : #'instance creation' }
OptimizingRegisterAllocator class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
OptimizingRegisterAllocator >> abi: anAbi [
	abi := anAbi.
	free := OrderedCollection new.
	free
		add: abi regS;
		add: abi regT;
		add: abi regA;
		add: abi regR;
		add: abi regFP
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> activation [
	^method activation
]

{ #category : #'adding / removing' }
OptimizingRegisterAllocator >> addLiveRangesOf: block [
	block
		instructionsDo: [:instruction | self
			assureLiveRangeStartingAt: instruction
			in: block]
]

{ #category : #private }
OptimizingRegisterAllocator >> allocateFor: inst [
	| range register starts ends |
	(self rangesEndingAt: inst) reverseDo: [:ending | self free: ending].
	range := self unifiedLiveRangeOf: inst.
	starts := range startsAt: inst.
	ends := range endsAt: inst.
	(ends not and: [range isSpilled not]) ifTrue: [
		starts ifTrue: [self assignRegisterTo: inst in: range].
		register := allocation at: range.
		allocation at: inst put: register].
	inst isMessageSend ifTrue: [self repairToRespectABI: inst with: range]
]

{ #category : #private }
OptimizingRegisterAllocator >> allocateLiveRanges [
	self preallocateImplicitVariables.
	method start reversePostOrderDo: [:block | 
		currentBlock := block.
		self recalculateRegisterUsage.
		block instructionsDo: [:inst | self allocateFor: inst].
		usedOut at: block put: used copy]
]

{ #category : #accessing }
OptimizingRegisterAllocator >> allocation [
	^allocation
]

{ #category : #services }
OptimizingRegisterAllocator >> assign: register to: aRange [
	((free includes: register) not and: [(used at: register) != aRange])
		ifTrue: [self error: 'register ' , register printString , ' is not free'].
	allocation at: aRange put: register.
	free remove: register ifAbsent: [].
	used at: register put: aRange
]

{ #category : #services }
OptimizingRegisterAllocator >> assignRegisterTo: instruction in: aRange [
	| register |
	register := allocation at: aRange ifAbsent: [
		free isEmpty
			ifTrue: [self spillALiveRangeInUseAfter: instruction]
			ifFalse: [free last]].
	"register == edx ifTrue: [self halt]."
	self assign: register to: aRange
]

{ #category : #private }
OptimizingRegisterAllocator >> assureLiveRangeStartingAt: anInstruction [
	^self assureLiveRangeStartingAt: anInstruction in: currentBlock
]

{ #category : #private }
OptimizingRegisterAllocator >> assureLiveRangeStartingAt: anInstruction in: block [
	| range |
	range := OSimpleLiveRange new definedAt: anInstruction in: block.
	liveRanges at: anInstruction put: range.
	^range
]

{ #category : #private }
OptimizingRegisterAllocator >> computeExpirationOf: instruction [
	| range |
	range := self unifiedLiveRangeOf: instruction.
	range expirationPoints do: [:operation | self kill: range at: operation]
]

{ #category : #private }
OptimizingRegisterAllocator >> computeExpirations [
	method start
		instructionsWithSuccessorsDo: [:instruction | self
			computeExpirationOf: instruction]
]

{ #category : #private }
OptimizingRegisterAllocator >> computeLiveRanges [
	| start |
	start := method start.
	start
		reversePostOrderDo: [:block | self addLiveRangesOf: block];
		reversePostOrderDo: [:block | self
			currentBlock: block;
			computeLiveRangesOf: block].
	self computeExpirations
]

{ #category : #private }
OptimizingRegisterAllocator >> computeLiveRangesOf: block [
	block firstInstruction acceptVisitor: self
]

{ #category : #accessing }
OptimizingRegisterAllocator >> currentBlock: aBasicBlock [
	currentBlock := aBasicBlock
]

{ #category : #services }
OptimizingRegisterAllocator >> doAllocation [
	"
	| record |
		record := self activationRecord.
	record isLoadImplicit ifFalse: [free remove: ebp].
	"
	self computeLiveRanges; allocateLiveRanges; reserveSpaceForLocals.
	^allocation
]

{ #category : #services }
OptimizingRegisterAllocator >> free: range [
	| register |
	register := allocation at: range ifAbsent: [^self].
	(free includes: register) ifTrue: [^self].
	(used at: register) == range ifFalse: [^self].
	"register == ecx ifTrue: [self halt]."
	free add: register.
	used removeKey: register.
	^register
]

{ #category : #initialization }
OptimizingRegisterAllocator >> initialize [
	allocation := IdentityDictionary new.
	liveRanges := IdentityDictionary new.
	unifiedLiveRanges := IdentityDictionary new.
	expirations := IdentityDictionary new.
	used := Dictionary new.
	usedOut := Dictionary new
]

{ #category : #private }
OptimizingRegisterAllocator >> insertCopyToR: anInstruction before: inst [
	| copy range |
	copy := anInstruction newCopy.
	inst beforeInsert: copy.
	range := self unifiedLiveRangeOf: anInstruction.
	liveRanges at: copy put: range.
	allocation at: copy put: abi regR
]

{ #category : #private }
OptimizingRegisterAllocator >> insertLoadBeforeUse: operand [
	| stack load use range definition predecessor |
	stack := used at: abi regFP.
	load := OLoadOperation base: stack anyDefinition slotAtImm: 1 - locals.
	use := operand instruction.
	use isPhi
		ifTrue: [
			predecessor := operand name.
			predecessor lastValue beforeInsert: load.
			range := self assureLiveRangeStartingAt: load in: predecessor]
		ifFalse: [
			use beforeInsert: load.
			range := self assureLiveRangeStartingAt: load in: currentBlock].
	definition := operand definition.
	operand transferUseTo: load.
	range addUseFrom: use at: currentBlock.
	self kill: range at: use.
	allocation
		at: definition
		ifPresent: [:register | allocation at: load put: register]
]

{ #category : #private }
OptimizingRegisterAllocator >> insertPop: anInstruction to: register after: messageSend [
	| pop range |
	pop := OPopOperation new.
	messageSend afterInsert: pop.
	range := self unifiedLiveRangeOf: anInstruction.
	liveRanges at: pop put: range.
	allocation at: pop put: register
]

{ #category : #private }
OptimizingRegisterAllocator >> insertStoreAfter: definition with: aLiveRange at: block [
	| stack store range reg |
	unifiedLiveRanges removeKey: definition ifAbsent: [].
	definition isPhi ifTrue: [^self].
	stack := used at: abi regFP.
	store := OStoreOperation
		base: stack anyDefinition
		slotAtImm: 1 - locals
		put: definition.
	definition afterInsert: store.
	range := self assureLiveRangeStartingAt: definition.
	range addUseFrom: store at: block.
	stack addUseFrom: store at: block.
	self kill: range at: store.
	range := self assureLiveRangeStartingAt: store.
	self kill: range at: store.
	usedOut at: block ifPresent: [:map | 
		reg := map keyAtValue: aLiveRange ifAbsent: nil.
		reg ifNotNil: [map removeKey: reg]]
]

{ #category : #testing }
OptimizingRegisterAllocator >> isFree: register [
	^free includes: register
]

{ #category : #testing }
OptimizingRegisterAllocator >> isSpilled: register [
	^false
]

{ #category : #services }
OptimizingRegisterAllocator >> kill: range at: instruction [
	| expiring |
	(range class = OSimpleLiveRange or: [range class == OComposedLiveRange])
		ifFalse: [self halt].
	expiring := expirations
		at: instruction
		ifAbsentPut: [OrderedCollection new].
	expiring add: range
]

{ #category : #accessing }
OptimizingRegisterAllocator >> liveRangeOf: value [
	^liveRanges at: value
]

{ #category : #accessing }
OptimizingRegisterAllocator >> method: anOMethod [
	method := anOMethod.
	locals := 2 + method temporaries size
]

{ #category : #private }
OptimizingRegisterAllocator >> preallocateImplicitVariables [
	method start instructionsDo: [:inst | | range |
		inst isProjection ifFalse: [^self].
		range := self unifiedLiveRangeOf: inst.
		inst register ifNotNil: [:register | allocation at: range put: register]]
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> rangesEndingAt: instruction [
	^expirations at: instruction ifAbsent: [OrderedCollection new]
]

{ #category : #private }
OptimizingRegisterAllocator >> recalculateRegisterUsage [
	| incoming recalculated |
	currentBlock predecessors isEmpty ifTrue: [^self].
	incoming := (currentBlock predecessors
		select: [:block | usedOut includesKey: block])
		collect: [:block | usedOut at: block].
	recalculated := incoming first.
	used := recalculated select: [:assoc | assoc value isLiveAt: currentBlock].
	free := OrderedCollection new: 10.
	free
		add: abi regS;
		add: abi regT;
		add: abi regA;
		add: abi regR;
		add: abi regFP;
		removeAll: used keys
]

{ #category : #private }
OptimizingRegisterAllocator >> repairToRespectABI: messageSend with: range [
	| result clobbered receiver spillPoint |
	result := allocation at: messageSend ifAbsent: nil.
	clobbered := (used copy
		removeKey: abi regFP ifAbsent: [];
		removeKey: result ifAbsent: [];
		yourself) associations.
	spillPoint := messageSend arguments isEmpty
		ifTrue: [messageSend]
		ifFalse: [messageSend arguments first].
	clobbered do: [:assoc | | def |
		def := assoc value anyDefinition.
		def insertPushBefore: spillPoint.
		self insertPop: def to: assoc key after: messageSend].
	receiver := allocation at: messageSend receiver.
	receiver == abi regR
		ifFalse: [self insertCopyToR: messageSend receiver before: messageSend]
]

{ #category : #private }
OptimizingRegisterAllocator >> reserveSpaceForLocals [
	self activation temporaries: locals - 2
]

{ #category : #private }
OptimizingRegisterAllocator >> spillALiveRangeInUseAfter: instruction [
	| freed register |
	freed := self usedRangeReadLastAfter: instruction.
	locals := locals + 1.
	self splitRange: freed.
	register := self free: freed.
	^register
]

{ #category : #private }
OptimizingRegisterAllocator >> splitRange: aLiveRange [
	| real |
	real := self unifiedLiveRangeOfRange: aLiveRange.
	real definitionsWithBlocksDo: [:definition :block | 
		definition allUses do: [:operand | self insertLoadBeforeUse: operand].
		self insertStoreAfter: definition with: aLiveRange at: block]
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> unifiedLiveRangeOf: anInstruction [
	^unifiedLiveRanges
		at: anInstruction
		ifAbsent: [liveRanges at: anInstruction]
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> unifiedLiveRangeOfRange: aLiveRange [
	^unifiedLiveRanges at: aLiveRange ifAbsent: [aLiveRange]
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> unify: anInstruction liveRangeTo: unified [
	| range |
	range := self unifiedLiveRangeOf: anInstruction.
	range = unified ifTrue: [^self].
	unified addAll: range simpleRanges.
	unified allDefinitions
		do: [:instruction | unifiedLiveRanges at: instruction put: unified]
]

{ #category : #services }
OptimizingRegisterAllocator >> use: operand from: anInstruction [
	self use: operand from: anInstruction in: currentBlock
]

{ #category : #services }
OptimizingRegisterAllocator >> use: operand from: anInstruction in: block [
	| range |
	range := self liveRangeOf: operand.
	range addUseFrom: anInstruction at: block
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> usedRangeLessAccessed [
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	^ranges
		min: [:range | (range allDefinitions , range allUses reject: #isPhi) size]
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> usedRangeReadLast [
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	currentBlock
		instructionsWithReversePostOrderSuccessorsDo: [:instruction | | candidate |
			candidate := ranges first.
			ranges removeAllSuchThat: [:range | 
				range allDefinitions
					anySatisfy: [:definition | instruction usesResultOf: definition]].
			ranges size = 1 ifTrue: [^ranges first].
			ranges size = 0 ifTrue: [^candidate]].
	self error: 'no range found'
]

{ #category : #inquiries }
OptimizingRegisterAllocator >> usedRangeReadLastAfter: first [
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	currentBlock
		instructionsAfter: first
		withReversePostOrderSuccessorsDo: [:instruction | | candidate |
			candidate := ranges first.
			ranges removeAllSuchThat: [:range | range isUsedBy: instruction].
			ranges size = 1 ifTrue: [^ranges first].
			ranges size = 0 ifTrue: [^candidate]].
	^ranges first
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitBinary: instruction [
	| right |
	self use: instruction left from: instruction.
	right := instruction right.
	right isConstant ifFalse: [self use: right from: instruction]
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitJump: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitJumpFalse: instruction [
	self use: instruction variable from: instruction
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitJumpTrue: instruction [
	self use: instruction variable from: instruction
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitLoad: load [
	| index |
	self use: load base from: load.
	index := load index.
	(index isONode andNot: [index isConstant])
		ifTrue: [self use: index from: load]
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitMessageSend: instruction [
	self
		use: instruction receiver
		from: instruction
	"instruction arguments
		do: [:operation | self use: operation from: instruction]"
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitMoveConstant: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitNullary: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitPhi: instruction [
	| unified |
	unified := OComposedLiveRange new.
	instruction variables do: [:source | 
		self
			use: source from: instruction;
			unify: source liveRangeTo: unified].
	self unify: instruction liveRangeTo: unified
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitProjection: instruction [
	
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitReturn: instruction [
	self
		use: instruction source from: instruction;
		use: self activation from: instruction
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitStore: store [
	self use: store base from: store.
	store index isInteger ifFalse: [self use: store index from: store].
	self use: store value from: store
]

{ #category : #'visitor protocol' }
OptimizingRegisterAllocator >> visitUnary: instruction [
	self use: instruction receiver from: instruction
]

