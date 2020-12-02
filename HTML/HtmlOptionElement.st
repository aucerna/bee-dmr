"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlOptionElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlOptionElement >> disabled [
	self attributeAt: 'disabled' put: nil]

{ #category : #attributes }
HtmlOptionElement >> label: aString [
	self attributeAt: 'label' put: aString]

{ #category : #attributes }
HtmlOptionElement >> selected [
	self attributeAt: 'selected' put: nil]

{ #category : #attributes }
HtmlOptionElement >> value: aString [
	self attributeAt: 'value' put: aString]

