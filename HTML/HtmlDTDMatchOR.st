"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchOR,
	#superclass : #HtmlDTDMatchGroup,
	#category : #HTML
}

{ #category : #testing }
HtmlDTDMatchOR >> isEnumeration [
	^true]

{ #category : #accessing }
HtmlDTDMatchOR >> separator [
	^'|']

{ #category : #validation }
HtmlDTDMatchOR >> validateChildren: aStream ofNode: aNode [
	| position matched |
	position := aStream position.
	matched := expression
		detect: [:ea | 
			aStream position: position.
			ea validateChildren: aStream ofNode: aNode]
		ifNone: [nil].
	^matched notNil]

