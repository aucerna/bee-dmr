"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlLabelElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlLabelElement >> for: elementId [
	self attributeAt: 'for' put: elementId]

{ #category : #attributes }
HtmlLabelElement >> from: formId [
	self attributeAt: 'from' put: formId]

