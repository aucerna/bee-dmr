Extension { #name : #CharacterArray }

{ #category : '*Extensions' }
CharacterArray >> copyReplaceAll: aString with: anotherString [
	^self replaceAll: aString with: anotherString

]

{ #category : '*Extensions' }
CharacterArray >> sameAs: aString [
	^self equalsCaseInsensitive: aString
]

