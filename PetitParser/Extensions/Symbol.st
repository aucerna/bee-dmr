Extension { #name : #Symbol }

{ #category : '*Extensions' }
Symbol >> asParser [
	^ PPPredicateObjectParser perform: self
]

{ #category : '*Extensions' }
Symbol >> value: anObject [
	^anObject perform: self
]

