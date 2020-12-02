"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssEnumeratedValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssEnumeratedValue class >> readFrom: aStream [
	| set out |
	set := self separators , $;.
	out := '' writeStream.
	[set includes: aStream peek] whileTrue: [out nextPut: aStream next].
	^self new string: out contents]

