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

