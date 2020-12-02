"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBTabset,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUIBTabset >> active: aString [
	self attributeAt: 'active' put: aString]

