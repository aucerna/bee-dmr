"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchOneOrMore,
	#superclass : #HtmlDTDMatchConstraint,
	#category : #HTML
}

{ #category : #printing }
HtmlDTDMatchOneOrMore >> printOn: aStream [
	expression printOn: aStream.
	aStream nextPut: $+]

{ #category : #validation }
HtmlDTDMatchOneOrMore >> validateChildren: aStream ofNode: aNode [
	| matchedOne |
	matchedOne := false.
	[expression validateChildren: aStream ofNode: aNode]
		whileTrue: [matchedOne := true].
	^matchedOne]

