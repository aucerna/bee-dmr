"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlBaseElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlBaseElement >> href [
	^self attributeAt: 'href']

{ #category : #accessing }
HtmlBaseElement >> href: aString [
	self attributeAt: 'href' put: aString]

{ #category : #testing }
HtmlBaseElement >> isSelfClosing [
	^true]

