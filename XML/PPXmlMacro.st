"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlMacro,
	#superclass : #PPXmlData,
	#category : #XML
}

{ #category : #visiting }
PPXmlMacro >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlMacro: self]

{ #category : #accessing }
PPXmlMacro >> argument [
	^data]

{ #category : #accessing }
PPXmlMacro >> name: aString [
	data := aString]

