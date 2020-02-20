Class {
	#name : #PPChoiceParser,
	#superclass : #PPListParser,
	#category : #Parsers
}

{ #category : #operations }
PPChoiceParser >> / aRule [
	^ self copyWith: aRule
]

{ #category : #parsing }
PPChoiceParser >> parseOn: aStream [
	| element |
	1 to: parsers size do: [:index | 
		element := (parsers at: index) parseOn: aStream.
		element isPetitFailure ifFalse: [^element]].
	^element
]

{ #category : #printing }
PPChoiceParser >> printTextOn: rtf [
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' / ']
]

