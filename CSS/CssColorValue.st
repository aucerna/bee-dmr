"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssColorValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssColorValue class >> readFrom: aStream [
	| out |
	out := '' writeStream.
	aStream skipSeparators.
	aStream peek = $#
		ifFalse: [
			[aStream atEnd not and: [aStream peek isLetter]]
				whileTrue: [out nextPut: aStream next]]
		ifTrue: [
			out nextPut: aStream next.
			[aStream atEnd not and: [aStream peek isAlphanumeric]]
				whileTrue: [out nextPut: aStream next]].
	^self new string: out contents]

{ #category : #testing }
CssColorValue >> isHexColor [
	(string beginsWith: '#') ifFalse: [^false].
	(string size = 7 or: [string size = 4]) ifFalse: [^false].
	^string allButFirst asLowercase
		conform: [:ch | '0123456789abcdef' includes: ch]]

{ #category : #testing }
CssColorValue >> isNamedColor [
	^#('black' 
		'silver' 
		'gray' 
		'white' 
		'maroon' 
		'red' 
		'purple' 
		'fuchsia' 
		'green' 
		'lime' 
		'olive' 
		'yellow' 
		'navy' 
		'blue' 
		'teal' 
		'aqua') includes: string asLowercase]

{ #category : #testing }
CssColorValue >> isRgbColor [
	| s rgb |
	s := string asLowercase.
	(s beginsWith: 'rgb(') ifFalse: [^false].
	(s endsWith: ')') ifFalse: [^false].
	rgb := (s substringsDelimitedBy: '(), ') allButFirst.
	rgb size = 3 ifFalse: [^false].
	^(rgb first endsWith: '%')
		ifTrue: [
			rgb
				conform: [:p | (p endsWith: '%')
					and: [p allButLast asNumber between: 0 and: 100]]]
		ifFalse: [rgb conform: [:n | n asNumber between: 0 and: 255]]]

{ #category : #testing }
CssColorValue >> isValid [
	self isNamedColor ifTrue: [^true].
	self isRgbColor ifTrue: [^true].
	self isHexColor ifTrue: [^true].
	^false]

