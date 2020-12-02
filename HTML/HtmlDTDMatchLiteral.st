"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchLiteral,
	#superclass : #HtmlDTDMatchExpression,
	#classVars : [
		'LiteralsByTagAsSymbol'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlDTDMatchLiteral class >> expression: aTag [
	LiteralsByTagAsSymbol isNil
		ifTrue: [LiteralsByTagAsSymbol := WeakValueDictionary new].
	^LiteralsByTagAsSymbol
		at: aTag asSymbol
		ifAbsentPut: [self new expression: aTag]]

{ #category : #'instance creation' }
HtmlDTDMatchLiteral class >> on: aStream [
	| in out delims s |
	in := aStream readStream.
	delims := ' ()|*?+-,&'.
	out := '' writeStream.
	in skipSeparators.
	[in atEnd or: [delims includes: in peek]]
		whileFalse: [out nextPut: in next].
	s := out contents.
	^s = 'EMPTY' ifTrue: [HtmlDTDMatchEmpty empty] ifFalse: [
		(s asUppercase indexOfString: 'CDATA') > 0
			ifTrue: [HtmlDTDMatchCDATA cdata]
			ifFalse: [HtmlDTDMatchLiteral new expression: s]]]

{ #category : #inquiries }
HtmlDTDMatchLiteral >> allowedElements [
	^{self}]

{ #category : #testing }
HtmlDTDMatchLiteral >> allowsItem: item [
	^expression = item]

{ #category : #testing }
HtmlDTDMatchLiteral >> isLiteral [
	^true]

{ #category : #printing }
HtmlDTDMatchLiteral >> printOn: aStream [
	aStream
		nextPut: $";
		nextPutAll: expression;
		nextPut: $"]

{ #category : #validation }
HtmlDTDMatchLiteral >> validateChildren: aStream ofNode: aNode [
	^(aStream atEnd not and: [expression = aStream peek dtdTag])
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]]

