"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDAttribute,
	#superclass : #HtmlDTDConstruct,
	#instVars : [
		'attribute',
		'type',
		'isRequired'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlDTDAttribute >> allowsValue: aValue [
	self type isNil ifTrue: [^true].
	^self type isEnumeration
		ifFalse: [true]
		ifTrue: [self type allowsItem: aValue]]

{ #category : #accessing }
HtmlDTDAttribute >> attribute [
	^attribute]

{ #category : #accessing }
HtmlDTDAttribute >> attribute: anObject [
	attribute := anObject]

{ #category : #accessing }
HtmlDTDAttribute >> isRequired [
	^isRequired = '#REQUIRED']

{ #category : #accessing }
HtmlDTDAttribute >> isRequired: anObject [
	isRequired := anObject]

{ #category : #printing }
HtmlDTDAttribute >> printOn: aStream [
	aStream nextPut: $@; nextPut: $(.
	attribute printOn: aStream.
	aStream space.
	type printOn: aStream.
	aStream space.
	isRequired printOn: aStream.
	aStream nextPut: $)]

{ #category : #accessing }
HtmlDTDAttribute >> type [
	^type]

{ #category : #accessing }
HtmlDTDAttribute >> type: anObject [
	type := HtmlDTDMatchExpression on: anObject]

