"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlUIBProgressbar,
	#superclass : #HtmlUIBElement,
	#category : #HTML
}

{ #category : #accessing }
HtmlUIBProgressbar >> animate: aString [
	self attributeAt: 'animate' put: aString]

{ #category : #accessing }
HtmlUIBProgressbar >> max: aNumber [
	self attributeAt: 'max' put: aNumber]

{ #category : #accessing }
HtmlUIBProgressbar >> type: aString [
	self attributeAt: 'type' put: aString]

{ #category : #accessing }
HtmlUIBProgressbar >> value: aNumber [
	self attributeAt: 'value' put: aNumber]

