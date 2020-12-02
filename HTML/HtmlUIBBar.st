"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBBar,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUIBBar >> type: aString [
	self attributeAt: 'type' put: aString]

{ #category : #evaluating }
HtmlUIBBar >> value: aNumber [
	self attributeAt: 'value' put: aNumber]

