"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlButtonElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlButtonElement >> form: id [
	self attributeAt: 'form' put: id]

{ #category : #bootstrap }
HtmlButtonElement >> glyphicon: aString [
	self addSpan glyphicon: aString]

{ #category : #attributes }
HtmlButtonElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #attributes }
HtmlButtonElement >> type: aString [
	self attributeAt: 'type' put: aString]

{ #category : #attributes }
HtmlButtonElement >> value: aString [
	self attributeAt: 'value' put: aString]

