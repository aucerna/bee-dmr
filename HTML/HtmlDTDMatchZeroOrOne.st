"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchZeroOrOne,
	#superclass : #HtmlDTDMatchConstraint,
	#category : #HTML
}

{ #category : #printing }
HtmlDTDMatchZeroOrOne >> printOn: aStream [
	expression printOn: aStream.
	aStream nextPut: $?]

{ #category : #validation }
HtmlDTDMatchZeroOrOne >> validateChildren: aStream ofNode: aNode [
	expression validateChildren: aStream ofNode: aNode.
	^true]

