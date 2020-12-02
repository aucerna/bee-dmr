"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlH1Element,
	#superclass : #HtmlElement,
	#instVars : [
		'level'
	],
	#category : #HTML
}

{ #category : #initialization }
HtmlH1Element >> initialize [
	super initialize.
	level := 1]

{ #category : #accessing }
HtmlH1Element >> level: anInteger [
	self ASSERT: (anInteger between: 1 and: 6).
	level := anInteger]

