"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeLiteral,
	#superclass : #CssValueType,
	#instVars : [
		'literal'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssValueTypeLiteral class >> readFrom: in [
	| out val |
	out := String new writeStream.
	in peek isAlphanumeric
		ifTrue: [
			out nextPut: in next.
			[in atEnd not and: [in peek isAlphanumeric or: ['_-' includes: in peek]]]
				whileTrue: [out nextPut: in next]]
		ifFalse: [('/,' includes: in peek) ifTrue: [out nextPut: in next]].
	val := self new literal: out contents.
	(CssValueTypeConstraint allTypes includes: in peek)
		ifTrue: [val := (CssValueTypeConstraint readFrom: in) type: val].
	^val]

{ #category : #accessing }
CssValueTypeLiteral >> addValues: aCollection fromStream: in [
	| pos s out |
	pos := in position.
	in skipSeparators.
	out := '' writeStream.
	[in atEnd not and: [literal includes: in peek]]
		whileTrue: [out nextPut: in next].
	s := out contents.
	^s asLowercase = literal
		ifFalse: [
			in position: pos.
			false]
		ifTrue: [
			aCollection add: (CssIdentifierValue new string: self literal).
			true]]

{ #category : #testing }
CssValueTypeLiteral >> isValueValid: anObject [
	^anObject isString and: [self literal = anObject]]

{ #category : #accessing }
CssValueTypeLiteral >> literal [
	^literal]

{ #category : #accessing }
CssValueTypeLiteral >> literal: anObject [
	literal := anObject]

{ #category : #printing }
CssValueTypeLiteral >> printOn: aStream [
	aStream nextPutAll: self literal]

