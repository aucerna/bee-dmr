"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlSyntaxError,
	#superclass : #HtmlError,
	#category : #HTML
}

{ #category : #testing }
HtmlSyntaxError >> isSyntaxError [
	^true]

