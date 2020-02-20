Class {
	#name : #PPOptionalParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #parsing }
PPOptionalParser >> parseOn: aStream [
	| element |
	element := parser parseOn: aStream.
	^ element isPetitFailure ifFalse: [ ^ element ]
]

{ #category : #printing }
PPOptionalParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' optional'
]

