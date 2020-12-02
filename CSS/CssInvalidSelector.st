"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssInvalidSelector,
	#superclass : #CssSelector,
	#instVars : [
		'selectorString'
	],
	#category : #CSS
}

{ #category : #testing }
CssInvalidSelector >> isValid [
	^false]

{ #category : #printing }
CssInvalidSelector >> printOn: aStream [
	aStream nextPutAll: 'INVALID: '; nextPutAll: self selectorString]

{ #category : #accessing }
CssInvalidSelector >> selectorString [
	^selectorString]

{ #category : #accessing }
CssInvalidSelector >> selectorString: anObject [
	selectorString := anObject]

