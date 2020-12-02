"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlTagStructureError,
	#superclass : #HtmlError,
	#category : #HTML
}

{ #category : #testing }
HtmlTagStructureError >> isStructuralError [
	^true]

