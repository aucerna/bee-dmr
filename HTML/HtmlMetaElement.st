"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlMetaElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlMetaElement >> author: aString [
	self attributeAt: 'author' put: aString]

{ #category : #attributes }
HtmlMetaElement >> charset: aString [
	self attributeAt: 'charset' put: aString]

{ #category : #attributes }
HtmlMetaElement >> description: aString [
	self attributeAt: 'description' put: aString]

{ #category : #attributes }
HtmlMetaElement >> httpequiv: httpequiv content: content [
	self
		attributeAt: 'http-equiv' put: httpequiv;
		attributeAt: 'content' put: content]

{ #category : #testing }
HtmlMetaElement >> isSelfClosing [
	^true]

{ #category : #attributes }
HtmlMetaElement >> keywords: aCollection [
	| keywords |
	keywords := String streamContents: [:strm | 
		aCollection
			do: [:keyword | strm nextPutAll: keyword]
			separatedBy: [strm nextPut: $,; space]].
	self attributeAt: 'keywords' put: keywords]

{ #category : #attributes }
HtmlMetaElement >> name: name content: content [
	self
		attributeAt: 'name' put: name;
		attributeAt: 'content' put: content]

{ #category : #attributes }
HtmlMetaElement >> viewport: aString [
	self name: 'viewport' content: aString]

