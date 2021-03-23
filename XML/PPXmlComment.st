"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlComment,
	#superclass : #PPXmlData,
	#category : #XML
}

{ #category : #visiting }
PPXmlComment >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlComment: self]

{ #category : #testing }
PPXmlComment >> isComment [
	^true]

