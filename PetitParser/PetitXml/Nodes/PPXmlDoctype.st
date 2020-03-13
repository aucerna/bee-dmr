"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlDoctype,
	#superclass : #PPXmlData,
	#category : #Nodes
}

{ #category : #visiting }
PPXmlDoctype >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlDoctype: self
]

{ #category : #testing }
PPXmlDoctype >> isDoctype [
	^true
]

