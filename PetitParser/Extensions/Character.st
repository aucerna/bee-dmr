Extension { #name : #Character }

{ #category : '*Extensions' }
Character class >> codePoint: anInteger [
	"
	Just for ANSI Compliance
	"
	^self value: anInteger
]

{ #category : '*Extensions' }
Character >> asParser [
	^ PPLiteralObjectParser on: self
]

{ #category : '*Extensions' }
Character >> parserTo: aCharacter [
	^PPPredicateObjectParser between: self and: aCharacter
]

{ #category : '*Extensions' }
Character >> sameAs: aCharacter [
	^self asLowercase = aCharacter asLowercase
]

