"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssIdSelector,
	#superclass : #CssAttributeEqualsSelector,
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssIdSelector class >> readFrom: in [
	| out |
	out := '' writeStream.
	in peek = $# ifTrue: [in next].
	[in atEnd not and: [in peek isAlphanumeric or: ['-_' includes: in peek]]]
		whileTrue: [out nextPut: in next].
	^self new value: out contents]

{ #category : #initialization }
CssIdSelector >> initialize [
	super initialize.
	self attribute: 'id']

{ #category : #printing }
CssIdSelector >> printOn: aStream [
	aStream nextPut: $#; nextPutAll: self value]

