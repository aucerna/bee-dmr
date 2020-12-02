"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlSelectElement,
	#superclass : #HtmlElement,
	#category : #HTML
}

{ #category : #'adding/removing' }
HtmlSelectElement >> addOption: value [
	| option |
	option := HtmlOptionElement new value: value.
	^self add: option]

{ #category : #'adding/removing' }
HtmlSelectElement >> addOption: value label: label [
	^self addOption: value; label: label]

{ #category : #'adding/removing' }
HtmlSelectElement >> addOption: value with: anHtmlElement [
	| option |
	option := self addOption: value.
	option with: anHtmlElement.
	^option]

{ #category : #attributes }
HtmlSelectElement >> name: aString [
	self attributeAt: 'name' put: aString]

{ #category : #attributes }
HtmlSelectElement >> readonly [
	self attributeAt: 'readonly' put: nil]

{ #category : #accessing }
HtmlSelectElement >> required [
	self attributeAt: 'required' put: nil]

