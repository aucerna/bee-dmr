"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfParserState,
	#superclass : #Object,
	#instVars : [
		'ignorable',
		'uskip',
		'font',
		'processor'
	],
	#classVars : [
		'SpecialChars'
	],
	#category : #RTF
}

{ #category : #'instance creation' }
RtfParserState class >> new [
	^super new initialize]

{ #category : #accessing }
RtfParserState >> font [
	^font]

{ #category : #accessing }
RtfParserState >> font: anRtfFont [
	font := anRtfFont]

{ #category : #accessing }
RtfParserState >> ignorable [
	^ignorable]

{ #category : #accessing }
RtfParserState >> ignorable: aBoolean [
	ignorable := aBoolean]

{ #category : #initialization }
RtfParserState >> initialize [
	super initialize.
	ignorable := false.
	uskip := 1]

{ #category : #accessing }
RtfParserState >> processor [
	^processor]

{ #category : #accessing }
RtfParserState >> processor: aRtfProcessor [
	processor := aRtfProcessor]

{ #category : #accessing }
RtfParserState >> uskip [
	^uskip]

{ #category : #accessing }
RtfParserState >> uskip: anInteger [
	uskip := anInteger]

