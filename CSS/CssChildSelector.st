"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssChildSelector,
	#superclass : #CssRelationshipSelector,
	#category : #CSS
}

{ #category : #accessing }
CssChildSelector class >> operator [
	^'>']

{ #category : #testing }
CssChildSelector >> isChildSelector [
	^true]

{ #category : #testing }
CssChildSelector >> matches: anHtmlElement [
	| node |
	node := anHtmlElement.
	selectors reverseDo: [:ea | 
		(ea matches: node) ifFalse: [^false].
		node := node parent].
	^true]

