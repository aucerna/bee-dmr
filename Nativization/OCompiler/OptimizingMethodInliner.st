"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OptimizingMethodInliner,
	#superclass : #Object,
	#instVars : [
		'method',
		'methods',
		'changed',
		'maxSize'
	],
	#category : #OCompiler
}

{ #category : #'instance creation' }
OptimizingMethodInliner class >> new [
	^super new initialize
]

{ #category : #private }
OptimizingMethodInliner >> blockInliner [
	^OptimizingBlockInliner new inlinerFunction: method
]

{ #category : #private }
OptimizingMethodInliner >> booleanInliner: aMessageSend [
	| types selector receiver |
	selector := aMessageSend selector.
	receiver := aMessageSend receiver.
	types := {true. false} collect: [:bool | | method probability |
		probability := 0.5.
		method := bool behavior findMethodFor: selector.
		OTypeCase new
			token: bool;
			method: method;
			probability: probability].
	^self newDispatcher types: types
]

{ #category : #initialization }
OptimizingMethodInliner >> initialize [
	methods := Dictionary new
]

{ #category : #services }
OptimizingMethodInliner >> inlineAllMessages [
	[
		changed := false.
		method start withSuccessorsPostOrder do: [:block | | current |
			current := block.
			block instructionsAsCollection do: [:instruction | 
				instruction isMessageSend
					ifTrue: [current := (self tryOptimizingSend: instruction in: current) value]]].
		changed] whileTrue
]

{ #category : #testing }
OptimizingMethodInliner >> isBooleanMessage: selector [
	^#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue: #and: #or:)
		includes: selector
]

{ #category : #logging }
OptimizingMethodInliner >> log: aString [
	LogCompilation ifTrue: [aString print]
]

{ #category : #services }
OptimizingMethodInliner >> lookup: aMessageSend [
	| receiver selector |
	self
		log: 'analyzing receiver types in: ' , aMessageSend basicPrintString
			, ' within: '
			, method baseMethod printString
			, ' block probability: '
			, aMessageSend basicBlock probability printString.
	aMessageSend isSuperSend
		ifTrue: [^self newDispatcher staticDispatch: aMessageSend method].
	receiver := aMessageSend receiver.
	selector := aMessageSend selector.
	receiver isBlockClosure ifTrue: [^self blockInliner].
	receiver isConstant ifTrue: [^self lookup: selector for: receiver value].
	(self isBooleanMessage: selector)
		ifTrue: [^self booleanInliner: aMessageSend].
	(self methodForSelector: selector)
		ifNotNil: [:m | ^self newDispatcher staticDispatch: m].
	^nil
]

{ #category : #services }
OptimizingMethodInliner >> lookup: selector for: constant [
	| behavior method |
	behavior := constant behavior.
	method := behavior findMethodFor: selector.
	(method isNil or: [method primitiveNumber > 0]) ifTrue: [^nil].
	^self newDispatcher staticDispatch: method
]

{ #category : #accessing }
OptimizingMethodInliner >> method: anOMethod [
	method := anOMethod.
	maxSize := method size * method inlineFactor
]

{ #category : #private }
OptimizingMethodInliner >> methodForSelector: selector [
	^methods at: selector ifAbsent: nil
]

{ #category : #accessing }
OptimizingMethodInliner >> methods: inlinedMethods [
	inlinedMethods do: [:m | methods at: m selector put: m]
]

{ #category : #private }
OptimizingMethodInliner >> newDispatcher [
	^ODispatchInliner new inlinerMethod: method; maxSize: maxSize
]

{ #category : #private }
OptimizingMethodInliner >> tryOptimizingSend: aMessageSend in: aBasicBlock [
	| inliner result |
	aMessageSend linker ifNotNil: [^aMessageSend -> aBasicBlock].
	aBasicBlock probability < 0.1 ifTrue: [
		aMessageSend linker: method messageLinker.
		^aMessageSend -> aBasicBlock].
	inliner := self lookup: aMessageSend.
	inliner isNil ifTrue: [
		aMessageSend linker: method messageLinker.
		^aMessageSend -> aBasicBlock].
	changed := true.
	result := inliner inline: aMessageSend in: aBasicBlock.
	method validate.
	^result
]

