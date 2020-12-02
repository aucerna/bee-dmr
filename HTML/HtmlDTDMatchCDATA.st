"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchCDATA,
	#superclass : #HtmlDTDMatchExpression,
	#classVars : [
		'CData'
	],
	#category : #HTML
}

{ #category : #accessing }
HtmlDTDMatchCDATA class >> cdata [
	^CData isNil ifTrue: [CData := self new] ifFalse: [CData]]

{ #category : #inquiries }
HtmlDTDMatchCDATA >> allowedElements [
	^#()]

{ #category : #testing }
HtmlDTDMatchCDATA >> allowsItem: item [
	^(item asUppercase indexOfString: 'CDATA') > 0]

{ #category : #initialization }
HtmlDTDMatchCDATA >> initialize [
	super initialize.
	expression := '#CDATA']

{ #category : #printing }
HtmlDTDMatchCDATA >> printOn: aStream [
	aStream nextPutAll: expression]

{ #category : #validation }
HtmlDTDMatchCDATA >> validateChildren: aStream ofNode: aNode [
	^(aStream atEnd not and: [self allowsItem: aStream peek dtdTag])
		ifTrue: [
			aStream next.
			true]
		ifFalse: [false]]

