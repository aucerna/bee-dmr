"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlPartialDocument,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #visiting }
HtmlPartialDocument >> acceptVisitor: anHtmlElementVisitor [
	anHtmlElementVisitor visitHtmlPartialDocument: self]

