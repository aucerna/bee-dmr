"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlPaintingVisitor,
	#superclass : #HtmlFormattingVisitor,
	#category : #HTML
}

{ #category : #colors }
HtmlPaintingVisitor >> attributeColor [
	^Color darkBlue]

{ #category : #colors }
HtmlPaintingVisitor >> operatorColor [
	^Color darkBlue]

{ #category : #printing }
HtmlPaintingVisitor >> printAttributeName: aString [
	stream
		useColor: self attributeColor
		while: [super printAttributeName: aString]]

{ #category : #printing }
HtmlPaintingVisitor >> printAttributeValue: aString [
	stream
		useColor: self valueColor
		while: [super printAttributeValue: aString]]

{ #category : #printing }
HtmlPaintingVisitor >> printClosingTagOf: anHtmlElement [
	stream
		useColor: self tagColor
		while: [super printClosingTagOf: anHtmlElement]]

{ #category : #printing }
HtmlPaintingVisitor >> printOpeningTagOf: anHtmlElement [
	stream
		useColor: self tagColor
		while: [super printOpeningTagOf: anHtmlElement]]

{ #category : #printing }
HtmlPaintingVisitor >> printOperator: aCharacter [
	stream
		useColor: self operatorColor
		while: [super printOperator: aCharacter]]

{ #category : #printing }
HtmlPaintingVisitor >> printText: aString [
	stream useColor: self textColor while: [super printText: aString]]

{ #category : #colors }
HtmlPaintingVisitor >> tagColor [
	^Color red: 220 green: 40 blue: 0]

{ #category : #colors }
HtmlPaintingVisitor >> textColor [
	^Color red: 0 green: 128 blue: 192]

{ #category : #colors }
HtmlPaintingVisitor >> valueColor [
	^Color darkGreen]

