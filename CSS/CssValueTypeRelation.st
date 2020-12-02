"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValueTypeRelation,
	#superclass : #CssValueType,
	#instVars : [
		'types'
	],
	#category : #CSS
}

{ #category : #accessing }
CssValueTypeRelation >> addType: anObject [
	self types: (self types copyWith: anObject)]

{ #category : #accessing }
CssValueTypeRelation >> operator [
	self subclassResponsibility]

{ #category : #accessing }
CssValueTypeRelation >> types [
	^types isNil ifTrue: [#()] ifFalse: [types]]

{ #category : #accessing }
CssValueTypeRelation >> types: anObject [
	types := anObject]

