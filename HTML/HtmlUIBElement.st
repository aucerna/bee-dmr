"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUIBElement class >> tag [
	| suffix |
	suffix := self name allButFirst: 'HtmlUIB' size.
	^String streamContents: [:strm | 
		strm nextPutAll: 'uib-'.
		suffix subwords
			do: [:w | strm nextPutAll: w asLowercase]
			separatedBy: [strm nextPut: $-]]]

