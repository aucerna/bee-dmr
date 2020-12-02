"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAtRule,
	#superclass : #CssRule,
	#category : #CSS
}

{ #category : #'instance creation' }
CssAtRule class >> named: aString [
	| out cls |
	out := '' writeStream.
	out
		nextPutAll: 'CSSAt';
		nextPut: aString first asUppercase;
		nextPutAll: (aString tail: aString size - 1);
		nextPutAll: 'Rule'.
	cls := Smalltalk classNamed: out contents asSymbol.
	^cls notNil ifTrue: [cls new]]

{ #category : #visiting }
CssAtRule >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitaCssAtRule: self]

{ #category : #parsing }
CssAtRule >> parseContents: aStream [
	| s |
	s := aStream upTo: $;.
	(s includes: ${) ifTrue: [aStream position: self start; upTo: $}].
	self end: aStream position]

