Class {
	#name : #PPNotParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #parsing }
PPNotParser >> parseOn: aStream [
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^element isPetitFailure ifFalse: [PPFailure message: '' from: aStream]
]

{ #category : #printing }
PPNotParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' not'
]

