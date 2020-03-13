"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlComment,
	#superclass : #PPXmlData,
	#category : #Nodes
}

{ #category : #visiting }
PPXmlComment >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlComment: self
]

{ #category : #testing }
PPXmlComment >> isComment [
	^true
]

