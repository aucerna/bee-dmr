"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OActivation,
	#superclass : #OProjection,
	#instVars : [
		'hasFrame',
		'temporaries',
		'storesPreviousSelf'
	],
	#category : #IR
}

{ #category : #inquiries }
OActivation >> arguments [
	| result |
	result := OrderedCollection new.
	self usesDo: [:use | | user |
		user := use user.
		(user isLoad and: [user index > 0]) ifTrue: [result add: user]].
	^result
]

{ #category : #accessing }
OActivation >> doSavePreviousSelf [
	storesPreviousSelf := true
]

{ #category : #accessing }
OActivation >> function [
	^input
]

{ #category : #testing }
OActivation >> hasFrame [
	^hasFrame or: [self function temporaries notEmpty]
]

{ #category : #accessing }
OActivation >> haveFrame [
	hasFrame := true
]

{ #category : #initialization }
OActivation >> initialize [
	hasFrame := false.
	storesPreviousSelf := false.
	name := #activation
]

{ #category : #testing }
OActivation >> isActivation [
	^true
]

{ #category : #inquiries }
OActivation >> nilUnitializedTemporaries [
	| uninitialized nilval |
	hasFrame ifFalse: [^nil].
	uninitialized := self uninitializedTemporariesIn: prev.
	uninitialized isEmpty ifTrue: [^nil].
	nilval := OMoveConstant valued: nil.
	next afterInsert: nilval.
	uninitialized do: [:index | | store |
		store := OStoreOperation base: self slotAtImm: index put: nilval.
		nilval afterInsert: store].
	^nilval
]

{ #category : #printing }
OActivation >> primitivePrintString [
	^'[activation]'
]

{ #category : #accessing }
OActivation >> receiver [
	self _ASSERT: (next isProjection and: [next name = #self]).
	^next
]

{ #category : #testing }
OActivation >> savesPreviousSelf [
	^storesPreviousSelf
]

{ #category : #accessing }
OActivation >> temporaries [
	^temporaries
]

{ #category : #accessing }
OActivation >> temporaries: aNumber [
	temporaries := aNumber.
	aNumber > 0 ifTrue: [self haveFrame]
]

{ #category : #inquiries }
OActivation >> uninitializedTemporariesIn: aBasicBlock [
	| uninitialized |
	uninitialized := Set new: temporaries.
	1 to: temporaries do: [:i | uninitialized add: -1 - i].
	aBasicBlock instructionsDo: [:inst | | base index |
		inst isMessageSend ifTrue: [^uninitialized].
		inst isStore ifTrue: [
			base := inst base.
			(base == self and: [
				index := inst index.
				index isInteger])
				ifTrue: [uninitialized remove: index ifAbsent: nil]]].
	^uninitialized
]

