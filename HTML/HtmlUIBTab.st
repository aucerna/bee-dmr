"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBTab,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlUIBTab >> disable: aString [
	self attributeAt: 'disable' put: aString]

{ #category : #attributes }
HtmlUIBTab >> heading: aString [
	self attributeAt: 'heading' put: aString]

{ #category : #attributes }
HtmlUIBTab >> index: aString [
	self attributeAt: 'index' put: aString]

{ #category : #attributes }
HtmlUIBTab >> select: aString [
	self attributeAt: 'select' put: aString]

