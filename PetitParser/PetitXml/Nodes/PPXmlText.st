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

