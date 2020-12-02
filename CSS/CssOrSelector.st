"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssOrSelector,
	#superclass : #CssRelationshipSelector,
	#category : #CSS
}

{ #category : #accessing }
CssOrSelector class >> operator [
	^'']

{ #category : #comparing }
CssOrSelector >> = anObject [
	^self class = anObject class
		and: [selectors asSet = anObject selectors asSet]]

{ #category : #comparing }
CssOrSelector >> hash [
	^self class hash + selectors asSet hash]

{ #category : #accessing }
CssOrSelector >> keySelectors [
	^selectors gather: #keySelectors]

{ #category : #testing }
CssOrSelector >> matches: anHtmlElement [
	^(selectors detect: [:ea | ea matches: anHtmlElement] ifNone: [nil]) notNil]

{ #category : #testing }
CssOrSelector >> printOn: aStream [
	selectors
		do: [:s | s printOn: aStream]
		separatedBy: [aStream nextPutAll: ', ']]

