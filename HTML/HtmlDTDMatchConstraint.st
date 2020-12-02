"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlDTDMatchConstraint,
	#superclass : #HtmlDTDMatchExpression,
	#category : #HTML
}

{ #category : #inquiries }
HtmlDTDMatchConstraint >> allowedElements [
	^expression allowedElements]

{ #category : #testing }
HtmlDTDMatchConstraint >> allowsItem: item [
	^expression allowsItem: item]

