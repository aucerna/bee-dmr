"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDAttrList,
	#superclass : #HtmlDTDConstruct,
	#instVars : [
		'attributes'
	],
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlDTDAttrList class >> fromParsedArray: anArray [
	| tag attrs list |
	tag := anArray first.
	attrs := anArray allButFirst.
	list := OrderedCollection new.
	attrs do: [:ea | | in attribute type required |
		in := ea readStream.
		[in atEnd] whileFalse: [
			attribute := self readExpression: in.
			type := self readExpression: in.
			required := self readExpression: in.
			required = '#FIXED' ifTrue: [
				in upTo: $'.
				type := '(' , (in upTo: $') , ')'].
			in skipSeparators.
			list add: (HtmlDTDAttribute new
				attribute: attribute;
				type: type;
				isRequired: required)]].
	^self new tag: tag; attributes: list asArray]

{ #category : #accessing }
HtmlDTDAttrList >> addToAttributes: anAttribute [
	self attributes: (self attributes copyWith: anAttribute)]

{ #category : #accessing }
HtmlDTDAttrList >> attributeNamed: aString [
	| nm |
	nm := aString asLowercase.
	^self attributes detect: [:ea | ea attribute = nm] ifNone: [nil]]

{ #category : #accessing }
HtmlDTDAttrList >> attributes [
	^attributes isNil ifTrue: [attributes := #()] ifFalse: [attributes]]

{ #category : #accessing }
HtmlDTDAttrList >> attributes: anArray [
	attributes := anArray]

{ #category : #testing }
HtmlDTDAttrList >> includesAttribute: anAttribute [
	^(self attributeNamed: anAttribute) notNil]

{ #category : #printing }
HtmlDTDAttrList >> printOn: aStream [
	aStream nextPutAll: '@@'; nextPut: $(.
	tag expression printOn: aStream.
	aStream space.
	self attributes do: [:ea | 
		ea printOn: aStream.
		aStream space].
	aStream nextPut: $)]

{ #category : #accessing }
HtmlDTDAttrList >> requiredAttributes [
	^self attributes select: [:ea | ea isRequired]]

