"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlHeadBodyNestingError,
	#superclass : #HtmlTagError,
	#instVars : [
		'nesting'
	],
	#category : #HTML
}

{ #category : #testing }
HtmlHeadBodyNestingError >> isStructuralError [
	^true]

{ #category : #accessing }
HtmlHeadBodyNestingError >> nesting [
	^nesting]

{ #category : #accessing }
HtmlHeadBodyNestingError >> nesting: anObject [
	nesting := anObject]

{ #category : #accessing }
HtmlHeadBodyNestingError >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $ .
	'Actual tag nesting order found in document is: ' , self nesting asString
		printOn: aStream]

