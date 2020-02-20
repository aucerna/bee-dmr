Class {
	#name : #WeakIdentityDictionary,
	#superclass : #Dictionary,
	#instVars : [
		'#critical'
	],
	#category : #Kernel
}

{ #category : #adding }
WeakIdentityDictionary >> add: anAssociation [
	self ASSERT: anAssociation class == Ephemeron.
]

{ #category : #private }
WeakIdentityDictionary >> associationClass [
	^Ephemeron new registry: self
]

{ #category : #enumerating }
WeakIdentityDictionary >> associationsDo: aBlock [
	self critical: [
]

{ #category : #private }
WeakIdentityDictionary >> critical: aBlock [
	| save |
]

{ #category : #enumerating }
WeakIdentityDictionary >> do: aBlock [
	self associationsDo: [:assoc | aBlock evaluateWith: assoc value]
]

{ #category : #enumerating }
WeakIdentityDictionary >> ephemeronsDo: aBlock [
	self associationsDo: aBlock
]

{ #category : #private }
WeakIdentityDictionary >> equates: element with: ephemeron [
	^element == ephemeron key
]

{ #category : #private }
WeakIdentityDictionary >> hashFor: element [
	^element basicHash
]

{ #category : #private }
WeakIdentityDictionary >> keyCollector [
	^IdentitySet new: self size
]

{ #category : #initialization }
WeakIdentityDictionary >> onTable: aHashTable [
	critical := false.
]

{ #category : #private }
WeakIdentityDictionary >> rescue: anEphemeron [
	critical
]
