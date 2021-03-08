"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfStringProcessor,
	#superclass : #RtfProcessor,
	#instVars : [
		'eol'
	],
	#category : #RTF
}

{ #category : #'event handling' }
RtfStringProcessor >> controlWord: aString
with: argument
from: start
to: end [
	(#('par' 'sect' 'line') includes: aString)
		ifTrue: [^self characters: eol from: start to: end].
	aString = 'page' ifTrue: [^self characters: eol , eol from: start to: end].
	SpecialChars
		at: aString
		ifPresent: [:replacement | self
			characters: replacement
			from: start
			to: end]]

{ #category : #'event handling' }
RtfStringProcessor >> lineDelimiters: aString [
	eol := aString]

{ #category : #private }
RtfStringProcessor >> parse: stringOrStream withParser: parser [
	parser lineDelimiters: eol.
	^super parse: stringOrStream withParser: parser]

