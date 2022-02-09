"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OActivationContext,
	#superclass : #OLoadImplicit,
	#instVars : [
		'hasFrame',
		'temporaries',
		'storesPreviousSelf',
		'argumentCount'
	],
	#category : #IR
}

{ #category : #'instance creation' }
OActivationContext class >> new [
	^self basicNew initialize
]

{ #category : #accessing }
OActivationContext >> argumentAt: anInteger [
	| inst |
	inst := self receiver.
	anInteger timesRepeat: [inst := inst next].
	^inst
]

{ #category : #accessing }
OActivationContext >> argumentCount: anInteger [
	argumentCount := anInteger
]

{ #category : #accessing }
OActivationContext >> arguments [
	| inst result |
	inst := self receiver.
	result := OrderedCollection new.
	argumentCount timesRepeat: [
		inst := inst next.
		result add: inst].
	^result
]

{ #category : #accessing }
OActivationContext >> doSavePreviousSelf [
	storesPreviousSelf := true
]

{ #category : #accessing }
OActivationContext >> hasFrame [
	^hasFrame
]

{ #category : #accessing }
OActivationContext >> haveFrame [
	hasFrame := true
]

{ #category : #accessing }
OActivationContext >> initialize [
	hasFrame := false.
	storesPreviousSelf := false
]

{ #category : #accessing }
OActivationContext >> receiver [
	self _ASSERT: (next isLoadImplicit and: [next name = #self]).
	^next
]

{ #category : #accessing }
OActivationContext >> savesPreviousSelf [
	^storesPreviousSelf
]

{ #category : #accessing }
OActivationContext >> temporaries [
	^temporaries
]

{ #category : #accessing }
OActivationContext >> temporaries: aNumber [
	temporaries := aNumber.
	aNumber > 0 ifTrue: [self haveFrame]
]

