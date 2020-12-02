"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssClassSelector,
	#superclass : #CssAttributeIncludesSelector,
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssClassSelector class >> readFrom: in [
	| out |
	out := '' writeStream.
	in peek = $. ifTrue: [in next].
	[in atEnd not and: [in peek isAlphanumeric or: ['-_' includes: in peek]]]
		whileTrue: [out nextPut: in next].
	^self new value: out contents unquoted]

{ #category : #initialization }
CssClassSelector >> initialize [
	super initialize.
	self attribute: 'class']

{ #category : #testing }
CssClassSelector >> matches: anHtmlElement [
	^anHtmlElement classes includes: self value]

{ #category : #printing }
CssClassSelector >> printOn: aStream [
	aStream nextPut: $.; nextPutAll: self value]

