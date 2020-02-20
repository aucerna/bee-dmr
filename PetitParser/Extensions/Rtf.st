Extension { #name : #Rtf }

{ #category : '*Extensions' }
Rtf >> asParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : '*Extensions' }
Rtf >> asPetitStream [
	^ self asString asPetitStream
]

