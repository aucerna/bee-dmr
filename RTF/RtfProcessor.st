"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfProcessor,
	#superclass : #Object,
	#classVars : [
		'SpecialChars'
	],
	#category : #RTF
}

{ #category : #initialization }
RtfProcessor class >> initializeSpecialChars [
	"
	RtfTextExtractor initializeSpecialChars
	"
	SpecialChars := Dictionary new
		at: 'par' put: Cr asString;
		at: 'sect' put: Cr asString;
		at: 'page' put: Cr asString , Cr asString;
		at: 'line' put: Cr asString;
		at: 'tab' put: Tab asString;
		at: 'emdash' put: Emdash asString;
		at: 'endash' put: Endash asString;
		at: 'emspace' put: Emspace asString;
		at: 'enspace' put: Enspace asString;
		at: 'qmspace' put: Qmspace asString;
		at: 'bullet' put: Character bullet asString;
		at: 'lquote' put: Lquote asString;
		at: 'rquote' put: Rquote asString;
		at: 'ldblquote' put: Ldblquote asString;
		at: 'rdblquote' put: Rdblquote asString;
		yourself]

{ #category : #'instance creation' }
RtfProcessor class >> new [
	^super new initialize]

{ #category : #'event handling' }
RtfProcessor >> characters: aString [
	]

{ #category : #'event handling' }
RtfProcessor >> characters: aString from: start to: end [
	^self characters: aString]

{ #category : #'event handling' }
RtfProcessor >> controlWord: aString with: anInteger [
	]

{ #category : #'event handling' }
RtfProcessor >> controlWord: aString
with: anInteger
from: start
to: end [
	^self controlWord: aString with: anInteger]

{ #category : #'event handling' }
RtfProcessor >> endGroup [
	]

{ #category : #'event handling' }
RtfProcessor >> endGroupAt: position [
	self endGroup]

{ #category : #'event handling' }
RtfProcessor >> endIgnorable [
	]

{ #category : #initialization }
RtfProcessor >> initialize [
	super initialize.
	self reset]

{ #category : #'event handling' }
RtfProcessor >> lineDelimiters: aString [
	]

{ #category : #accessing }
RtfProcessor >> output [
	^nil]

{ #category : #parsing }
RtfProcessor >> parse: stringOrStream [
	^self reset; parse: stringOrStream withParser: RtfParser new; output]

{ #category : #private }
RtfProcessor >> parse: stringOrStream withParser: parser [
	parser processor: self; parse: stringOrStream]

{ #category : #initialization }
RtfProcessor >> reset [
	]

{ #category : #'event handling' }
RtfProcessor >> startGroup [
	]

{ #category : #'event handling' }
RtfProcessor >> startGroupAt: position [
	self startGroup]

{ #category : #'event handling' }
RtfProcessor >> startIgnorable [
	]

