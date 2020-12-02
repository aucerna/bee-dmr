"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTextElement,
	#superclass : #HtmlElement,
	#instVars : [
		'text'
	],
	#category : #HTML
}

{ #category : #visiting }
HtmlTextElement >> acceptVisitor: anHtmlElementVisitor [
	anHtmlElementVisitor visitHtmlTextElement: self]

{ #category : #accessing }
HtmlTextElement >> tag [
	^nil]

{ #category : #accessing }
HtmlTextElement >> text [
	^text]

{ #category : #accessing }
HtmlTextElement >> text: aString [
	text := aString]

