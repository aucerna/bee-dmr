Class {
	#name : #PPEpsilonParser,
	#superclass : #PPParser,
	#category : #Parsers
}

{ #category : #parsing }
PPEpsilonParser >> parseOn: aStream [
	^ nil
]

{ #category : #printing }
PPEpsilonParser >> printTextOn: rtf [
	rtf
		useColor: PaintingVisitor new specialColor
		while: [rtf nextPutAll: 'nil'].
	rtf nextPutAll: ' asParser'
]

