"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUISelect,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUISelect class >> tag [
	^'ui-select']

{ #category : #attributes }
HtmlUISelect >> theme: aString [
	self attributeAt: 'theme' put: aString]

