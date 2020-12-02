"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #XHtmlDTD,
	#superclass : #HtmlDTD,
	#category : #HTML
}

{ #category : #testing }
XHtmlDTD >> canTag: tag1 containTag: tag2 [
	| element |
	element := self elementForTag: tag1 asLowercase.
	^element notNil and: [element allowsTag: tag2 asLowercase]]

{ #category : #testing }
XHtmlDTD >> isXML [
	^true]

{ #category : #private }
XHtmlDTD >> objectifyElements [
	elements := elements collect: [:ea | XHtmlDTDElement fromParsedString: ea]]

{ #category : #testing }
XHtmlDTD >> tag: aTag canContainTag: anotherTag [
	| element |
	element := self elementForTag: aTag asLowercase.
	^element notNil
		ifTrue: [element allowsTag: anotherTag asLowercase]
		ifFalse: [false]]

