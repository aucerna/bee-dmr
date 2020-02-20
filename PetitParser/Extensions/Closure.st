Extension { #name : #Closure }

{ #category : '*Extensions' }
Closure >> asParser [
	^PPPluggableParser on: self
]

