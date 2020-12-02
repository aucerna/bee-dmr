"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssNumberValue,
	#superclass : #CssIntegerValue,
	#category : #CSS
}

{ #category : #'instance creation' }
CssNumberValue class >> readFrom: aStream [
	| out |
	out := '' writeStream.
	('-+' includes: aStream peek) ifTrue: [out nextPut: aStream next].
	[aStream atEnd not and: [aStream peek isDigit]]
		whileTrue: [out nextPut: aStream next].
	aStream peek = $. ifTrue: [
		out size = 0 ifTrue: [out nextPut: $0].
		out nextPut: aStream next.
		[aStream atEnd not and: [aStream peek isDigit]]
			whileTrue: [out nextPut: aStream next]].
	^(aStream peek isNil or: [self separators , ';, /' includes: aStream peek])
		ifTrue: [self new string: out contents]]

{ #category : #testing }
CssNumberValue >> isValid [
	^([string asNumber] on: Exception do: [:ex | ex return: nil]) notNil]

