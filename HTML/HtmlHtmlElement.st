"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlHtmlElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlHtmlElement >> body [
	^self detect: [:e | e class == HtmlBodyElement]]

{ #category : #accessing }
HtmlHtmlElement >> body: anHtmlBody [
	^self body
		ifNotNil: [:b | self replace: b with: anHtmlBody]
		ifNil: [self addFirst: anHtmlBody]]

{ #category : #accessing }
HtmlHtmlElement >> head [
	^self detect: [:e | e class == HtmlHeadElement]]

{ #category : #accessing }
HtmlHtmlElement >> head: anHtmlHead [
	| head |
	head := self head.
	^head notNil
		ifTrue: [self replace: head with: anHtmlHead]
		ifFalse: [self add: head]]

{ #category : #initialization }
HtmlHtmlElement >> initialize [
	super initialize.
	self add: HtmlHeadElement new; add: HtmlBodyElement new]

