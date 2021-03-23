"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlText,
	#superclass : #PPXmlData,
	#category : #XML
}

{ #category : #visiting }
PPXmlText >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlText: self]

{ #category : #testing }
PPXmlText >> isEmptyText [
	^data trimBlanks isEmpty]

{ #category : #testing }
PPXmlText >> isText [
	^true]

