"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssSiblingSelector,
	#superclass : #CssRelationshipSelector,
	#category : #CSS
}

{ #category : #accessing }
CssSiblingSelector class >> operator [
	^'~']

{ #category : #testing }
CssSiblingSelector >> isAdjacentSelector [
	^false]

{ #category : #testing }
CssSiblingSelector >> matches: anHtmlElement [
	| predecessors sels |
	(selectors last matches: anHtmlElement) ifTrue: [
		predecessors := anHtmlElement parent children.
		predecessors := predecessors
			truncateTo: (predecessors indexOf: anHtmlElement) - 1.
		sels := selectors truncateTo: selectors size - 1.
		[predecessors isEmpty not] whileTrue: [
			(sels last matches: predecessors last) ifTrue: [
				sels size = 1
					ifTrue: [^true]
					ifFalse: [sels := sels truncateTo: sels size - 1]].
			predecessors := predecessors truncateTo: predecessors size - 1]].
	^false]

