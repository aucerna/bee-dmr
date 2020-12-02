"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUlElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #'adding/removing' }
HtmlUlElement >> add: anHtmlElement [
	self ASSERT: (anHtmlElement isKindOf: HtmlLiElement).
	^super add: anHtmlElement]

{ #category : #'adding/removing' }
HtmlUlElement >> addItem [
	^self add: HtmlLiElement new]

