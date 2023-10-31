"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OFunction,
	#superclass : #ONode,
	#instVars : [
		'start',
		'stop',
		'activation',
		'receiver',
		'arguments',
		'temporaries',
		'environment',
		'returnValue',
		'inlineFactor'
	],
	#category : #IR
}

{ #category : #accessing }
OFunction >> activation [
	^activation
]

{ #category : #accessing }
OFunction >> activation: anOActivation [
	activation := anOActivation
]

{ #category : #'adding / removing' }
OFunction >> addArgument: aString [
	| arg |
	arg := OArgument new
		input: self;
		name: aString asSymbol;
		index: arguments size + 1.
	arguments add: arg.
	^arg
]

{ #category : #'adding / removing' }
OFunction >> addTemporary: aString [
	| temp |
	temp := OTemporary new
		input: self;
		name: aString asSymbol;
		index: temporaries size + 1.
	temporaries add: temp.
	^temp
]

{ #category : #enumerating }
OFunction >> allBlocks [
	| result remaining |
	result := OrderedCollection new.
	remaining := OrderedCollection with: self.
	[remaining notEmpty] whileTrue: [| function |
		function := remaining removeFirst.
		function usesDo: [:use | | user |
			user := use user.
			user isBlockClosure ifTrue: [
				remaining add: user.
				result add: user]]].
	^result
]

{ #category : #inquiries }
OFunction >> argumentAt: index [
	^arguments at: index
]

{ #category : #inquiries }
OFunction >> argumentNamed: aSymbol [
	^arguments detect: [:arg | arg name == aSymbol]
]

{ #category : #accessing }
OFunction >> arguments [
	^arguments
]

{ #category : #accessing }
OFunction >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #copying }
OFunction >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		activation: (activation duplicateWith: map);
		receiver: (receiver duplicateWith: map);
		arguments: (arguments collect: [:arg | arg duplicateWith: map]);
		temporaries: (temporaries collect: [:temp | temp duplicateWith: map]);
		environment: (environment duplicateWith: map);
		returnValue: (returnValue duplicateWith: map)
]

{ #category : #services }
OFunction >> dissolveDeep [
	start withSuccessorsDo: [:block | block dissolveAllInstructions]
]

{ #category : #accessing }
OFunction >> environment [
	^environment
]

{ #category : #accessing }
OFunction >> environment: anOEnvironment [
	environment := anOEnvironment
]

{ #category : #initialization }
OFunction >> initialize [
	| last |
	start := OBasicBlock new.
	stop := OBasicBlock new.
	activation := OActivation new input: self.
	returnValue := OReturn new frame: activation; source: nil asMoveConstant.
	last := OBasicBlock new.
	last add: returnValue; endWithJumpTo: stop.
	receiver := OSelf new input: self.
	environment := OEnvironment new input: self.
	arguments := OrderedCollection new.
	temporaries := OrderedCollection new.
	inlineFactor := 4
]

{ #category : #accessing }
OFunction >> inlineFactor [
	^inlineFactor
]

{ #category : #accessing }
OFunction >> inlineFactor: aNumber [
	inlineFactor := aNumber
]

{ #category : #inquiries }
OFunction >> lastBlock [
	^start lastBlock
]

{ #category : #services }
OFunction >> localReturn: anONode from: anOBasicBlock [
	returnValue addReturnValue: anONode from: anOBasicBlock
]

{ #category : #moving }
OFunction >> lower [
	temporaries do: [:temp | temp lower].
	arguments do: [:arg | arg lower].
	environment lowerInstantiation.
	start instructionsWithSuccessorsDo: [:inst | inst lowerIn: self]
]

{ #category : #inquiries }
OFunction >> metaprocess [
	start reversePostOrderDo: [:block | 
		block
			instructionsDo: [:inst | (inst isMessageSend
				and: [inst canBeMetaprocessed])
				ifTrue: [inst metaprocess]]]
]

{ #category : #services }
OFunction >> moveTemporariesTo: anOFunction [
	temporaries do: [:temp | | new |
		new := anOFunction addTemporary: temp name.
		temp replaceAllUsesWith: new].
	activation dissolve
]

{ #category : #services }
OFunction >> nonLocalReturn: anONode from: anOBasicBlock [
	| return |
	return := ONonLocalReturn new
		frame: activation;
		source: anONode;
		home: self method.
	anOBasicBlock add: return; endWithJumpTo: stop
]

{ #category : #printing }
OFunction >> primitivePrintString [
	^'{' , self class name , ' ' , self basicHash printString , '}'
]

{ #category : #printing }
OFunction >> printOn: aStream [
	aStream
		print: self class;
		space;
		print: self basicHash;
		cr.
	start printAllNamedOn: aStream function: self
]

{ #category : #accessing }
OFunction >> receiver [
	^receiver
]

{ #category : #accessing }
OFunction >> receiver: anOSelf [
	receiver := anOSelf
]

{ #category : #enumerating }
OFunction >> removeUnreachableBasicBlocks [
	| reachable |
	reachable := start withSuccessorsPostOrder asIdentitySet.
	reachable do: [:bb | 
		" we iterate backwards to allow removal while iterating "
		bb predecessors
			reverseDo: [:pred | (reachable includes: pred)
				ifFalse: [bb removePredecessor: pred]]]
]

{ #category : #enumerating }
OFunction >> removeUnreachableUses [
	| seen stack |
	seen := IdentitySet new.
	stack := OrderedCollection new.
	start instructionsWithSuccessorsDo: [:inst | 
		stack add: inst.
		[stack isEmpty] whileFalse: [| node |
			node := stack removeLast.
			(seen includes: node) ifFalse: [
				seen add: node.
				node operandsDo: [:op | stack add: op]]]].
	seen
		do: [:inst | inst
			removeUsesSuchThat: [:use | (seen includes: use user) not]]
]

{ #category : #accessing }
OFunction >> return: anONode [
	returnValue source: anONode
]

{ #category : #accessing }
OFunction >> returnValue [
	^returnValue
]

{ #category : #accessing }
OFunction >> returnValue: anOReturn [
	returnValue := anOReturn
]

{ #category : #services }
OFunction >> scheduleNodes [
	start addFront: receiver; addFront: activation
]

{ #category : #accessing }
OFunction >> start [
	^start
]

{ #category : #accessing }
OFunction >> start: basicBlock [
	start := basicBlock
]

{ #category : #accessing }
OFunction >> stop [
	^stop
]

{ #category : #accessing }
OFunction >> stop: basicBlock [
	stop := basicBlock
]

{ #category : #accessing }
OFunction >> temporaries [
	^temporaries
]

{ #category : #accessing }
OFunction >> temporaries: aCollection [
	temporaries := aCollection
]

{ #category : #inquiries }
OFunction >> temporaryAt: index [
	^temporaries at: index
]

