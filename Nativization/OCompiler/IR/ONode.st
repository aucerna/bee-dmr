"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ONode,
	#superclass : #Object,
	#instVars : [
		'firstUse'
	],
	#category : #IR
}

{ #category : #'instance creation' }
ONode class >> new [
	^super new initialize
]

{ #category : #metaprocessing }
ONode >> _asNative [
	^self unaryUser: #_asNative
]

{ #category : #metaprocessing }
ONode >> _asObject [
	^self unaryUser: #_asObject
]

{ #category : #metaprocessing }
ONode >> _asPointer [
	^self unaryUser: #_asPointer
]

{ #category : #metaprocessing }
ONode >> _asSmallInteger [
	^self unaryUser: #_asSmallInteger
]

{ #category : #metaprocessing }
ONode >> _basicAt: index [
	^index isConstant
		ifTrue: [self loadSlotAtImm: index value]
		ifFalse: [self loadSlotAt: index]
]

{ #category : #metaprocessing }
ONode >> _basicAt: index put: value [
	^index isConstant
		ifTrue: [self storeSlotAtImm: index value with: value]
		ifFalse: [self storeSlotAt: index with: value]
]

{ #category : #metaprocessing }
ONode >> _basicFlags [
	^self loadByteAtImm: _Flags
]

{ #category : #metaprocessing }
ONode >> _basicFlags: value [
	^self storeByteAtImm: _Flags with: value
]

{ #category : #metaprocessing }
ONode >> _byteAt: index [
	^index isConstant
		ifTrue: [self loadByteAtImm: index value]
		ifFalse: [self loadByteAt: index]
]

{ #category : #metaprocessing }
ONode >> _byteAt: index put: value [
	^index isConstant
		ifTrue: [self storeByteAtImm: index value with: value]
		ifFalse: [self storeByteAt: index with: value]
]

{ #category : #metaprocessing }
ONode >> _equals: anInteger [
	^OEquals left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _isSmallInteger [
	^OIsSmallInteger receiver: self
]

{ #category : #metaprocessing }
ONode >> _largeSize [
	^self loadULongAtImm: _ExtendedSize
]

{ #category : #metaprocessing }
ONode >> _largeSize: value [
	^self storeULongAtImm: _ExtendedSize with: value
]

{ #category : #metaprocessing }
ONode >> _longSlotAt: index [
	^index isConstant
		ifTrue: [self loadLongSlotAtImm: index value]
		ifFalse: [self loadLongSlotAt: index]
]

{ #category : #metaprocessing }
ONode >> _longSlotAt: index put: value [
	^index isConstant
		ifTrue: [self storeLongSlotAtImm: index value with: value]
		ifFalse: [self storeLongSlotAt: index with: value]
]

{ #category : #metaprocessing }
ONode >> _notEquals: anInteger [
	^ONotEquals left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _objectAtOffset: offset put: value [
	^offset isConstant
		ifTrue: [self storeSlotAtOffsetImm: offset value with: value]
		ifFalse: [self storeSlotAtOffset: offset with: value]
]

{ #category : #metaprocessing }
ONode >> _overflowed [
	^OOverflowCheck receiver: self
]

{ #category : #metaprocessing }
ONode >> _smallSize [
	^self loadByteAtImm: _SmallSize
]

{ #category : #metaprocessing }
ONode >> _smallSize: value [
	^self storeByteAtImm: _SmallSize with: value
]

{ #category : #metaprocessing }
ONode >> _smiBitAnd: anInteger [
	^OSMIBitAnd left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiBitOr: anInteger [
	^OSMIBitOr left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiBitsAt: anInteger [
	^OSMIBitsAt left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiBitShift: anInteger [
	^OSMIBitShift left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiGreaterEqualThan: anInteger [
	^OSMIGreaterEqualThan left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiGreaterThan: anInteger [
	^OSMIGreaterThan left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiLessEqualThan: anInteger [
	^OSMILessEqualThan left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiLessThan: anInteger [
	^OSMILessThan left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiMinus: anInteger [
	^OSMIMinus left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiMultiply: anInteger [
	^OSMIMultiply left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiPlus: anInteger [
	^OSMIPlus left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _smiQuotient: anInteger [
	^OSMIQuotient left: self right: anInteger
]

{ #category : #metaprocessing }
ONode >> _transferControlTo: mcode [
	^OBinaryOperation left: self right: mcode name: #_transferControlTo:
]

{ #category : #'adding / removing' }
ONode >> addUse: new [
	firstUse ifNil: [firstUse := new] ifNotNil: [firstUse addUse: new]
]

{ #category : #'adding / removing' }
ONode >> addUse: user at: name [
	| operand |
	operand := OOperand at: user named: name.
	self _ASSERT: operand definition == self.
	self addUse: operand
]

{ #category : #inquiries }
ONode >> allUses [
	| result following |
	result := OrderedCollection new.
	following := firstUse.
	[following notNil] whileTrue: [
		result add: following.
		following := following nextUse].
	^result
]

{ #category : #inquiries }
ONode >> atOperand: name [
	^nil
]

{ #category : #services }
ONode >> atOperand: operandName put: instruction [
	^nil
]

{ #category : #inquiries }
ONode >> basicBlock [
	^nil
]

{ #category : #printing }
ONode >> basicPrintString [
	^self primitivePrintString
]

{ #category : #testing }
ONode >> canHaveSideEffects [
	^true
]

{ #category : #services }
ONode >> changeUseFrom: anInstruction to: anotherInstruction at: operand [
	anotherInstruction addUse: self at: operand.
	anInstruction removeUse: self at: operand
]

{ #category : #copying }
ONode >> copyTo: copy with: map [
	
]

{ #category : #metaprocessing }
ONode >> dissolve [
	self remove; release
]

{ #category : #metaprocessing }
ONode >> dissolveDeep [
	self dissolve
]

{ #category : #metaprocessing }
ONode >> dissolveIfUnused [
	self isUsed ifFalse: [self dissolve]
]

{ #category : #metaprocessing }
ONode >> dissolveIfUseless [
	self isUseless ifTrue: [self dissolveDeep]
]

{ #category : #copying }
ONode >> duplicateWith: map [
	^map at: self ifAbsent: [self]
]

{ #category : #accessing }
ONode >> firstUse [
	^firstUse
]

{ #category : #'adding / removing' }
ONode >> insertCopyBefore: anInstruction [
	| copy |
	copy := self newCopy.
	anInstruction beforeInsert: copy.
	^copy
]

{ #category : #'adding / removing' }
ONode >> insertPushBefore: anInstruction [
	| push |
	push := OPushOperation receiver: self.
	anInstruction beforeInsert: push.
	^push
]

{ #category : #testing }
ONode >> isActivation [
	^false
]

{ #category : #testing }
ONode >> isArgument [
	^false
]

{ #category : #testing }
ONode >> isBlockClosure [
	^false
]

{ #category : #testing }
ONode >> isBlockStart [
	^false
]

{ #category : #testing }
ONode >> isBoolean [
	^false
]

{ #category : #testing }
ONode >> isCheck [
	^false
]

{ #category : #testing }
ONode >> isComparison [
	^false
]

{ #category : #testing }
ONode >> isConditionalJump [
	^false
]

{ #category : #testing }
ONode >> isConstant [
	^false
]

{ #category : #testing }
ONode >> isEnd [
	^false
]

{ #category : #testing }
ONode >> isGenericMessage [
	^false
]

{ #category : #testing }
ONode >> isInstruction [
	^false
]

{ #category : #testing }
ONode >> isJump [
	^false
]

{ #category : #testing }
ONode >> isLoad [
	^false
]

{ #category : #testing }
ONode >> isMemoryOperation [
	^false
]

{ #category : #testing }
ONode >> isMessageSend [
	^false
]

{ #category : #testing }
ONode >> isMethod [
	^false
]

{ #category : #testing }
ONode >> isONode [
	^true
]

{ #category : #testing }
ONode >> isPhi [
	^false
]

{ #category : #testing }
ONode >> isPrimitiveOperation [
	^false
]

{ #category : #testing }
ONode >> isProjection [
	^false
]

{ #category : #testing }
ONode >> isReceiver [
	^false
]

{ #category : #testing }
ONode >> isReturn [
	^false
]

{ #category : #testing }
ONode >> isScheduled [
	^true
]

{ #category : #testing }
ONode >> isStore [
	^false
]

{ #category : #testing }
ONode >> isTemporary [
	^false
]

{ #category : #testing }
ONode >> isUnconditionalJump [
	^self isJump andNot: [self isConditionalJump]
]

{ #category : #testing }
ONode >> isUsed [
	^firstUse notNil
]

{ #category : #testing }
ONode >> isUsedJustOnce [
	^firstUse notNil and: [firstUse nextUse isNil]
]

{ #category : #testing }
ONode >> isUsedOnlyBy: instruction [
	^self isUsedJustOnce and: [firstUse user == instruction]
]

{ #category : #testing }
ONode >> isUseless [
	^firstUse isNil andNot: [self canHaveSideEffects]
]

{ #category : #metaprocessing }
ONode >> loadByteAt: index [
	^OLoadOperation base: self byteAt: index
]

{ #category : #metaprocessing }
ONode >> loadByteAtImm: index [
	^OLoadOperation base: self byteAtImm: index
]

{ #category : #metaprocessing }
ONode >> loadLongSlotAt: index [
	^OLoadOperation base: self longSlotAt: index
]

{ #category : #metaprocessing }
ONode >> loadLongSlotAtImm: index [
	^OLoadOperation base: self longSlotAtImm: index
]

{ #category : #metaprocessing }
ONode >> loadSlotAt: index [
	^OLoadOperation base: self slotAt: index
]

{ #category : #metaprocessing }
ONode >> loadSlotAtImm: index [
	^OLoadOperation base: self slotAtImm: index
]

{ #category : #metaprocessing }
ONode >> loadULongAtImm: index [
	^OLoadOperation base: self uLongAtImm: index
]

{ #category : #metaprocessing }
ONode >> lowerIn: aBasicBlock [
	
]

{ #category : #copying }
ONode >> newCopy [
	^OCopyOperation receiver: self
]

{ #category : #inquiries }
ONode >> operands [
	| result |
	result := OrderedCollection new.
	self operandsDo: [:o | result add: o].
	^result select: #isONode
]

{ #category : #enumerating }
ONode >> operandsDo: aBlock [
	
]

{ #category : #services }
ONode >> optimize: aCollection [
	| done worklist |
	done := IdentitySet new.
	worklist := aCollection withoutDuplicates.
	[worklist isEmpty] whileFalse: [| node optimized user |
		node := worklist removeFirst.
		done add: node.
		optimized := node optimized.
		optimized == node ifFalse: [
			node usesDo: [:use | | user |
				user := use user.
				(done includes: user) ifFalse: [worklist add: user]].
			node replaceAllUsesWith: optimized; dissolve].
		(node isStore and: [node base isTemporary]) ifTrue: [
			node base usesDo: [:use | 
				user := use user.
				user isLoad ifTrue: [worklist add: user]]]]
]

{ #category : #services }
ONode >> optimized [
	^self
]

{ #category : #printing }
ONode >> primitivePrintString [
	^self class name
]

{ #category : #printing }
ONode >> printOn: aStream [
	"
	prev printBackwardOn: aStream.
	aStrem nextPutAll: '-> '
	"
	aStream
		nextPutAll: self basicPrintString
	"	next printForwardOn: aStream cr"
]

{ #category : #printing }
ONode >> printStringUsing: names [
	^names at: self ifAbsent: ['?']
]

{ #category : #metaprocessing }
ONode >> release [
	self
		operandsDo: [:instruction | instruction
			removeUseBy: self;
			dissolveIfUseless]
]

{ #category : #'adding / removing' }
ONode >> remove [
	
]

{ #category : #'adding / removing' }
ONode >> removeUse: anOperand [
	self _ASSERT: anOperand class == OOperand.
	firstUse == anOperand
		ifTrue: [
			firstUse := firstUse nextUse.
			anOperand nextUse: nil]
		ifFalse: [firstUse removeUse: anOperand]
]

{ #category : #'adding / removing' }
ONode >> removeUse: instruction at: name [
	(firstUse instruction == instruction and: [firstUse name = name])
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUse: instruction at: name]
]

{ #category : #'adding / removing' }
ONode >> removeUseBy: instruction [
	firstUse instruction == instruction
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUseBy: instruction]
]

{ #category : #enumerating }
ONode >> removeUsesSuchThat: aBlock [
	[firstUse notNil and: [aBlock value: firstUse]]
		whileTrue: [firstUse := firstUse nextUse].
	firstUse ifNotNil: [firstUse removeUsesSuchThat: aBlock]
]

{ #category : #services }
ONode >> replaceAllUsesWith: anInstruction [
	self == anInstruction ifTrue: [^self].
	firstUse ifNil: [^self].
	firstUse replaceAllUsesWith: anInstruction.
	self _ASSERT: firstUse isNil
]

{ #category : #services }
ONode >> replaceUsesBy: anInstruction with: anotherInstruction [
	firstUse
		ifNotNil: [firstUse replaceUsesBy: anInstruction with: anotherInstruction].
	^anotherInstruction
]

{ #category : #services }
ONode >> replaceUsesOf: anInstruction with: anotherInstruction [
	self operandsDo: [:inst | 
		inst = anInstruction
			ifTrue: [inst replaceUsesBy: self with: anotherInstruction]]
]

{ #category : #private }
ONode >> scheduleEarly: blocks start: anOBasicBlock [
	| current bb |
	self operandsDo: [:op | 
		(blocks includesKey: op)
			ifFalse: [op scheduleEarly: blocks start: anOBasicBlock]].
	self isScheduled ifTrue: [
		bb := self basicBlock ifNil: [anOBasicBlock].
		^blocks at: self put: bb].
	current := nil.
	self operandsDo: [:op | | opblock |
		opblock := blocks at: op.
		(current isNil or: [current dominatorDepth < opblock dominatorDepth])
			ifTrue: [current := opblock]].
	current ifNil: [current := anOBasicBlock].
	blocks at: self put: current
]

{ #category : #private }
ONode >> scheduleLate: blocks [
	"
	This is the scheduling algorithm used in Click's PhD thesis (sect 6.3.4).
	Unlike scheduleEarly, here users are scheduled late before we are scheduled.
	For each non-phi user, we try to schedule in the same block or its LCA (lowest
	common ancestor) with other users. For a phi user, we try to schedule from the
	block corresponding to the phi's incoming edge (not the block of the phi itself)
	"
	| current user |
	self
		usersDo: [:node | node isScheduled ifFalse: [node scheduleLate: blocks]].
	self isScheduled ifTrue: [^self].
	current := nil.
	self usesDo: [:op | | block |
		user := op user.
		block := user isPhi
			ifTrue: [user blockAt: op index]
			ifFalse: [blocks at: user].
		current := current
			ifNil: [block]
			ifNotNil: [current lowestCommonAncestor: block]].
	blocks at: self put: current
]

{ #category : #private }
ONode >> scheduleLate: blocks lists: lists [
	"
	This is the scheduling algorithm used in Click's PhD thesis (sect 6.3.4).
	Unlike scheduleEarly, here users are scheduled late before we are scheduled.
	For each non-phi user, we try to schedule in the same block or its LCA (lowest
	common ancestor) with other users. For a phi user, we try to schedule from the
	block corresponding to the phi's incoming edge (not the block of the phi itself).
	We use an ordered set to avoid random iteration order afterwards.
	"
	| current user list |
	self
		usersDo: [:node | node isScheduled
			ifFalse: [node scheduleLate: blocks lists: lists]].
	self isScheduled ifTrue: [^self].
	current := nil.
	self usesDo: [:op | | block |
		user := op user.
		block := user isPhi ifTrue: [op name] ifFalse: [blocks at: user].
		current := current
			ifNil: [block]
			ifNotNil: [current lowestCommonAncestor: block]].
	blocks at: self put: current.
	list := lists at: current ifAbsentPut: [OrderedSet new].
	list add: self
]

{ #category : #metaprocessing }
ONode >> storeByteAt: index with: value [
	^OStoreOperation base: self byteAt: index put: value
]

{ #category : #metaprocessing }
ONode >> storeByteAtImm: index with: value [
	^OStoreOperation base: self byteAtImm: index put: value
]

{ #category : #metaprocessing }
ONode >> storeLongSlotAt: index with: value [
	^OStoreOperation base: self longSlotAt: index put: value
]

{ #category : #metaprocessing }
ONode >> storeLongSlotAtImm: index with: value [
	^OStoreOperation base: self longSlotAtImm: index put: value
]

{ #category : #metaprocessing }
ONode >> storeSlotAt: index with: value [
	^OStoreOperation base: self slotAt: index put: value
]

{ #category : #metaprocessing }
ONode >> storeSlotAtImm: index with: value [
	^OStoreOperation base: self slotAtImm: index put: value
]

{ #category : #metaprocessing }
ONode >> storeSlotAtOffset: offset with: value [
	^OStoreOperation base: self slotAt: offset + 1 put: value
]

{ #category : #metaprocessing }
ONode >> storeSlotAtOffsetImm: offset with: value [
	^OStoreOperation base: self slotAtImm: offset + 1 put: value
]

{ #category : #metaprocessing }
ONode >> storeULongAtImm: index with: value [
	^OStoreOperation base: self uLongAtImm: index put: value
]

{ #category : #metaprocessing }
ONode >> unaryUser: selector [
	^OUnaryOperation new receiver: self; name: selector
]

{ #category : #services }
ONode >> updateUser: instruction named: oldName with: newName [
	self usesDo: [:use | 
		(use instruction == instruction and: [use name == oldName])
			ifTrue: [use name: newName]]
]

{ #category : #inquiries }
ONode >> users [
	| result following |
	result := OrderedCollection new.
	following := firstUse.
	[following notNil] whileTrue: [
		result add: following user.
		following := following nextUse].
	^result
]

{ #category : #enumerating }
ONode >> usersDo: aBlock [
	firstUse ifNotNil: [firstUse usersDo: aBlock]
]

{ #category : #enumerating }
ONode >> usesDo: aBlock [
	firstUse ifNotNil: [firstUse usesDo: aBlock]
]

{ #category : #validation }
ONode >> validateOperands [
	self
		operandsDo: [:operand | self
			_ASSERT: (operand allUses anySatisfy: [:use | use user == self])]
]

{ #category : #validation }
ONode >> validateUses [
	| found |
	found := Set new.
	self allUses do: [:use | 
		self _ASSERT: use definition == self.
		self _DENY: (found includes: use instruction -> use name).
		found add: use instruction -> use name]
]

