"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #String }

{ #category : '*FML' }
String >> indexOfClosingParensAt: position [
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
	^0]

{ #category : '*FML' }
String >> normalized [
	^self species withAll: self collect: [:each | each normalized]]

