"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlCache,
	#superclass : #Object,
	#instVars : [
		'documents',
		'baseUrl'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlCache class >> new [
	^super new initialize]

{ #category : #services }
HtmlCache >> contentsFromUrl: anURL [
	^(self documentFromUrl: anURL) contents]

{ #category : #services }
HtmlCache >> documentFromUrl: aString [
	| url |
	url := aString asURL.
	url isAbsolute ifFalse: [url := baseUrl / url].
	^documents at: url ifAbsentPut: [| raw |
		raw := self retrieveUrl: url.
		HtmlDocument parse: raw]]

{ #category : #initialization }
HtmlCache >> initialize [
	super initialize.
	documents := Dictionary new]

{ #category : #accessing }
HtmlCache >> url [
	^baseUrl]

{ #category : #accessing }
HtmlCache >> url: aString [
	baseUrl := aString asURL]

