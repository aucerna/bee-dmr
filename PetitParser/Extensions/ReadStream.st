Extension { #name : #ReadStream }

{ #category : '*Extensions' }
ReadStream >> asPetitStream [
	^self collection asPetitStream
]

