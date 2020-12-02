"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchEmpty,
	#superclass : #HtmlDTDMatchExpression,
	#classVars : [
		'Empty'
	],
	#category : #HTML
}

{ #category : #'as yet unclassified' }
HtmlDTDMatchEmpty class >> empty [

	^Empty isNil ifTrue: [Empty := self new] ifFalse: [Empty]]

{ #category : #inquiries }
HtmlDTDMatchEmpty >> allowedElements [
	^#()]

{ #category : #testing }
HtmlDTDMatchEmpty >> allowsItem: item [
	^false]

{ #category : #initialization }
HtmlDTDMatchEmpty >> initialize [
	super initialize.
	expression := 'EMPTY']

{ #category : #testing }
HtmlDTDMatchEmpty >> isEmpty [
	^true]

{ #category : #printing }
HtmlDTDMatchEmpty >> printOn: aStream [
	aStream nextPutAll: 'EMPTY']

{ #category : #validation }
HtmlDTDMatchEmpty >> validateChildren: aStream ofNode: aNode [
	^aStream atEnd ifTrue: [true] ifFalse: [
		aNode addError: HtmlTagMustBeEmptyError new.
		false]]

