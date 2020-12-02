"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlSpanElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #services }
HtmlSpanElement >> glyphicon: aString [
	self class: 'glyphicon glyphicon-' , aString]

