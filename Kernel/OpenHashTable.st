Class {
	#name : #OpenHashTable,
	#superclass : #HashTable,
	#type : #variable,
	#category : #Kernel
}

{ #category : #accessing }
OpenHashTable >> at: index key: key put: element [
	| object |
]

{ #category : #accessing }
OpenHashTable >> atKey: key hash: hash sum: magnitude [
	| index object assoc sum |
]

{ #category : #private }
OpenHashTable >> basicAtKey: key put: element [
	| index |
]

{ #category : #private }
OpenHashTable >> copyAssociations [
	self
]

{ #category : #private }
OpenHashTable >> copyFromBucket: bucket [
	| count |
]

{ #category : #accessing }
OpenHashTable >> count [
	^self count: [:n | n notNil]
]

{ #category : #enumerating }
OpenHashTable >> elementsDo: aBlock count: n [
	| i empty |
]

{ #category : #private }
OpenHashTable >> indexOfHash: integer [
	^integer \\ self size + 1
]

{ #category : #testing }
OpenHashTable >> isCapacityGreaterThan: count [
	^self size * 75 > (count * 100)
]

{ #category : #enumerating }
OpenHashTable >> keysAndValuesDo: aBlock [
	self
]

{ #category : #private }
OpenHashTable >> lookupValue: key [
	^self lookupValue: key ifAbsent: [self keyNotFound: key]
]

{ #category : #private }
OpenHashTable >> lookupValue: key ifAbsent: aBlock [
	| assoc |
]

{ #category : #removing }
OpenHashTable >> moveSlot: anInteger to: targetInteger [
	| a |
]
