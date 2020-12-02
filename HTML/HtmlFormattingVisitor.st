"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlFormattingVisitor,
	#superclass : #HtmlElementVisitor,
	#instVars : [
		'indent',
		'stream'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlFormattingVisitor class >> on: aStream [
	^self new on: aStream]

{ #category : #accessing }
HtmlFormattingVisitor >> indent: anInteger [
	indent := anInteger]

{ #category : #initialization }
HtmlFormattingVisitor >> initialize [
	super initialize.
	indent := 0]

{ #category : #accessing }
HtmlFormattingVisitor >> on: aStream [
	stream := aStream]

{ #category : #printing }
HtmlFormattingVisitor >> printAttribute: name value: value [
	self printAttributeName: name asString.
	value notNil
		ifTrue: [self printOperator: $=; printAttributeValue: value asString]]

{ #category : #printing }
HtmlFormattingVisitor >> printAttributeName: aString [
	stream nextPutAll: aString]

{ #category : #printing }
HtmlFormattingVisitor >> printAttributesOf: anHtmlElement [
	anHtmlElement attributes keys do: [:name | | value |
		stream space.
		value := anHtmlElement attributeAt: name.
		self printAttribute: name value: value]]

{ #category : #printing }
HtmlFormattingVisitor >> printAttributeValue: aString [
	stream nextPutAll: aString doubleQuoted]

{ #category : #printing }
HtmlFormattingVisitor >> printClosingTagOf: anHtmlElement [
	anHtmlElement isSelfClosing ifTrue: [^self].
	(anHtmlElement children notEmpty andNot: [anHtmlElement hasOnlyText])
		ifTrue: [stream crtab: indent].
	stream nextPutAll: '</' , anHtmlElement tag , '>']

{ #category : #printing }
HtmlFormattingVisitor >> printOpeningTagOf: anHtmlElement [
	stream nextPut: $<; nextPutAll: anHtmlElement tag.
	self printAttributesOf: anHtmlElement.
	stream nextPut: $>]

{ #category : #printing }
HtmlFormattingVisitor >> printOperator: aCharacter [
	stream nextPut: aCharacter]

{ #category : #printing }
HtmlFormattingVisitor >> printText: aString [
	stream nextPutAll: aString]

{ #category : #visting }
HtmlFormattingVisitor >> visitHtmlDocument: anHtmlDocument [
	stream nextPutAll: '<!DOCTYPE html>'; cr.
	indent := indent + 1.
	anHtmlDocument children do: [:e | self visit: e] separatedBy: [stream cr]]

{ #category : #visting }
HtmlFormattingVisitor >> visitHtmlElement: anHtmlElement [
	stream tab: indent.
	self printOpeningTagOf: anHtmlElement.
	anHtmlElement children notEmpty ifTrue: [
		anHtmlElement hasOnlyText ifFalse: [stream cr].
		indent := indent + 1.
		anHtmlElement children do: [:e | self visit: e] separatedBy: [stream cr].
		indent := indent - 1].
	self printClosingTagOf: anHtmlElement]

{ #category : #visting }
HtmlFormattingVisitor >> visitHtmlPartialDocument: anHtmlPartialDocument [
	anHtmlPartialDocument children
		do: [:e | self visit: e]
		separatedBy: [stream cr]]

{ #category : #visiting }
HtmlFormattingVisitor >> visitHtmlTextElement: anHtmlTextElement [
	self printText: anHtmlTextElement text]

