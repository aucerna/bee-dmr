Class {
	#name : #PPLiteralObjectParser,
	#superclass : #PPLiteralParser,
	#category : #Parsers
}

{ #category : #operators }
PPLiteralObjectParser >> caseInsensitive [
	"Answer a parser that can parse the receiver case-insensitive."

	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateObjectParser on: [ :value | literal sameAs: value ] message: message
]

{ #category : #parsing }
PPLiteralObjectParser >> parseOn: aStream [
	^(aStream atEnd not and: [aStream uncheckedPeek = literal])
		ifFalse: [PPFailure message: message from: aStream]
		ifTrue: [aStream next]
]

