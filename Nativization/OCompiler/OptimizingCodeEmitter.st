"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingCodeEmitter,
	#superclass : #Object,
	#instVars : [
		'allocation',
		'assembler',
		'jumpDestinations',
		'assemblers',
		'method',
		'currentBlockIndex',
		'blocks'
	],
	#category : #OCompiler
}

{ #category : #'instance creation' }
OptimizingCodeEmitter class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
OptimizingCodeEmitter >> activation [
	^method activation
]

{ #category : #accessing }
OptimizingCodeEmitter >> allocation: anAllocation [
	allocation := anAllocation
]

{ #category : #'own services' }
OptimizingCodeEmitter >> assemble [
	| nilval |
	blocks := method start withSuccessorsPostOrder reversed.
	nilval := self activation nilUnitializedTemporaries.
	nilval ifNotNil: [allocation at: nilval put: assembler regNil].
	self labelBlocks.
	blocks withIndexDo: [:block :index | | label |
		currentBlockIndex := index.
		label := jumpDestinations at: block.
		assembler @ label.
		block firstInstruction acceptVisitor: self].
	assembler applyFixups
]

{ #category : #private }
OptimizingCodeEmitter >> assembleAsNative: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler convertToNativeInteger: src
]

{ #category : #private }
OptimizingCodeEmitter >> assembleAsObject: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler clearIntegerBit: src
]

{ #category : #private }
OptimizingCodeEmitter >> assembleAsPointer: asNativeSend [
	| src dst oop |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	oop := assembler newLabel.
	assembler
		testIntegerBit: src;
		jumpIfZeroTo: oop;
		convertToNativeInteger: src;
		@ oop;
		setIntegerBit: src
]

{ #category : #private }
OptimizingCodeEmitter >> assembleAsSmallInteger: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler convertToSmallInteger: src
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBasicAt: instruction [
	| base index result |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleBasicAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result from: base atIndexAt: index.
	result != index ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBasicAtConstant: instruction [
	| base dst |
	base := allocation at: instruction base.
	dst := allocation at: instruction ifAbsent: [^self].
	assembler load: dst from: base atIndex: instruction index value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBasicAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler store: value in: base index: instruction index value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBasicAtPut: instruction [
	| base value index |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleBasicAtConstantPut: instruction].
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value in: base indexAt: index;
		convertToSmallInteger: index
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBitAnd: instruction [
	| left instright right |
	left := allocation at: instruction left.
	instright := instruction right.
	right := instright isConstant
		ifTrue: [instright value * 2 + 1]
		ifFalse: [allocation at: instright].
	assembler and: left with: right
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBitOr: instruction [
	| left instright right |
	left := allocation at: instruction left.
	instright := instruction right.
	right := instright isConstant
		ifTrue: [instright value * 2 + 1]
		ifFalse: [allocation at: instright].
	assembler or: left with: right
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBitShift: instruction [
	| src offset |
	src := allocation at: instruction left.
	instruction right isConstant
		ifTrue: [self assembleBitShift: src by: instruction right value]
		ifFalse: [
			offset := allocation at: instruction right.
			offset halt]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleBitShift: src by: amount [
	amount > 0
		ifTrue: [
			assembler
				convertToNativeInteger: src;
				shiftLeft: src by: amount + 1;
				setIntegerBit: src]
		ifFalse: [
			assembler
				shiftRight: src by: 0 - amount;
				setIntegerBit: src]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleByteAt: instruction [
	| base index dst |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleByteAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	dst := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		loadZeroExtendByte: dst from: base atIndexAt: index;
		convertToSmallInteger: dst.
	index != dst ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleByteAtConstant: instruction [
	| base dst |
	base := allocation at: instruction base.
	dst := allocation at: instruction.
	assembler
		loadZeroExtendByte: dst
		from: base
		atIndex: instruction index value;
		convertToSmallInteger: dst
]

{ #category : #private }
OptimizingCodeEmitter >> assembleByteAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		during: [:final | assembler
			storeByte: final byte
			in: base
			offset: instruction index value - 1];
		convertToSmallInteger: value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleByteAtPut: instruction [
	| index base value |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleByteAtConstantPut: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	value := allocation at: instruction value.
	assembler
		convertToNativeInteger: index;
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		preserving: index
		during: [:final | assembler store: final byte in: base indexAt: index];
		convertToSmallInteger: value;
		convertToSmallInteger: index
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCheckOverflow: check [
	| success |
	self _ASSERT: check receiver == check prev.
	success := self
		tryOptimizing: check
		jumpTrue: [:label | assembler jumpIfOverflowTo: label]
		jumpFalse: [:label | assembler jumpIfNotOverflowTo: label].
	self _ASSERT: success
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCompare: instruction jumpTrue: trueBlock jumpFalse: falseBlock [
	| left right instright |
	left := allocation at: instruction left.
	instright := instruction right.
	instright isConstant
		ifTrue: [self assembleCompare: left toConstant: instright value]
		ifFalse: [
			right := allocation at: instright.
			assembler compare: left with: right].
	self assembleJumpTrue: trueBlock orJumpFalse: falseBlock in: instruction
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCompare: left toConstant: value [
	value isSmallInteger ifTrue: [^assembler compare: left with: value * 2 + 1].
	value ifNil: [^assembler compareWithNil: left].
	value = false ifTrue: [^assembler compareWithFalse: left].
	value = true ifTrue: [^assembler compareWithTrue: left].
	assembler compare: left withPointer: value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCopy: instruction [
	| source target |
	target := allocation at: instruction.
	source := allocation at: instruction receiver.
	self assembleCopyIfNeeded: source to: target
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCopyIfNeeded: source to: dest [
	source = dest ifTrue: [^self].
	assembler move: source to: dest
]

{ #category : #private }
OptimizingCodeEmitter >> assembleCopyResult: instruction [
	| dest |
	dest := allocation at: instruction ifAbsent: [^self].
	self assembleCopyIfNeeded: method abi regR to: dest
]

{ #category : #private }
OptimizingCodeEmitter >> assembleEquals: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfEqualTo: label]
		jumpFalse: [:label | assembler jumpIfNotEqualTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleExtendedSize: extendedSizeSend [
	| base dst |
	base := allocation at: extendedSizeSend receiver.
	dst := allocation at: extendedSizeSend.
	assembler
		load: dst e from: base atIndex: _ExtendedSize;
		convertToSmallInteger: dst
]

{ #category : #private }
OptimizingCodeEmitter >> assembleGenericMessageSend: instruction [
	| dest |
	instruction emitSendUsing: assembler.
	dest := allocation at: instruction ifAbsent: [^self].
	self assembleCopyIfNeeded: method abi regR to: dest
]

{ #category : #private }
OptimizingCodeEmitter >> assembleGreater: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfGreaterSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessOrEqualSignedTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleGreaterEqual: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessSignedTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleIsSmallInteger: instruction [
	| src |
	src := allocation at: instruction receiver.
	assembler testIntegerBit: src.
	self
		assembleJumpTrue: [:label | assembler jumpIfNotZeroTo: label]
		orJumpFalse: [:label | assembler jumpIfZeroTo: label]
		in: instruction
]

{ #category : #private }
OptimizingCodeEmitter >> assembleJumpIfEqualTo: target [
	| label |
	label := jumpDestinations at: target.
	assembler jumpIfEqualTo: label
]

{ #category : #private }
OptimizingCodeEmitter >> assembleJumpTo: target [
	| label index |
	label := jumpDestinations at: target.
	index := blocks indexOf: target.
	index == blocks size ifTrue: [^self].
	^((index - currentBlockIndex) abs > 18 or: true)
		ifTrue: [assembler jumpTo: label]
		ifFalse: [assembler shortJumpTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleJumpTrue: blockJumpTrue orJumpFalse: blockJumpFalse in: instruction [
	| success result loadFalse end |
	success := self
		tryOptimizing: instruction
		jumpTrue: blockJumpTrue
		jumpFalse: blockJumpFalse.
	success ifTrue: [^self].
	result := allocation at: instruction.
	loadFalse := assembler newLabel.
	end := assembler newLabel.
	blockJumpFalse value: loadFalse.
	assembler
		load: result withBoolean: true;
		shortJumpTo: end;
		@ loadFalse;
		load: result withBoolean: false;
		@ end
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLongSlotAt: instruction [
	| base index result |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleLongSlotAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: index.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result e from: base atIndexAt: index.
	result != index ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLongSlotAtConstant: instruction [
	| src dst |
	src := allocation at: instruction base.
	dst := allocation at: instruction ifAbsent: [^self].
	assembler load: dst e from: src atIndex: instruction index value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLongSlotAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler store: value e in: base index: instruction index value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLongSlotAtPut: instruction [
	| base value index |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleLongSlotAtConstantPut: instruction].
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value e in: base indexAt: index;
		convertToSmallInteger: index
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLower: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfLessSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleLowerEqual: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterSignedTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleMinus: instruction [
	| left instright right |
	left := allocation at: instruction left.
	instright := instruction right.
	right := instright isConstant ifTrue: [instright value * 2] ifFalse: [
		assembler add: 1 to: left.
		allocation at: instright].
	assembler subtract: right from: left
]

{ #category : #private }
OptimizingCodeEmitter >> assembleMoveConstant: value to: register [
	| constant |
	value isSmallInteger ifTrue: [
		constant := value * 2 + 1.
		^assembler load: register withImmediate: constant].
	value ifNil: [^assembler loadWithNil: register].
	value = false ifTrue: [^assembler loadWithFalse: register].
	value = true ifTrue: [^assembler loadWithTrue: register].
	assembler load: register withPointer: value
]

{ #category : #private }
OptimizingCodeEmitter >> assembleNegate: instruction [
	| src dst |
	src := allocation at: instruction receiver.
	dst := allocation at: instruction.
	self _ASSERT: dst = src.
	assembler
		negate: src;
		add: 2 to: dst
]

{ #category : #private }
OptimizingCodeEmitter >> assembleNotEqual: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfNotEqualTo: label]
		jumpFalse: [:label | assembler jumpIfEqualTo: label]
]

{ #category : #private }
OptimizingCodeEmitter >> assembleObjectAtOffsetPut: instruction [
	| base value offset |
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	offset := instruction left value.
	assembler storePointer: value in: base offset: offset
]

{ #category : #private }
OptimizingCodeEmitter >> assemblePlus: instruction [
	| left instright right |
	left := allocation at: instruction left.
	instright := instruction right.
	right := instright isConstant ifTrue: [instright value * 2] ifFalse: [
		assembler clearIntegerBit: left.
		allocation at: instright].
	assembler add: right to: left
]

{ #category : #private }
OptimizingCodeEmitter >> assemblePop: instruction [
	| register |
	register := allocation at: instruction.
	assembler pop: register
]

{ #category : #private }
OptimizingCodeEmitter >> assemblePush: instruction [
	| register |
	register := allocation at: instruction receiver.
	assembler push: register
]

{ #category : #private }
OptimizingCodeEmitter >> assembleTimes: instruction [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler
		clearIntegerBit: left;
		convertToNativeInteger: right;
		multiply: left by: right
]

{ #category : #private }
OptimizingCodeEmitter >> assembleTransferControlTo: instruction [
	| code receiver activation |
	receiver := allocation at: instruction left.
	code := allocation at: instruction right.
	receiver == assembler regA ifTrue: [
		code == assembler regT
			ifTrue: [
				assembler move: assembler regA to: assembler regR.
				receiver := assembler regR]
			ifFalse: [
				assembler move: assembler regA to: assembler regT.
				receiver := assembler regT]].
	self assembleCopyIfNeeded: code to: assembler regM.
	self assembleCopyIfNeeded: receiver to: assembler regR.
	activation := self activation.
	(activation savesPreviousSelf and: [activation hasFrame])
		ifTrue: [assembler pop: assembler regS].
	assembler restoreCallerFrame; jumpToMindex: 1
]

{ #category : #private }
OptimizingCodeEmitter >> assembleULongAt: instruction [
	| result |
	self assembleLongSlotAt: instruction.
	result := allocation at: instruction.
	assembler convertToSmallInteger: result
]

{ #category : #private }
OptimizingCodeEmitter >> assembleULongAtPut: instruction [
	| value |
	value := allocation at: instruction value.
	assembler convertToNativeInteger: value.
	self assembleLongSlotAtPut: instruction.
	assembler convertToSmallInteger: value
]

{ #category : #inquiries }
OptimizingCodeEmitter >> currentBlock [
	^blocks at: currentBlockIndex
]

{ #category : #initialization }
OptimizingCodeEmitter >> initialize [
	jumpDestinations := Dictionary new.
	self initializeLowLevelAssembler; initializeAssemblers
]

{ #category : #initialization }
OptimizingCodeEmitter >> initializeAssemblers [
	assemblers := Dictionary new
		at: #_smiPlus: put: #Plus;
		at: #_smiMinus: put: #Minus;
		at: #_smiTimes: put: #Times;
		at: #_smiBitAnd: put: #BitAnd;
		at: #_smiBitOr: put: #BitOr;
		at: #_smiBitShift: put: #BitShift;
		at: #_smiNegate put: #Negate;
		at: #_equals: put: #Equals;
		at: #_identityEquals: put: #Equals;
		at: #_notEquals: put: #NotEqual;
		at: #_notIdentityEquals: put: #NotEqual;
		at: #_smiLessThan: put: #Lower;
		at: #_smiLessEqualThan: put: #LowerEqual;
		at: #_smiGreaterEqualThan: put: #GreaterEqual;
		at: #_smiGreaterThan: put: #Greater;
		at: #_overflowed put: #CheckOverflow;
		at: #_asNative put: #AsNative;
		at: #_asObject put: #AsObject;
		at: #_asPointer put: #AsPointer;
		at: #_asSmallInteger put: #AsSmallInteger;
		at: #_byteAt: put: #ByteAt;
		at: #_basicAt: put: #BasicAt;
		at: #_longSlotAt: put: #LongSlotAt;
		at: #_uLongAt: put: #ULongAt;
		at: #_byteAt:put: put: #ByteAtPut;
		at: #_basicAt:put: put: #BasicAtPut;
		at: #_longSlotAt:put: put: #LongSlotAtPut;
		at: #_uLongAt:put: put: #ULongAtPut;
		at: #_objectAtOffset:put: put: #ObjectAtOffsetPut;
		at: #_isSmallInteger put: #IsSmallInteger;
		at: #_transferControlTo: put: #TransferControlTo;
		at: #push put: #Push;
		at: #pop put: #Pop;
		at: #copy put: #Copy;
		at: #copyResult put: #CopyResult;
		yourself
]

{ #category : #initialization }
OptimizingCodeEmitter >> initializeLowLevelAssembler [
	assembler := JITAssembler64 new
]

{ #category : #testing }
OptimizingCodeEmitter >> jumpWasAssembledInComparison: aConditionalJump [
	^(self optimizableJumpFor: aConditionalJump variable) == aConditionalJump
]

{ #category : #private }
OptimizingCodeEmitter >> labelBlocks [
	blocks do: [:block | | label |
		label := assembler newLabel.
		jumpDestinations at: block put: label]
]

{ #category : #private }
OptimizingCodeEmitter >> loadMifNeeded [
	| selector |
	selector := method baseMethod selector.
	selector == #_dispatchOn: ifTrue: [^assembler loadMwithGlobal: #Lookup].
	selector == #_dispatchOn:startingAt:
		ifTrue: [^assembler loadMwithGlobal: #LookupSuper].
	selector == #_dispatchDebuggableOn:
		ifTrue: [^assembler loadMwithGlobal: #DebuggableLookup].
	selector == #_dispatchDebuggableOn:startingAt:
		ifTrue: [^assembler loadMwithGlobal: #DebuggableLookupSuper]
]

{ #category : #accessing }
OptimizingCodeEmitter >> method: anOMethod [
	method := anOMethod.
	assembler wordSize: method abi wordSize
]

{ #category : #inquiries }
OptimizingCodeEmitter >> nativeCode [
	^assembler nativeCode
]

{ #category : #inquiries }
OptimizingCodeEmitter >> nextBlock [
	^blocks at: currentBlockIndex + 1 ifAbsent: [nil]
]

{ #category : #testing }
OptimizingCodeEmitter >> optimizableJumpFor: check [
	| inst |
	check isUsedJustOnce ifFalse: [^nil].
	check isCheck ifFalse: [^nil].
	inst := check next.
	inst isConstant ifTrue: [inst := inst next].
	inst isConditionalJump ifFalse: [^nil].
	^inst
]

{ #category : #testing }
OptimizingCodeEmitter >> savesPreviousSelf [
	^self activation savesPreviousSelf
]

{ #category : #inquiries }
OptimizingCodeEmitter >> selectorFor: instruction [
	^assemblers at: instruction name
]

{ #category : #testing }
OptimizingCodeEmitter >> tryOptimizing: check jumpTrue: blockJumpTrue jumpFalse: blockJumpFalse [
	| inst label block |
	inst := self optimizableJumpFor: check.
	inst ifNil: [^false].
	label := jumpDestinations at: inst target.
	block := inst isJumpTrue ifTrue: [blockJumpTrue] ifFalse: [blockJumpFalse].
	block value: label.
	self nextBlock != inst implicitTarget
		ifTrue: [self assembleJumpTo: inst implicitTarget].
	^true
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitBinary: instruction [
	self visitGeneric: instruction
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitBranch: branch comparing: aBoolean [
	| reg |
	(self jumpWasAssembledInComparison: branch) ifTrue: [^self].
	reg := allocation at: branch variable.
	assembler compare: reg withBoolean: aBoolean.
	self assembleJumpIfEqualTo: branch target.
	branch implicitTarget != self nextBlock
		ifTrue: [self assembleJumpTo: branch implicitTarget]
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitGeneric: instruction [
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitJump: aJump [
	aJump target == self nextBlock ifTrue: [^self].
	self assembleJumpTo: aJump target
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitJumpFalse: aJumpFalse [
	self visitBranch: aJumpFalse comparing: false
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitJumpTrue: aJumpTrue [
	self visitBranch: aJumpTrue comparing: true
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitLoad: instruction [
	self visitGeneric: instruction
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitMessageSend: aMessageSend [
	self assembleGenericMessageSend: aMessageSend.
	self activation haveFrame
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitMoveConstant: aMoveConstant [
	| register value |
	register := allocation at: aMoveConstant ifAbsent: [^self].
	value := aMoveConstant value.
	self assembleMoveConstant: value to: register
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitNullary: instruction [
	self visitGeneric: instruction
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitPhi: phiInstruction [
	
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitProjection: instruction [
	| frame |
	instruction name == #activation ifTrue: [
		assembler buildFrame.
		^self loadMifNeeded].
	instruction name == #self ifFalse: [^self].
	frame := method activation.
	frame hasFrame ifFalse: [^self].
	assembler
		reserveStackSlots: frame temporaries + 2;
		store: assembler regR in: assembler regFP index: 0;
		store: assembler regM in: assembler regFP index: -1.
	self savesPreviousSelf
		ifTrue: [assembler push: assembler regS; pushM; loadMwithA]
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitReturn: aReturnInstruction [
	| source |
	source := allocation at: aReturnInstruction source.
	self assembleCopyIfNeeded: source to: assembler regR.
	self savesPreviousSelf
		ifTrue: [assembler popM; popS; restoreCallerFrame]
		ifFalse: [
			assembler
				restoreCallerFrame;
				load: assembler regS from: assembler regFP atIndex: 0;
				restoreCallerM].
	assembler return
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitStore: instruction [
	self visitGeneric: instruction
]

{ #category : #visiting }
OptimizingCodeEmitter >> visitUnary: instruction [
	self visitGeneric: instruction
]

