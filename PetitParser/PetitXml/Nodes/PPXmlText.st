"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlText,
	#superclass : #PPXmlData,
	#category : #Nodes
}

{ #category : #visiting }
PPXmlText >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlText: self
]

{ #category : #testing }
PPXmlText >> isEmptyText [
	^data trimBlanks isEmpty
]

{ #category : #testing }
PPXmlText >> isText [
	^true
]

