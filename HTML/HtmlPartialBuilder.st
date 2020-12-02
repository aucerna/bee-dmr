"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlPartialBuilder,
	#superclass : #HtmlBuilder,
	#category : #HTML
}

{ #category : #initialization }
HtmlPartialBuilder >> initialize [
	super initialize.
	document := current := HtmlPartialDocument new]

