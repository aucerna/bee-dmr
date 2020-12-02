"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlElementVisitor,
	#superclass : #Object,
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlElementVisitor class >> new [
	^super new initialize]

{ #category : #visting }
HtmlElementVisitor >> visit: anHtmlElement [
	anHtmlElement acceptVisitor: self]

{ #category : #visting }
HtmlElementVisitor >> visitHtmlDocument: anHtmlDocument [
	self visitHtmlElement: anHtmlDocument]

{ #category : #visting }
HtmlElementVisitor >> visitHtmlElement: anHtmlElement [
	]

{ #category : #visting }
HtmlElementVisitor >> visitHtmlTextElement: anHtmlTextElement [
	self visitHtmlElement: anHtmlTextElement]

