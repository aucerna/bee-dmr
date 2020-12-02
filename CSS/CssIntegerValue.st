"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssIntegerValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssIntegerValue class >> readFrom: aStream [
	| out |
	out := '' writeStream.
	('-+' includes: aStream peek) ifTrue: [out nextPut: aStream next].
	[aStream atEnd not and: [aStream peek isDigit]]
		whileTrue: [out nextPut: aStream next].
	^self new string: out contents]

{ #category : #testing }
CssIntegerValue >> isValid [
	| digits |
	digits := ('+-' includes: string first)
		ifTrue: [string allButFirst]
		ifFalse: [string].
	^digits conform: [:ch | ch isDigit]]

{ #category : #accessing }
CssIntegerValue >> value [
	^self isValid ifTrue: [string asNumber]]

