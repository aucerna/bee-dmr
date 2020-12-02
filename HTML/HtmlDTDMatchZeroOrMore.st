"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchZeroOrMore,
	#superclass : #HtmlDTDMatchConstraint,
	#category : #HTML
}

{ #category : #printing }
HtmlDTDMatchZeroOrMore >> printOn: aStream [
	expression printOn: aStream.
	aStream nextPut: $*]

{ #category : #validation }
HtmlDTDMatchZeroOrMore >> validateChildren: aStream ofNode: aNode [
	[expression validateChildren: aStream ofNode: aNode] whileTrue: [].
	^true]

