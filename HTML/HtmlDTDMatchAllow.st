"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchAllow,
	#superclass : #HtmlDTDMatchExpression,
	#category : #HTML
}

{ #category : #'instance creation' }
HtmlDTDMatchAllow class >> on: anObject [
	| in |
	in := anObject readStream.
	in next = $+
		ifFalse: [self error: 'HtmlDTDMatchDeny called with invalid stream state'].
	^self new expression: (HtmlDTDMatchExpression on: in)]

{ #category : #inquiries }
HtmlDTDMatchAllow >> allowedElements [
	^expression allowedElements]

{ #category : #testing }
HtmlDTDMatchAllow >> allowsItem: item [
	^self expression allowsItem: item]

{ #category : #printing }
HtmlDTDMatchAllow >> printOn: aStream [
	aStream nextPut: $+.
	expression printOn: aStream]

{ #category : #validation }
HtmlDTDMatchAllow >> validateChildren: aStream ofNode: aNode [
	^expression validateChildren: aStream ofNode: aNode]

