"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssPseudoClassSelector,
	#superclass : #CssSelector,
	#instVars : [
		'pseudoclass',
		'arguments'
	],
	#category : #CSS
}

{ #category : #'as yet unclassified' }
CssPseudoClassSelector class >> readFrom: in [
	| cls obj out |
	in next = $: ifFalse: [self halt].
	out := '' writeStream.
	"out nextPutAll: 'CSS'."
	out nextPut: in next asUppercase.
	[in peek notNil and: [in peek isLetter or: [in peek = $-]]] whileTrue: [
		in peek = $-
			ifTrue: [
				in next.
				out nextPut: in next asUppercase]
			ifFalse: [out nextPut: in next]].
	"out nextPutAll: 'Selector'."

	cls := Smalltalk
		at: ('CSS' , out contents , 'Selector') asSymbol
		ifAbsent: [self].
	cls = self
		ifTrue: [obj := cls new pseudoClassName: out contents]
		ifFalse: [obj := cls new].
	in skipSeparators.
	in peek = $( ifTrue: [
		in next.
		obj arguments: (in upTo: $))].
	^obj]

{ #category : #accessing }
CssPseudoClassSelector >> arguments [
	^arguments]

{ #category : #accessing }
CssPseudoClassSelector >> arguments: anObject [
	arguments := anObject]

{ #category : #testing }
CssPseudoClassSelector >> matches: anHtmlElement [
	^true]

{ #category : #printing }
CssPseudoClassSelector >> printOn: aStream [
	| s |
	s := self pseudoClassName asString.
	aStream nextPut: $:; nextPutAll: s asLowercase]

{ #category : #accessing }
CssPseudoClassSelector >> pseudoClassName [
	^pseudoclass isNil ifFalse: [pseudoclass] ifTrue: [| nm in out |
		nm := self class name asString.
		nm := nm tail: nm size - 'CSS' size.
		nm := nm truncateTo: nm size - 'Selector' size.
		out := (String new: nm size * 2) writeStream.
		in := nm readStream.
		out nextPut: in next asLowercase.
		[in atEnd] whileFalse: [
			in peek isUppercase
				ifTrue: [
					out nextPut: $-.
					out nextPut: in next asLowercase]
				ifFalse: [out nextPut: in next]].
		out contents]]

{ #category : #accessing }
CssPseudoClassSelector >> pseudoClassName: anObject [
	pseudoclass := anObject]

