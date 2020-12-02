"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDConstruct,
	#superclass : #Object,
	#instVars : [
		'tag'
	],
	#category : #HTML
}

{ #category : #'as yet unclassified' }
HtmlDTDConstruct class >> readExpression: in [
	| s |
	in skipSeparators.
	^in peek = $(
		ifTrue: [
			s := in upTo: $).
			s , ')' , (in upTo: $ )]
		ifFalse: [in upTo: $ ]]

{ #category : #accessing }
HtmlDTDConstruct >> tag [
	^tag]

{ #category : #accessing }
HtmlDTDConstruct >> tag: anObject [
	tag := HtmlDTDMatchExpression on: anObject trimBlanks]

{ #category : #testing }
HtmlDTDConstruct >> tagMatches: aString [
	^tag allowsItem: aString]

