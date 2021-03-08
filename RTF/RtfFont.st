"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfFont,
	#superclass : #Object,
	#instVars : [
		'charset'
	],
	#category : #RTF
}

{ #category : #'instance creation' }
RtfFont class >> new [
	^super new initialize]

{ #category : #accessing }
RtfFont >> charset [
	^charset]

{ #category : #accessing }
RtfFont >> charset: anInteger [
	charset := anInteger]

{ #category : #services }
RtfFont >> decode: aString [
	charset = 0 ifTrue: [^aString].
	aString isUnicode ifTrue: [^aString].
	^WideString fromMultiByte: aString asByteArray charset: charset]

{ #category : #initialization }
RtfFont >> initialize [
	super initialize.
	charset := 0]

