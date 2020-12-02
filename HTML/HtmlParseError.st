"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlParseError,
	#superclass : #Error,
	#instVars : [
		'error'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlParseError class >> on: anHtmlError [
	^self new on: anHtmlError]

{ #category : #accessing }
HtmlParseError >> on: anHtmlError [
	error := anHtmlError.
	description := anHtmlError asString]

{ #category : #accessing }
HtmlParseError >> position [
	^error position]

