"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Callback,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'selector'
	],
	#classVars : [
		'Instances'
	],
	#category : #Kernel
}

{ #category : #private }
Callback class >> fromId: anInteger [
	^anInteger _asPointer _asObject
]

{ #category : #testing }
Callback class >> isCallback: anObject at: address [
	(anObject isKindOf: Callback) ifTrue: [^anObject asParameter = address].
	^false
]

{ #category : #'instance creation' }
Callback class >> onBlock: aClosure [
	^self callbackOn: aClosure
]

{ #category : #accessing }
Callback class >> receiver: anObject selector: aSymbol [
	^self new receiver: anObject; selector: aSymbol; bind
]

{ #category : #initialization }
Callback class >> startUp [
	Instances ifNil: [Instances := IdentitySet new]
]

{ #category : #accessing }
Callback >> argumentCount [
	^selector arity
]

{ #category : #accessing }
Callback >> argumentsAt: argsAddress [
	| arguments offset |
	arguments := argsAddress pointedMemory.
	offset := self argumentsStartOffset.
	^(1 to: selector arity) collect: [:i | 
		offset := offset + WordSize.
		arguments pointerAtOffset: offset]
]

{ #category : #accessing }
Callback >> argumentsStartOffset [
	^WordSize negated
]

{ #category : #private }
Callback >> asParameter [
	^self subclassResponsibility
]

{ #category : #initialization }
Callback >> bind [
	Instances add: self
]

{ #category : #initialization }
Callback >> bindAsync: aNativeCode [
	| pinned offset |
	pinned := Smalltalk memory pinnedCopy: aNativeCode code.
	offset := aNativeCode first.
	pinned pointerAtOffset: offset put: self _oop.
	^NativeCode new code: pinned
]

{ #category : #initialization }
Callback >> curtailValue [
	^nil
]

{ #category : #initialization }
Callback >> externalAddress [
	^self asParameter
]

{ #category : #initialization }
Callback >> free [
	^self release
]

{ #category : #initialization }
Callback >> id [
	^self _oop
]

{ #category : #initialization }
Callback >> performWithArgs: address [
	| args |
	args := self argumentsAt: address.
	^receiver perform: selector withArguments: args
]

{ #category : #accessing }
Callback >> receiver: anObject [
	receiver := anObject
]

{ #category : #finalization }
Callback >> release [
	Instances remove: self ifAbsent: nil
]

{ #category : #accessing }
Callback >> selector: aSymbol [
	selector := aSymbol
]

