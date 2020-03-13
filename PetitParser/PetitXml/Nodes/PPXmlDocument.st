"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlDocument,
	#superclass : #PPXmlParent,
	#category : #Nodes
}

{ #category : #visiting }
PPXmlDocument >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlDocument: self
]

{ #category : #accessing }
PPXmlDocument >> document [
	^self
]

{ #category : #'accessing-dom' }
PPXmlDocument >> firstContentChild [
	| element |
	element := self children isEmpty ifFalse: [self children first].
	[element notNil and: [element isProcessing]]
		whileTrue: [element := element nextSibling].
	^element
]

{ #category : #testing }
PPXmlDocument >> isDocument [
	^true
]

{ #category : #accessing }
PPXmlDocument >> name [
	^self firstContentChild name
]

{ #category : #accessing }
PPXmlDocument >> rootElement [
	^self children detect: [:node | node isElement] ifNone: nil
]

{ #category : #visiting }
PPXmlDocument >> variableNodeAt: index [
	^nil
]

