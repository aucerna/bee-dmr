"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #XmlPaintingVisitor,
	#superclass : #XmlFormattingVisitor,
	#category : #XML
}

{ #category : #colors }
XmlPaintingVisitor >> attributeColor [
	true ifTrue: [^Color red: 220 green: 40 blue: 0].
	^Color red: 0 green: 70 blue: 35]

{ #category : #colors }
XmlPaintingVisitor >> macroColor [
	^RGBColor darkRed]

{ #category : #colors }
XmlPaintingVisitor >> operatorColor [
	^Color black]

{ #category : #printing }
XmlPaintingVisitor >> printAttributeName: anXmlName [
	stream
		useColor: self attributeColor
		while: [super printAttributeName: anXmlName]]

{ #category : #printing }
XmlPaintingVisitor >> printAttributeValue: aString [
	stream
		useColor: self valueColor
		while: [super printAttributeValue: aString]]

{ #category : #printing }
XmlPaintingVisitor >> printClosingTagOf: anHtmlElement [
	stream
		useColor: self tagColor
		while: [super printClosingTagOf: anHtmlElement]]

{ #category : #printing }
XmlPaintingVisitor >> printOpeningTagOf: anHtmlElement [
	stream
		useColor: self tagColor
		while: [super printOpeningTagOf: anHtmlElement]]

{ #category : #printing }
XmlPaintingVisitor >> printOperator: aCharacter [
	stream
		useColor: self operatorColor
		while: [super printOperator: aCharacter]]

{ #category : #printing }
XmlPaintingVisitor >> printProcessing: anXmlProcessing [
	stream
		useColor: self textColor
		while: [super printProcessing: anXmlProcessing]]

{ #category : #colors }
XmlPaintingVisitor >> tagColor [
	^Color red: 0 green: 70 blue: 35]

{ #category : #colors }
XmlPaintingVisitor >> textColor [
	true ifTrue: [^self valueColor].
	^Color red: 220 green: 40 blue: 0]

{ #category : #colors }
XmlPaintingVisitor >> valueColor [
	^Color red: 0 green: 128 blue: 192]

{ #category : #visiting }
XmlPaintingVisitor >> visitXmlMacro: anXmlMacro [
	stream useColor: self macroColor while: [super visitXmlMacro: anXmlMacro]]

{ #category : #visiting }
XmlPaintingVisitor >> visitXmlText: anXmlText [
	stream useColor: self textColor while: [super visitXmlText: anXmlText]]

