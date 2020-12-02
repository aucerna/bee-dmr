"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTextareaElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlTextareaElement >> cols: anInteger [
	self attributeAt: 'cols' put: anInteger]

{ #category : #attributes }
HtmlTextareaElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #attributes }
HtmlTextareaElement >> readonly [
	self attributeAt: 'readonly' put: nil]

{ #category : #attributes }
HtmlTextareaElement >> rows: anInteger [
	self attributeAt: 'rows' put: anInteger]

