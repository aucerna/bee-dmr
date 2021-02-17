"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WCRANGE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
WCRANGE class >> def [
	^<def>
	typedef struct tagWCRANGE {
		WCHAR  wcLow;
		USHORT cGlyphs;
	} WCRANGE, *PWCRANGE;
	</def>]

{ #category : #accessing }
WCRANGE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
WCRANGE >> asInterval [
	^self wcLow to: self wcLow + self cGlyphs - 1]

{ #category : #accessing }
WCRANGE >> cGlyphs [
	^self uShortAtOffset: cGlyphs]

{ #category : #testing }
WCRANGE >> includes: anInteger [
	| low |
	low := self wcLow.
	^anInteger asInteger between: low and: low + self cGlyphs - 1]

{ #category : #accessing }
WCRANGE >> wcLow [
	^self uShortAtOffset: wcLow]

