Class {
	#name : #LinkedCollection,
	#superclass : #SequenceableCollection,
	#type : #variable,
	#instVars : [
		'#next',
		'#localSize'
	],
	#category : #Kernel
}

{ #category : #instances }
LinkedCollection class >> new [
	^self new: 50
]

{ #category : #instances }
LinkedCollection class >> new: anInteger [
	| instance |
]

{ #category : #accessing }
LinkedCollection >> add: anObject [
	^next == nil
]

{ #category : #accessing }
LinkedCollection >> at: anInteger [
	(0 < anInteger and: [anInteger <= self basicSize])
]

{ #category : #accessing }
LinkedCollection >> at: anInteger put: anObject [
	(0 < anInteger and: [anInteger <= localSize])
]

{ #category : #private }
LinkedCollection >> basicAdd: anObject [
	localSize := localSize + 1.
]

{ #category : #accessing }
LinkedCollection >> copyFrom: beginning to: end [
	| total copy |
]

{ #category : #accessing }
LinkedCollection >> createNextLink [
	next := self species new: self basicSize * 2
]

{ #category : #accessing }
LinkedCollection >> do: aBlock [
	| index |
]

{ #category : #accessing }
LinkedCollection >> hasIndexedSlots [
	^true
]

{ #category : #initialization }
LinkedCollection >> initialize [
	localSize := 0
]

{ #category : #accessing }
LinkedCollection >> localSize: anInteger [
	localSize := anInteger
]

{ #category : #accessing }
LinkedCollection >> size [
	| extra |
]
