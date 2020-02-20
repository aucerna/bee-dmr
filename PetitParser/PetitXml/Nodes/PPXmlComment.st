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

