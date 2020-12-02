"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlImgElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlImgElement >> height [
	^self attributeAt: 'height']

{ #category : #attributes }
HtmlImgElement >> height: anInteger [
	self attributeAt: 'height' put: anInteger asString]

{ #category : #testing }
HtmlImgElement >> isSelfClosing [
	^true]

{ #category : #attributes }
HtmlImgElement >> src [
	^self attributeAt: 'src']

{ #category : #attributes }
HtmlImgElement >> src: aString [
	self attributeAt: 'src' put: aString]

{ #category : #attributes }
HtmlImgElement >> width [
	^self attributeAt: 'width']

{ #category : #attributes }
HtmlImgElement >> width: anInteger [
	self attributeAt: 'width' put: anInteger asString]

