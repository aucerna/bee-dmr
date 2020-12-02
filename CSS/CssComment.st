"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssComment,
	#superclass : #CssElement,
	#category : #CSS
}

{ #category : #visiting }
CssComment >> acceptVisitor: aCssElementVisitor [
	aCssElementVisitor visitCssComment: self]

{ #category : #testing }
CssComment >> isAtImportRule [
	^false]

{ #category : #parsing }
CssComment >> parseContents: aStream [
	aStream skip: 2.
	[aStream atEnd] whileFalse: [
		(aStream peek = $* and: [
			aStream next.
			aStream peek = $/])
			ifTrue: [
				aStream next.
				^self end: aStream position]
			ifFalse: [aStream next = $\ ifTrue: [aStream next]]].
	self end: aStream position]

{ #category : #accessing }
CssComment >> tag [
	^'comment']

