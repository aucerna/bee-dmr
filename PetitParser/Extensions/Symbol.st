Extension { #name : #Symbol }

{ #category : '*Extensions' }
Symbol >> value: anObject [
	^anObject perform: self
]

