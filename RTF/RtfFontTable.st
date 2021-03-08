"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfFontTable,
	#superclass : #RtfProcessor,
	#instVars : [
		'fonts',
		'font',
		'processor'
	],
	#category : #RTF
}

{ #category : #'event handling' }
RtfFontTable >> characters: aString [
	processor characters: aString]

{ #category : #'event handling' }
RtfFontTable >> controlWord: aString with: anInteger [
	| n |
	aString = 'f' ifTrue: [
		font := RtfFont new.
		n := anInteger + 1 - fonts size.
		n > 0 ifTrue: [
			n timesRepeat: [fonts add: nil].
			fonts at: anInteger + 1 put: font]].
	aString = 'fcharset' ifTrue: [font charset: anInteger].
	processor controlWord: aString with: anInteger]

{ #category : #'event handling' }
RtfFontTable >> endGroup [
	processor endGroup]

{ #category : #'event handling' }
RtfFontTable >> endIgnorable [
	processor endIgnorable]

{ #category : #accessing }
RtfFontTable >> fontTable: anCollection [
	fonts := anCollection]

{ #category : #accessing }
RtfFontTable >> processor [
	^processor]

{ #category : #accessing }
RtfFontTable >> processor: anRtfProcessor [
	processor := anRtfProcessor]

{ #category : #'event handling' }
RtfFontTable >> startGroup [
	processor startGroup]

{ #category : #'event handling' }
RtfFontTable >> startIgnorable [
	processor startIgnorable]

