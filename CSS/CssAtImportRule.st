"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAtImportRule,
	#superclass : #CssAtRule,
	#instVars : [
		'uri',
		'stylesheet'
	],
	#category : #CSS
}

{ #category : #testing }
CssAtImportRule >> isAtImportRule [
	^true]

{ #category : #parsing }
CssAtImportRule >> parseContents: aStream [
	| s m |
	uri := CssUriValue readFrom: aStream.
	aStream skipSeparators.
	s := aStream upTo: $;.
	self end: aStream position.
	m := s substringsDelimitedBy: ', '.
	m size > 0 ifTrue: [self media: m]]

{ #category : #accessing }
CssAtImportRule >> stylesheet [
	stylesheet isNil
		ifTrue: [stylesheet := CssStyleSheet fromUrl: uri value parent: self].
	^stylesheet]

{ #category : #accessing }
CssAtImportRule >> stylesheet: anObject [
	stylesheet := anObject]

