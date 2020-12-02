"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlCustomElement,
	#superclass : #HtmlElement,
	#instVars : [
		'tag'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlCustomElement >> tag [
	^tag]

{ #category : #accessing }
HtmlCustomElement >> tag: aString [
	tag := aString]

