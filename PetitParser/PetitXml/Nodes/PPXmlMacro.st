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

