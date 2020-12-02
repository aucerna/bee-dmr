"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTdElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #converting }
HtmlTdElement >> asHeader [
	^HtmlThElement new attributes: attributes; with: children; yourself]

