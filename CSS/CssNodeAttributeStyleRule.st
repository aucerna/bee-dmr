"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssNodeAttributeStyleRule,
	#superclass : #CssStyleRule,
	#instVars : [
		'content'
	],
	#category : #CSS
}

{ #category : #accessing }
CssNodeAttributeStyleRule >> content [
	^content]

{ #category : #accessing }
CssNodeAttributeStyleRule >> content: aString [
	content := '[style="' , aString , '"]{' , aString , '}'.
	self
		start: 1;
		end: content size;
		parseContents: content readStream]

{ #category : #printing }
CssNodeAttributeStyleRule >> printOn: aStream [
	aStream nextPutAll: self content]

