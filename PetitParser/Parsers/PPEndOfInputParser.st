Class {
	#name : #PPEndOfInputParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #operations }
PPEndOfInputParser >> end [
	^ self
]

{ #category : #parsing }
PPEndOfInputParser >> parseOn: aStream [
	| position result |
	position := aStream position.
	result := parser parseOn: aStream.
	(result isPetitFailure or: [aStream atEnd]) ifTrue: [^result].
	result := PPFailure message: 'end of input expected' from: aStream.
	aStream position: position.
	^aStream failure
]

