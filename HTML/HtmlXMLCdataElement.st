"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlXMLCdataElement,
	#superclass : #HtmlCommentElement,
	#category : #HTML
}

{ #category : #parsing }
HtmlXMLCdataElement >> parseContents: aStream [
	| cdStart out child |
	out := '' writeStream.
	aStream skipSeparators.
	'<![CDATA[' size timesRepeat: [out nextPut: aStream next].
	(out contents beginsWith: '<![CDATA[')
		ifTrue: [cdStart := aStream position]
		ifFalse: [self halt].
	[(out contents endsWith: ']]>') or: [aStream atEnd]]
		whileFalse: [out nextPut: aStream next].
	(out contents endsWith: ']]>')
		ifFalse: [
			aStream position: cdStart.
			aStream upTo: $>.
			child := HtmlCdataElement new
				start: cdStart;
				end: aStream position - 1.
			self add: child; endTagMissing: true]
		ifTrue: [
			child := HtmlCdataElement new
				start: cdStart;
				end: aStream position - ']]>' size.
			self
				end: aStream position;
				add: child;
				endTagMissing: false]]

