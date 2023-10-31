"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OMethod,
	#superclass : #OFunction,
	#instVars : [
		'baseMethod',
		'compiler'
	],
	#category : #IR
}

{ #category : #inquiries }
OMethod >> abi [
	^compiler abi
]

{ #category : #inquiries }
OMethod >> allActivations [
	^start nodesSelect: [:node | node class == OActivation]
]

{ #category : #inquiries }
OMethod >> allFunctions [
	| result worklist |
	result := OrderedSet new.
	worklist := OrderedCollection new.
	worklist add: self.
	[worklist isEmpty] whileFalse: [| function |
		function := worklist removeFirst.
		(result includes: function) ifFalse: [
			result add: function.
			function start
				instructionsWithSuccessorsDo: [:inst | inst
					operandsDo: [:o | o isBlockClosure ifTrue: [worklist add: o]]]]].
	^result
]

{ #category : #inquiries }
OMethod >> argumentCount [
	^baseMethod argumentCount
]

{ #category : #accessing }
OMethod >> baseMethod [
	^baseMethod
]

{ #category : #accessing }
OMethod >> baseMethod: aCompiledMethod [
	baseMethod := aCompiledMethod
]

{ #category : #services }
OMethod >> bindArgumentsTo: aMessageSend [
	| recv worklist blocks |
	worklist := OrderedCollection new.
	arguments do: [:arg | worklist addAll: arg users].
	worklist addAll: receiver users.
	blocks := self allBlocks.
	blocks do: [:block | 
		block arguments do: [:arg | worklist addAll: arg users].
		worklist addAll: block receiver users].
	arguments
		with: aMessageSend arguments
		do: [:formal :actual | formal replaceAllUsesWith: actual].
	recv := aMessageSend receiver.
	receiver replaceAllUsesWith: recv; dissolve.
	blocks do: [:block | 
		block arguments
			with: aMessageSend arguments
			do: [:formal :actual | formal replaceAllUsesWith: actual].
		recv := aMessageSend receiver.
		block receiver replaceAllUsesWith: recv].
	self optimize: worklist
]

{ #category : #accessing }
OMethod >> compiler [
	^compiler
]

{ #category : #accessing }
OMethod >> compiler: anOCompiler [
	compiler := anOCompiler.
	self inlineFactor: anOCompiler initialInlineFactor
]

{ #category : #inquiries }
OMethod >> conditionalProbability: aNumber [
	start
		withSuccessorsDo: [:block | block probability: block probability * aNumber]
]

{ #category : #copying }
OMethod >> copyTo: copy with: map [
	self _ASSERT: false
]

{ #category : #services }
OMethod >> explicitReturn: value from: anOBasicBlock [
	self localReturn: value from: anOBasicBlock
]

{ #category : #services }
OMethod >> implicitReturn: last from: anOBasicBlock [
	self localReturn: receiver from: anOBasicBlock
]

{ #category : #testing }
OMethod >> isMethod [
	^true
]

{ #category : #inquiries }
OMethod >> messageLinker [
	^compiler messageLinker
]

{ #category : #inquiries }
OMethod >> method [
	^self
]

{ #category : #printing }
OMethod >> printOn: aStream [
	aStream
		print: self class;
		space;
		print: baseMethod;
		cr.
	start printAllNamedOn: aStream function: self
]

{ #category : #inquiries }
OMethod >> schedule [
	| schedule grouped |
	self removeUnreachableBasicBlocks; removeUnreachableUses.
	start computeDominance.
	schedule := IdentityDictionary new.
	stop scheduleEarly: schedule start: start.
	grouped := OrderedDictionary new.
	schedule keysDo: [:inst | inst scheduleLate: schedule lists: grouped].
	grouped
		keysAndValuesDo: [:bb :instructions | bb scheduleLocal: instructions]
]

{ #category : #inquiries }
OMethod >> size [
	^start withSuccessorsPostOrder sum: [:bb | bb size]
]

{ #category : #inquiries }
OMethod >> stackIndexOfArg: anOArgument [
	^arguments size - anOArgument index + 3
]

{ #category : #inquiries }
OMethod >> stackIndexOfTemp: anOTemporary [
	^-1 - anOTemporary index
]

{ #category : #inquiries }
OMethod >> tempCount [
	^baseMethod tempCount
]

{ #category : #validation }
OMethod >> validate [
	self validateAllInstructions; validateCFG
]

{ #category : #validation }
OMethod >> validateAllInstructions [
	start withSuccessorsDo: [:block | | forward current backwards |
		forward := OrderedCollection new.
		current := block.
		[current notNil] whileTrue: [
			self _DENY: (forward includes: current).
			forward add: current.
			current := current next].
		backwards := OrderedCollection new.
		current := forward last.
		[current notNil] whileTrue: [
			self _DENY: (backwards includes: current).
			backwards add: current.
			current := current prev].
		self _ASSERT: forward = backwards reversed].
	self allFunctions do: [:function | 
		function start
			instructionsWithSuccessorsDo: [:inst | inst
				validateUses;
				validateOperands]]
]

{ #category : #validation }
OMethod >> validateCFG [
	start withSuccessorsDo: [:block | 
		block successors
			do: [:successor | self _ASSERT: (successor predecessors includes: block)].
		block predecessors
			do: [:predecessor | self _ASSERT: (predecessor successors includes: block)]]
]

