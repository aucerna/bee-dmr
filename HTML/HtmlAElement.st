"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlAElement class >> to: url glyphicon: aString [
	| anchor |
	anchor := self new.
	anchor href: url; glyphicon: aString.
	^anchor]

{ #category : #'instance creation' }
HtmlAElement class >> to: url icon: class [
	| anchor |
	anchor := self new.
	anchor href: url.
	anchor addSpan class: class.
	^anchor]

{ #category : #'instance creation' }
HtmlAElement class >> to: url label: label [
	^self new href: url; with: label; yourself]

{ #category : #attributes }
HtmlAElement >> download: filename [
	self attributeAt: 'download' put: filename]

{ #category : #services }
HtmlAElement >> glyphicon: aString [
	self addSpan glyphicon: aString]

{ #category : #attributes }
HtmlAElement >> href [
	^self attributeAt: 'href']

{ #category : #attributes }
HtmlAElement >> href: aString [
	self attributeAt: 'href' put: aString]

{ #category : #attributes }
HtmlAElement >> rel: relationship [
	self attributeAt: 'rel' put: relationship]

{ #category : #attributes }
HtmlAElement >> target: aString [
	self attributeAt: 'target' put: aString]

{ #category : #attributes }
HtmlAElement >> type: type [
	self attributeAt: 'type' put: type]

