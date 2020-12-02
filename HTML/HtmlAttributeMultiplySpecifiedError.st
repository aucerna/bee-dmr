"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlAttributeMultiplySpecifiedError,
	#superclass : #HtmlAttributeError,
	#instVars : [
		'value1',
		'value2'
	],
	#category : #HTML
}

{ #category : #printing }
HtmlAttributeMultiplySpecifiedError >> printOn: aStream [
	self attribute printOn: aStream.
	aStream nextPutAll: ' is specified multiple times in '.
	self parent prefix printOn: aStream.
	aStream nextPutAll: '.']

{ #category : #accessing }
HtmlAttributeMultiplySpecifiedError >> value: v1 value: v2 [
	value1 := v1.
	value2 := v2]

