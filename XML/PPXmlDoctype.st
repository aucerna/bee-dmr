"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlDoctype,
	#superclass : #PPXmlData,
	#category : #XML
}

{ #category : #visiting }
PPXmlDoctype >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlDoctype: self]

{ #category : #testing }
PPXmlDoctype >> isDoctype [
	^true]

