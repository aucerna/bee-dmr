"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlStyleElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #testing }
HtmlStyleElement >> isStyle [
	^false]

{ #category : #parsing }
HtmlStyleElement >> parseContents: aStream [
	| class start raw tag sheet |
	class := Smalltalk at: #CssStyleSheet ifAbsent: nil.
	class isNil ifTrue: [^super parseContents: aStream].
	start := aStream position.
	raw := aStream upTo: $>.
	tag := self tag.
	[(raw asLowercase endsWith: '</' , tag) or: [aStream atEnd]]
		whileFalse: [raw := raw , '>' , (aStream upTo: $>)].
	self
		end: aStream position;
		endTagMissing: (raw asLowercase endsWith: '</' , tag) not.
	raw := (raw allButLast: tag size + 2) trimBlanks.
	sheet := [class parse: raw] on: Error do: [].
	sheet isNil ifTrue: [
		aStream position: start.
		^super parseContents: aStream].
	self add: sheet]

{ #category : #accessing }
HtmlStyleElement >> stylesheet [
	^self children anyone]

