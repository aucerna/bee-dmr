Extension { #name : #Object }

{ #category : '*Extensions' }
Object >> asParser [
	^ PPPredicateObjectParser expect: self
]

{ #category : '*Extensions' }
Object >> isPetitFailure [
	^ false
]

{ #category : '*Extensions' }
Object >> isPetitParser [
	^ false
]

