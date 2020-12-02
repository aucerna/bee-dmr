"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssRule,
	#superclass : #CssElement,
	#instVars : [
		'media'
	],
	#category : #CSS
}

{ #category : #visiting }
CssRule >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitCssRule: self]

{ #category : #testing }
CssRule >> isAtImportRule [
	^false]

{ #category : #testing }
CssRule >> isStyleRule [
	^false]

{ #category : #accessing }
CssRule >> media [
	^media]

{ #category : #accessing }
CssRule >> media: anObject [
	media := anObject]

