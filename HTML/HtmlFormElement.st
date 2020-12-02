"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlFormElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlFormElement >> action: url [
	self attributeAt: 'action' put: url]

{ #category : #attributes }
HtmlFormElement >> method: method [
	self attributeAt: 'method' put: method]

{ #category : #attributes }
HtmlFormElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #attributes }
HtmlFormElement >> novalidate [
	self attributeAt: 'novalidate' put: nil]

