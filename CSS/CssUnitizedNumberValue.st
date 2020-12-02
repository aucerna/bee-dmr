"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssUnitizedNumberValue,
	#superclass : #CssNumberValue,
	#instVars : [
		'units'
	],
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssUnitizedNumberValue class >> allowableUnits [
	^self new allowableUnits]

{ #category : #'as yet unclassified' }
CssUnitizedNumberValue class >> readFrom: aStream [
	| out |
	out := '' writeStream.
	aStream skipSeparators.
	('-+' includes: aStream peek) ifTrue: [out nextPut: aStream next].
	[aStream atEnd not and: [aStream peek isDigit]]
		whileTrue: [out nextPut: aStream next].
	aStream peek = $. ifTrue: [
		out size = 0 ifTrue: [out nextPut: $0].
		out nextPut: aStream next.
		[aStream atEnd not and: [aStream peek isDigit]]
			whileTrue: [out nextPut: aStream next]].
	[aStream atEnd
		or: [aStream peek isBlank or: [';/,' includes: aStream peek]]]
		whileFalse: [out nextPut: aStream next].
	^out contents size > 0 ifTrue: [self new string: out contents]]

{ #category : #accessing }
CssUnitizedNumberValue >> allowableUnits [
	self subclassResponsibility]

{ #category : #accessing }
CssUnitizedNumberValue >> string: aString [
	| s lc |
	s := aString trimBlanks.
	lc := s asLowercase.
	units := self allowableUnits detect: [:u | lc endsWith: u] ifNone: nil.
	s := units notNil ifTrue: [s truncateTo: s size - units size] ifFalse: [s].
	super string: s]

{ #category : #accessing }
CssUnitizedNumberValue >> units [
	^units]

{ #category : #accessing }
CssUnitizedNumberValue >> units: aString [
	units := aString]

