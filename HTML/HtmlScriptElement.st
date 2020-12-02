"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlScriptElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #attributes }
HtmlScriptElement >> defer [
	self attributeAt: 'defer' put: nil]

{ #category : #parsing }
HtmlScriptElement >> parseContents: aStream [
	| class start raw tag script |
	class := Smalltalk at: #JSEParser ifAbsent: nil.
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
	raw isEmpty ifTrue: [^self].
	script := class parse: raw.
	script isPetitFailure ifTrue: [
		aStream position: start.
		^super parseContents: aStream].
	self add: script]

{ #category : #attributes }
HtmlScriptElement >> src: url [
	self attributeAt: 'src' put: url]

{ #category : #attributes }
HtmlScriptElement >> type: aString [
	self attributeAt: 'type' put: aString]

