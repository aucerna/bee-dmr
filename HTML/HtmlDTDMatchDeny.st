"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchDeny,
	#superclass : #HtmlDTDMatchExpression,
	#category : #HTML
}

{ #category : #'as yet unclassified' }
HtmlDTDMatchDeny class >> on: anObject [
	| in |
	in := anObject readStream.
	in next = $-
		ifFalse: [self error: 'HtmlDTDMatchDeny called with invalid stream state'].
	^self new expression: (HtmlDTDMatchExpression on: in)]

{ #category : #inquiries }
HtmlDTDMatchDeny >> allowedElements [
	^#()]

{ #category : #testing }
HtmlDTDMatchDeny >> allowsItem: item [
	^(self expression allowsItem: item) not]

{ #category : #printing }
HtmlDTDMatchDeny >> printOn: aStream [
	aStream nextPut: $-.
	expression printOn: aStream]

{ #category : #validation }
HtmlDTDMatchDeny >> validateChildren: aStream ofNode: aNode [
	^(expression validateChildren: aStream ofNode: aNode) not]

