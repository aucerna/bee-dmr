"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssDescendantSelector,
	#superclass : #CssRelationshipSelector,
	#category : #CSS
}

{ #category : #accessing }
CssDescendantSelector class >> operator [
	^' ']

{ #category : #testing }
CssDescendantSelector >> isDescendantSelector [
	^true]

{ #category : #testing }
CssDescendantSelector >> matches: anHtmlElement [
	| node |
	(selectors last matches: anHtmlElement) ifFalse: [^false].
	node := anHtmlElement parent.
	selectors size - 1 to: 1 by: -1 do: [:idx | | sel |
		node isNil ifTrue: [^false].
		sel := selectors at: idx.
		[node isNil or: [sel matches: node]] whileFalse: [node := node parent]].
	^node notNil]

{ #category : #printing }
CssDescendantSelector >> printOn: aStream [
	selectors do: [:s | s printOn: aStream] separatedBy: [aStream space]]

