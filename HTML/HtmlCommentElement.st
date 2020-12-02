"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlCommentElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #testing }
HtmlCommentElement >> isComment [
	^true]

{ #category : #parsing }
HtmlCommentElement >> parseContents: aStream [
	| brackets start |
	brackets := false.
	aStream upTo: $!.
	start := aStream position.
	[aStream atEnd] whileFalse: [| c child |
		((c := aStream next) = $- and: [aStream peek = $-])
			ifTrue: [
				aStream next.
				brackets := brackets not]
			ifFalse: [
				(c = $> and: [brackets not])
					ifTrue: [
						child := HtmlCdataElement start: start end: aStream position - 1.
						^self end: aStream position; add: child]
					ifFalse: [
						(c = $- and: [aStream peek = $>]) ifTrue: [
							child := HtmlCdataElement start: start end: aStream position.
							self add: child.
							aStream next.
							^self end: aStream position; endTagMissing: brackets]]]].
	self endTagMissing: true; end: aStream position]

