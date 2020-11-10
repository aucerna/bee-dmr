"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : '*FML' }
CharacterArray class >> fmlValueClass [
	^FmlString
]

{ #category : '*FML' }
CharacterArray >> asFmlExpression [
	^FmlParser parseNormalized: self
]

{ #category : '*FML' }
CharacterArray >> asFmlString [
	^self storeString
]

{ #category : '*FML' }
CharacterArray >> asFmlValue [
	^FmlString with: self
]

{ #category : '*FML' }
CharacterArray >> indexOfClosingParensAt: position [
	"
	'(1 + (2 * 3))' indexOfClosingParensAt: 6
	"
	| index count char |
	self isEmpty ifTrue: [^0].
	(self at: position) = $( ifFalse: [^0].
	index := position + 1.
	count := 1.
	[index <= self size] whileTrue: [
		char := self at: index.
		char = $( ifTrue: [count := count + 1].
		char = $) ifTrue: [count := count - 1].
		count = 0 ifTrue: [^index].
		index := index + 1].
	^0
]

{ #category : '*FML' }
CharacterArray >> isNumeric [
	^false]

{ #category : '*FML' }
CharacterArray >> isSummable [
	^false]

{ #category : '*FML' }
CharacterArray >> resultType [
	^FmlString
]

{ #category : '*FML' }
CharacterArray >> trimOutermostParens [
	"
	'((1 + 2) * 3)' trimOutermostParens
	'(((1 + 2) * 3))' trimOutermostParens
	"
	| string |
	string := self trimBlanks.
	string isEmpty ifTrue: [^string].
	^(string indexOfClosingParensAt: 1) = string size
		ifTrue: [(string copyFrom: 2 to: string size - 1) trimBlanks trimOutermostParens]
		ifFalse: [string]
]

{ #category : '*FML' }
CharacterArray >> valueAt: index [
	^self
]

{ #category : '*FML' }
CharacterArray >> variableName [
	^FmlVariableName fromString: self
]

{ #category : '*FML' }
CharacterArray >> without: aCharacterCollection [
	^self reject: [:ch | aCharacterCollection includes: ch]
]

{ #category : '*FML' }
CharacterArray >> zapLfs [
	^self reject: [:c | c = Lf]
]

