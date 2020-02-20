Extension { #name : #SequenceableCollection }

{ #category : '*Extensions' }
SequenceableCollection >> asParser [
	^PPSequenceParser withAll: (self collect: [:e | e asParser])
]

{ #category : '*Extensions' }
SequenceableCollection >> asPetitStream [
	^ PPStream on: self
]

{ #category : '*Extensions' }
SequenceableCollection >> keysAndValuesDo: aBlock [
	1 to: self size do: [:i | aBlock value: i value: (self atValid: i)]
]

