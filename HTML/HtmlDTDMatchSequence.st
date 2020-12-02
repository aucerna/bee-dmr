"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchSequence,
	#superclass : #HtmlDTDMatchGroup,
	#category : #HTML
}

{ #category : #accessing }
HtmlDTDMatchSequence >> separator [
	^',']

{ #category : #validation }
HtmlDTDMatchSequence >> validateChildren: aStream ofNode: aNode [
	^expression conform: [:e | e validateChildren: aStream ofNode: aNode]]

