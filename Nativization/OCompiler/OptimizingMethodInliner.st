"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingMethodInliner,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'methods',
		'environment'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingMethodInliner class >> on: basicBlock [
	^self basicNew firstBlock: basicBlock
]

{ #category : #unclassified }
OptimizingMethodInliner >> bindArgumentsOf: firstBlockInlined with: aMessageSend [
	| inlined |
	inlined := firstBlockInlined activationRecord.
	inlined arguments
		with: aMessageSend arguments
		do: [:formal :actual | formal replaceAllUsesWith: actual; dissolve].
	inlined receiver replaceAllUsesWith: aMessageSend receiver; dissolve
]

{ #category : #unclassified }
OptimizingMethodInliner >> bindTemporariesOf: inlinedFrame into: inlinerFrame [
	| current added |
	current := inlinerFrame temporaries.
	added := inlinedFrame temporaries.
	"added > 0 ifTrue: [self halt]."
	inlinerFrame temporaries: current + added.
	inlinedFrame
		usesDo: [:operand | | user |
			user := operand instruction.
			user isMemoryOperation
				ifTrue: [
					"only temps remain, arguments have been dissolved"
					self _ASSERT: user index < 0.
					user indexImm: user index - current]
				ifFalse: [self _ASSERT: user isReturn]];
		replaceAllUsesWith: inlinerFrame;
		dissolve
]

{ #category : #unclassified }
OptimizingMethodInliner >> bindVariablesOf: initialBlock with: aMessageSend [
	| values |
	values := OrderedCollection
		with: aMessageSend receiver
		withAll: aMessageSend arguments.
	initialBlock instructionsDo: [:instruction | 
		instruction isDefineArgument ifFalse: [^self].
		instruction name == #activationRecord ifFalse: [
			instruction replaceAllUsesWith: values first.
			values removeFirst].
		instruction dissolve]
]

{ #category : #accessing }
OptimizingMethodInliner >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment
]

{ #category : #unclassified }
OptimizingMethodInliner >> firstBlock: aBasicBlock [
	firstBlock := aBasicBlock
]

{ #category : #unclassified }
OptimizingMethodInliner >> inlineAllMessages [
	firstBlock withSuccessorsPostOrder do: [:block | | current |
		current := block.
		block instructionsAsCollection do: [:instruction | 
			(self shouldInline: instruction)
				ifTrue: [current := self inlineMethod: instruction in: current]]]
]

{ #category : #unclassified }
OptimizingMethodInliner >> inlinedMethodFor: aMessageSend [
	^methods detect: [:m | m selector == aMessageSend selector]
]

{ #category : #unclassified }
OptimizingMethodInliner >> inlineMessages [
	self inlineMessagesIn: firstBlock
]

{ #category : #private }
OptimizingMethodInliner >> inlineMethod: aMessageSend in: block [
	| method nativizer initialBlock |
	method := self inlinedMethodFor: aMessageSend.
	nativizer := OptimizingNativizer new.
	initialBlock := nativizer
		environment: environment;
		inlinedMethods: methods;
		method: method;
		decompose;
		firstBlock.
	self
		bindArgumentsOf: initialBlock with: aMessageSend;
		bindTemporariesOf: initialBlock activationRecord
		into: firstBlock activationRecord.
	^block inline: initialBlock replacing: aMessageSend
]

{ #category : #unclassified }
OptimizingMethodInliner >> methods: methodsToInline [
	methods := methodsToInline
]

{ #category : #unclassified }
OptimizingMethodInliner >> selectors [
	^methods collect: #selector
]

{ #category : #unclassified }
OptimizingMethodInliner >> shouldInline: instruction [
	^instruction isMessageSend
		and: [self selectors includes: instruction selector]
]

