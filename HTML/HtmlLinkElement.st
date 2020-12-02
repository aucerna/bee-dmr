"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlLinkElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlLinkElement >> href: aString [
	self attributeAt: 'href' put: aString]

{ #category : #testing }
HtmlLinkElement >> isSelfClosing [
	^true]

{ #category : #attributes }
HtmlLinkElement >> rel: relationship [
	self attributeAt: 'rel' put: relationship]

{ #category : #attributes }
HtmlLinkElement >> type: type [
	self attributeAt: 'type' put: type]

