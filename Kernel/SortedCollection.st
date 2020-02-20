Class {
	#name : #SortedCollection,
	#superclass : #OrderedCollection,
	#instVars : [
		'#sortBlock'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
SortedCollection class >> sortBlock: aBlock [
	| instance |
]

{ #category : #'instance creation' }
SortedCollection class >> withAll: aCollection sortingBy: aBlock [
	| collection |
]

{ #category : #adding }
SortedCollection >> add: anObject [
	| idx |
]

{ #category : #adding }
SortedCollection >> addAll: aCollection [
	aCollection size > (self size // 3)
]

{ #category : #converting }
SortedCollection >> asOrderedCollection [
	^OrderedCollection withAll: self
]

{ #category : #converting }
SortedCollection >> asSortedCollection [
	^self
]

{ #category : #accessing }
SortedCollection >> at: anInteger put: anObject [
	^self shouldNotImplement
]

{ #category : #private }
SortedCollection >> blockForCopy: copy [
	(sortBlock isMessage and: [sortBlock receiver == self])
]

{ #category : #copying }
SortedCollection >> copyFrom: startIndex to: endIndex [
	| copy block |
]

{ #category : #copying }
SortedCollection >> deepCopy [
	| copy block |
]

{ #category : #adding }
SortedCollection >> indexFor: newObject [
	| index low high sorter |
]

{ #category : #private }
SortedCollection >> reSort [
	self sort: start to: end
]

{ #category : #enumerating }
SortedCollection >> select: aBlock [
	| collection block |
]

{ #category : #enumerating }
SortedCollection >> select: n satisfying: aBlock [
	| collection block |
]

{ #category : #sorting }
SortedCollection >> sort: left to: right [
	| i j sorter |
]

{ #category : #private }
SortedCollection >> sortBlock [
	^sortBlock
]

{ #category : #accessing }
SortedCollection >> sortBlock: aBlock [
	sortBlock := aBlock.
]

{ #category : #accessing }
SortedCollection >> sortBy: criteria [
	sortBlock := criteria.
]

{ #category : #private }
SortedCollection >> value: object1 value: object2 [
	^object1 <= object2
]

{ #category : #enumerating }
SortedCollection >> withIndexCollect: aBlock [
	^self withIndexCollect: aBlock in: (OrderedCollection new: self size)
]
