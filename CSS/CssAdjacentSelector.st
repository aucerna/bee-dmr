"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAdjacentSelector,
	#superclass : #CssRelationshipSelector,
	#category : #CSS
}

{ #category : #accessing }
CssAdjacentSelector class >> operator [
	^'+']

{ #category : #testing }
CssAdjacentSelector >> isAdjacentSelector [
	^true]

{ #category : #testing }
CssAdjacentSelector >> matches: anHtmlElement [
	| node |
	node := anHtmlElement.
	selectors reverseDo: [:ea | 
		(ea matches: node) ifFalse: [^false] ifTrue: [
			selectors first == ea
				ifFalse: [node := node parent children before: node ifAbsent: [^false]]]].
	^true]

