"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlIElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #services }
HtmlIElement >> glyphicon: aString [
	self class: 'glyphicon glyphicon-' , aString]

