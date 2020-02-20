Class {
	#name : #PPWrappingParser,
	#superclass : #PPActionParser,
	#category : #Parsers
}

{ #category : #parsing }
PPWrappingParser >> parseOn: aStream [
	^ block value: aStream value: [ parser parseOn: aStream ]
]

{ #category : #printing }
PPWrappingParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf
		useColor: PaintingVisitor new defaultColor
		while: [rtf nextPutAll: ' >=> '].
	block printTextOn: rtf
]

