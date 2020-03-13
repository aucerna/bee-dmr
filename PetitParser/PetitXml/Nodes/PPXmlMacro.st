"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlMacro,
	#superclass : #PPXmlData,
	#category : #Nodes
}

{ #category : #visiting }
PPXmlMacro >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlMacro: self
]

{ #category : #accessing }
PPXmlMacro >> argument [
	^data
]

{ #category : #accessing }
PPXmlMacro >> name: aString [
	data := aString
]

