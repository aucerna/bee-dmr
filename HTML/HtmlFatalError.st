"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlFatalError,
	#superclass : #HtmlError,
	#category : #HTML
}

{ #category : #testing }
HtmlFatalError >> isFatal [
	^true]

{ #category : #printing }
HtmlFatalError >> printOn: aStream [
	super printOn: aStream.
	'ERROR!  This page is much too broken to parse.' printOn: aStream]

