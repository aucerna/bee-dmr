"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssTypeSelector,
	#superclass : #CssUniversalSelector,
	#instVars : [
		'element'
	],
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssTypeSelector class >> readFrom: in [
	| out |
	out := '' writeStream.
	(in atEnd not and: [in peek isLetter])
		ifTrue: [
			out nextPut: in next.
			[
				in atEnd not
					and: [in peek isLetter
						or: [in peek isDigit or: ['-_' includes: in peek]]]]
				whileTrue: [out nextPut: in next]]
		ifFalse: [self halt].
	^self new element: out contents; readAttributeSelectorsFrom: in]

{ #category : #accessing }
CssTypeSelector >> element [
	^element]

{ #category : #accessing }
CssTypeSelector >> element: aString [
	element := aString]

{ #category : #testing }
CssTypeSelector >> isTypeSelector [
	^true]

{ #category : #testing }
CssTypeSelector >> matches: anHtmlElement [
	anHtmlElement isStyle ifTrue: [^false].
	^(anHtmlElement dtd isXML
		ifTrue: [element = anHtmlElement tag]
		ifFalse: [element asLowercase = anHtmlElement tag])
		and: [super matches: anHtmlElement]]

{ #category : #printing }
CssTypeSelector >> printOn: aStream [
	aStream nextPutAll: self element.
	selectors do: [:s | s printOn: aStream]]

