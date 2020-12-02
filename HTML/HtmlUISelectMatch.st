"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUISelectMatch,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUISelectMatch class >> tag [
	^'ui-select-match']

{ #category : #attributes }
HtmlUISelectMatch >> placeholder: aString [
	self attributeAt: 'placeholder' put: aString]

