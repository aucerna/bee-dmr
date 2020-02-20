Class {
	#name : #WeakIdentitySet,
	#superclass : #IdentitySet,
	#instVars : [
		'#finalizer'
	],
	#category : #Kernel
}

{ #category : #adding }
WeakIdentitySet >> add: element [
	| ephemeron |
]

{ #category : #private }
WeakIdentitySet >> basicAdd: element [
	element isNil ifTrue: [^self].
]

{ #category : #enumerating }
WeakIdentitySet >> do: aBlock [
	[super do: [:e | aBlock value: e key]] evaluateAtomically
]

{ #category : #enumerating }
WeakIdentitySet >> ephemeronsDo: aBlock [
	super do: [:e | aBlock value: e]
]

{ #category : #private }
WeakIdentitySet >> equates: key with: element [
	^key == element key
]

{ #category : #accessing }
WeakIdentitySet >> finalizer: evaluableAction [
	finalizer := evaluableAction
]

{ #category : #private }
WeakIdentitySet >> hashFor: object [
	^object basicHash
]

{ #category : #private }
WeakIdentitySet >> keyFor: anObject [
	^anObject key
]

{ #category : #removing }
WeakIdentitySet >> remove: anObject ifAbsent: aBlock [
	^[super remove: anObject ifAbsent: aBlock] evaluateAtomically
]

{ #category : #private }
WeakIdentitySet >> rescue: anEphemeron [
	self remove: anEphemeron key ifAbsent: nil.
]

{ #category : #testing }
WeakIdentitySet >> storesAssociations [
	^true
]
