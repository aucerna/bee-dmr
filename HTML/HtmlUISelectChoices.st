"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUISelectChoices,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUISelectChoices class >> tag [
	^'ui-select-choices']

{ #category : #attributes }
HtmlUISelectChoices >> repeat: aString [
	self attributeAt: 'repeat' put: aString]

