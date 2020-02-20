Class {
	#name : #HashedCollection,
	#superclass : #Collection,
	#instVars : [
		'#tally',
		'#table'
	],
	#classVars : [
		'#Policies'
	],
	#category : #Kernel
}

{ #category : #private }
HashedCollection class >> initializePolicies [
	Policies := WeakIdentityDictionary new
]

{ #category : #'instance creation' }
HashedCollection class >> new [
	^self new: 5
]

{ #category : #'instance creation' }
HashedCollection class >> new: anInteger [
	| size |
]

{ #category : #'instance creation' }
HashedCollection class >> new: anInteger using: aHashedCollectionPolicy [
	| size |
]

{ #category : #'instance creation' }
HashedCollection class >> on: aHashTable [
	^self new onTable: aHashTable
]

{ #category : #private }
HashedCollection class >> registerPolicy: aHashTablePolicy for: aHashedCollection [
	Policies at: aHashedCollection put: aHashTablePolicy
]

{ #category : #private }
HashedCollection class >> sizeFor: anInteger [
	^7 max: anInteger * 3 // 2
]

{ #category : #'instance creation' }
HashedCollection class >> withAll: aCollection [
	| instance |
]

{ #category : #adding }
HashedCollection >> add: element [
	(table atKey: element put: element) == nil ifTrue: [self incrementTally].
]

{ #category : #accessing }
HashedCollection >> at: anInteger [
	^self errorNotIndexable
]

{ #category : #accessing }
HashedCollection >> at: anInteger put: anObject [
	^self errorNotIndexable
]

{ #category : #private }
HashedCollection >> basicAdd: element [
	tally := tally + 1.
]

{ #category : #enumerating }
HashedCollection >> basicDo: aBlock [
	table elementsDo: aBlock count: tally
]

{ #category : #services }
HashedCollection >> beWeak [
	| policy |
]

{ #category : #accessing }
HashedCollection >> bucketClass [
	^OpenHashTable
]

{ #category : #private }
HashedCollection >> bucketOfSize: anInteger [
	^(self bucketClass new: anInteger) owner: self
]

{ #category : #private }
HashedCollection >> contentOfSize: anInteger [
	^self policy == self
]

{ #category : #private }
HashedCollection >> contents [
	^table
]

{ #category : #copying }
HashedCollection >> copy [
	| copy |
]

{ #category : #private }
HashedCollection >> defaultPolicy [
	^HashTablePolicy new
]

{ #category : #enumerating }
HashedCollection >> do: aBlock [
	self basicDo: aBlock
]

{ #category : #private }
HashedCollection >> emptySlot [
	^nil
]

{ #category : #private }
HashedCollection >> equates: key with: element [
	^key = element
]

{ #category : #private }
HashedCollection >> grow [
	self resizeTo: tally * 2
]

{ #category : #private }
HashedCollection >> hashFor: anObject [
	^anObject hash
]

{ #category : #private }
HashedCollection >> incrementTally [
	tally := tally + 1.
]

{ #category : #initialization }
HashedCollection >> initialize: anInteger [
	| t |
]

{ #category : #initialization }
HashedCollection >> initializeWeakSize: anInteger [
	self initialize: anInteger.
]

{ #category : #accessing }
HashedCollection >> keyFor: anObject [
	^anObject
]

{ #category : #private }
HashedCollection >> maxSlots [
	^self policy == self ifFalse: [self policy maxSlots]
]

{ #category : #services }
HashedCollection >> maxSlots: anInteger [
	| policy |
]

{ #category : #inquiries }
HashedCollection >> occurrencesOf: anObject [
	^(self includes: anObject) ifTrue: [1] ifFalse: [0]
]

{ #category : #initialization }
HashedCollection >> onTable: aHashTable [
	tally := 0.
]

{ #category : #accessing }
HashedCollection >> policy [
	^table notNil ifTrue: [table policy] ifFalse: [self]
]

{ #category : #copying }
HashedCollection >> postCopy [
	super postCopy.
]

{ #category : #services }
HashedCollection >> rehash [
	tally isNil ifTrue: [tally := table count].
]

{ #category : #removing }
HashedCollection >> remove: anObject ifAbsent: aBlock [
	table removeKey: anObject ifAbsent: [^aBlock value].
]

{ #category : #removing }
HashedCollection >> removeAll [
	tally = 0 ifTrue: [^self].
]

{ #category : #removing }
HashedCollection >> removeAll: aCollection [
	^self removeAll: aCollection ifAbsent: [self errorNotFound]
]

{ #category : #removing }
HashedCollection >> removeAll: aCollection ifAbsent: aBlock [
	| n |
]

{ #category : #private }
HashedCollection >> resizeTo: anInteger [
	| copy t policy n |
]

{ #category : #accessing }
HashedCollection >> size [
	^tally
]

{ #category : #testing }
HashedCollection >> storesAssociations [
	^false
]

{ #category : #private }
HashedCollection >> table [
	^table
]

{ #category : #services }
HashedCollection >> useDefaultPolicy [
	table policy == self ifTrue: [^self].
]

{ #category : #services }
HashedCollection >> useIdentityHash [
	| policy |
]

{ #category : #services }
HashedCollection >> usePolicy: aHashTablePolicy [
	table isNil ifTrue: [^self].
]

{ #category : #testing }
HashedCollection >> usesWeakSlots [
	| p |
]
