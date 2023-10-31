"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ODispatchInliner,
	#superclass : #Object,
	#instVars : [
		'inlinerMethod',
		'switch',
		'send',
		'receiver',
		'arguments',
		'comparedValue',
		'spentProbability',
		'phi',
		'currentBlock',
		'end',
		'maxSize'
	],
	#category : #OCompiler
}

{ #category : #'instance creation' }
ODispatchInliner class >> new [
	^super new initialize
]

{ #category : #private }
ODispatchInliner >> checkedInlineIfProfitable: anOTypeCase [
	| constant compare probability case next |
	constant := anOTypeCase token asMoveConstant.
	compare := OEquals left: comparedValue right: constant.
	probability := anOTypeCase probability.
	spentProbability := spentProbability + probability.
	case := OBasicBlock new.
	next := OBasicBlock new.
	case probability: currentBlock probability * probability.
	next probability: currentBlock probability * (1 - spentProbability).
	currentBlock
		add: constant;
		add: compare;
		endWithJumpFalseTo: next skipping: case if: compare.
	currentBlock := case.
	self inlineIfProfitable: anOTypeCase.
	currentBlock := next
]

{ #category : #initialization }
ODispatchInliner >> initialize [
	switch := OTypeSwitch new.
	spentProbability := 0
]

{ #category : #services }
ODispatchInliner >> inline: aMessageSend in: block [
	send := aMessageSend.
	receiver := aMessageSend receiver.
	arguments := aMessageSend arguments.
	currentBlock := block.
	end := block splitAfter: aMessageSend.
	phi := OPhi new.
	end afterInsert: phi.
	comparedValue := switch needsBehavior
		ifTrue: [self loadReceiverBehavior]
		ifFalse: [receiver].
	switch
		allButLastDo: [:case | self checkedInlineIfProfitable: case]
		finally: [:last | self inlineIfProfitable: last].
	aMessageSend replaceAllUsesWith: phi; dissolve.
	^phi -> end
]

{ #category : #private }
ODispatchInliner >> inlineIfProfitable: anOTypeCase [
	| dispatched omethod |
	anOTypeCase isStatic ifFalse: [^self lookupSend].
	dispatched := anOTypeCase method.
	self
		log: 'specializing ' , dispatched printString , ' for '
			, anOTypeCase token printString.
	omethod := inlinerMethod compiler irFrom: dispatched.
	omethod
		bindArgumentsTo: send;
		conditionalProbability: currentBlock probability;
		inlineFactor: inlinerMethod inlineFactor / 2.0;
		inlineMessages.
	(self shouldInline: omethod) ifTrue: [self inlineMethod: omethod] ifFalse: [
		omethod dissolveDeep.
		self invokeMethod: dispatched]
]

{ #category : #accessing }
ODispatchInliner >> inlineMethod: anOMethod [
	| return source exit jump |
	anOMethod moveTemporariesTo: inlinerMethod.
	return := anOMethod returnValue.
	currentBlock endWithJumpTo: anOMethod start.
	source := return source.
	exit := return basicBlock.
	jump := return next.
	jump dissolve.
	exit endWithJumpTo: end.
	anOMethod stop replaceAllUsesWith: inlinerMethod stop.
	phi addVariable: source from: exit.
	return dissolve.
	self
		log: 'finished inlining ' , anOMethod baseMethod printString , ' into: '
			, inlinerMethod baseMethod printString
]

{ #category : #accessing }
ODispatchInliner >> inlinerMethod: anOMethod [
	inlinerMethod := anOMethod
]

{ #category : #services }
ODispatchInliner >> invokeMethod: aCompiledMethod [
	| invoke linker |
	self log: 'invoking ' , aCompiledMethod printString.
	linker := InvokeLinker new
		instructions: inlinerMethod messageLinker invokeLinker instructions;
		addMethod: aCompiledMethod.
	invoke := OMessageSend
		receiver: receiver
		selector: send selector
		arguments: arguments copy
		linker: linker.
	currentBlock add: invoke; endWithJumpTo: end.
	phi addVariable: invoke from: currentBlock
]

{ #category : #private }
ODispatchInliner >> loadReceiverBehavior [
	| behavior load |
	behavior := OBehavior new object: receiver.
	load := OLoadOperation base: behavior longSlotAtImm: 1.
	currentBlock add: behavior; add: load.
	^load
]

{ #category : #logging }
ODispatchInliner >> log: aString [
	LogCompilation ifTrue: [aString print]
]

{ #category : #services }
ODispatchInliner >> lookupSend [
	| dynamic |
	dynamic := OMessageSend
		receiver: receiver
		selector: send selector
		arguments: arguments copy
		linker: inlinerMethod messageLinker.
	currentBlock add: dynamic; endWithJumpTo: end.
	phi addVariable: dynamic from: currentBlock
]

{ #category : #accessing }
ODispatchInliner >> maxSize: aNumber [
	maxSize := aNumber
]

{ #category : #printing }
ODispatchInliner >> printOn: aStream [
	aStream print: self class; cr; print: switch
]

{ #category : #private }
ODispatchInliner >> shouldInline: omethod [
	"
	The cost of inlining is the size of the inlined code minus the savings for not building
	a stack frame nor pushing the arguments and loading them from the method.
	"
	| savings cost limit |
	savings := omethod argumentCount * 2 + 4.
	cost := omethod size - savings.
	limit := maxSize * currentBlock probability.
	self
		log: 'cost of inlining ' , omethod baseMethod printString , ' is: '
			, cost printString
			, '. Limit is: '
			, ((limit * 100) truncated / 100.0) printString.
	^cost <= limit
]

{ #category : #accessing }
ODispatchInliner >> staticDispatch: aCompiledMethod [
	switch staticDispatch: aCompiledMethod
]

{ #category : #accessing }
ODispatchInliner >> types: aSequenceableCollection [
	switch types: aSequenceableCollection
]

