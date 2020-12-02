"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #XHtmlDTDElement,
	#superclass : #HtmlDTDElement,
	#category : #HTML
}

{ #category : #'instance creation' }
XHtmlDTDElement class >> fromParsedString: aString [
	| in tag start end contents |
	in := aString readStream.
	tag := self readExpression: in.
	start := '-'.
	end := '-'.
	contents := in upToEnd trimBlanks.
	^self new
		tag: tag;
		startIsOptional: start;
		endIsOptional: end;
		contentRule: contents]

