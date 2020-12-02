"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssFormattingVisitor,
	#superclass : #CssElementVisitor,
	#instVars : [
		'indent',
		'stream'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssFormattingVisitor class >> on: aStream [
	^self new on: aStream]

{ #category : #printing }
CssFormattingVisitor >> cr [
	stream crtab: indent]

{ #category : #printing }
CssFormattingVisitor >> crtab [
	stream crtab: indent + 1]

{ #category : #accessing }
CssFormattingVisitor >> indent: anInteger [
	indent := anInteger]

{ #category : #initialization }
CssFormattingVisitor >> initialize [
	super initialize.
	indent := 0]

{ #category : #accessing }
CssFormattingVisitor >> on: aStream [
	stream := aStream]

{ #category : #printing }
CssFormattingVisitor >> printOperator: aCharacter [
	stream nextPut: aCharacter]

{ #category : #printing }
CssFormattingVisitor >> printProperty: aCssProperty [
	self
		printPropertyName: aCssProperty name;
		printOperator: $:;
		space;
		printPropertyValue: aCssProperty stringValue]

{ #category : #printing }
CssFormattingVisitor >> printPropertyName: aString [
	stream nextPutAll: aString]

{ #category : #printing }
CssFormattingVisitor >> printPropertyValue: aString [
	stream nextPutAll: aString]

{ #category : #printing }
CssFormattingVisitor >> printSelector: aCssSelector [
	aCssSelector printOn: stream]

{ #category : #printing }
CssFormattingVisitor >> space [
	stream space]

{ #category : #visiting }
CssFormattingVisitor >> visitCssStyleRule: aCssStyleRule [
	self printSelector: aCssStyleRule selector; space; printOperator: ${.
	aCssStyleRule properties
		do: [:p | self crtab; printProperty: p; printOperator: $;].
	self cr; printOperator: $}]

{ #category : #visiting }
CssFormattingVisitor >> visitCssStyleSheet: aCssStyleSheet [
	stream tab: indent.
	aCssStyleSheet children
		do: [:child | self visit: child]
		separatedBy: [self cr]]

