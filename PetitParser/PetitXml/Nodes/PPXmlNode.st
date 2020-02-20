Class {
	#name : #PPXmlNode,
	#superclass : #Object,
	#instVars : [
		'#parent'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
PPXmlNode class >> new [
	^super new initialize
]

{ #category : #visiting }
PPXmlNode >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlNode: self
]

{ #category : #accessing }
PPXmlNode >> attributes [
	^#()
]

{ #category : #accessing }
PPXmlNode >> children [
	^#()
]

{ #category : #inquiries }
PPXmlNode >> contentString [
	^self hasOnlyText ifTrue: [self firstChild contentString] ifFalse: ['']
]

{ #category : #accessing }
PPXmlNode >> document [
	^parent isNil ifFalse: [parent document]
]

{ #category : #inquiries }
PPXmlNode >> elements [
	| elements |
	elements := OrderedCollection new.
	self elementsDo: [:e | elements add: e].
	^elements
]

{ #category : #enumerating }
PPXmlNode >> elementsDo: aBlock [
	self children select: [:node | node isElement] thenDo: aBlock
]

{ #category : #services }
PPXmlNode >> externalVariables [
	| vars |
	vars := Set new.
	self
		nodesDo: [:n | (n isKindOf: PPXmlMacro) ifTrue: [vars add: n argument]].
	^vars
]

{ #category : #inquiries }
PPXmlNode >> firstChild [
	^self children isEmpty ifFalse: [self children first]
]

{ #category : #'foreign node support' }
PPXmlNode >> format [
	^self asText asString
]

{ #category : #testing }
PPXmlNode >> hasOnlyText [
	^self children size = 1 and: [self firstChild isKindOf: PPXmlText]
]

{ #category : #testing }
PPXmlNode >> isAttribute [
	^false
]

{ #category : #testing }
PPXmlNode >> isComment [
	^false
]

{ #category : #testing }
PPXmlNode >> isDoctype [
	^false
]

{ #category : #testing }
PPXmlNode >> isDocument [
	^false
]

{ #category : #testing }
PPXmlNode >> isElement [
	^false
]

{ #category : #testing }
PPXmlNode >> isProcessing [
	^false
]

{ #category : #testing }
PPXmlNode >> isText [
	^false
]

{ #category : #inquiries }
PPXmlNode >> lastChild [
	^self children isEmpty ifFalse: [self children last]
]

{ #category : #'foreign node support' }
PPXmlNode >> literals [
	^#()
]

{ #category : #inquiries }
PPXmlNode >> nextSibling [
	| index children |
	parent isNil ifTrue: [^nil].
	children := parent children.
	index := children identityIndexOf: self ifAbsent: [^nil].
	^children at: index + 1 ifAbsent: [nil]
]

{ #category : #enumerating }
PPXmlNode >> nodesDo: aBlock [
	aBlock value: self.
	self attributes do: [:each | each nodesDo: aBlock].
	self children do: [:each | each nodesDo: aBlock]
]

{ #category : #enumerating }
PPXmlNode >> nodesDo: aBlock endWith: anotherBlock [
	aBlock value: self.
	self attributes do: [:a | a nodesDo: aBlock endWith: anotherBlock].
	self children do: [:n | n nodesDo: aBlock endWith: anotherBlock].
	anotherBlock evaluateWith: self
]

{ #category : #accessing }
PPXmlNode >> parent [
	^parent
]

{ #category : #accessing }
PPXmlNode >> parent: node [
	parent := node
]

{ #category : #copying }
PPXmlNode >> postCopy [
	super postCopy.
	parent := nil
]

{ #category : #inquiries }
PPXmlNode >> previousSibling [
	| index children |
	parent isNil ifTrue: [^nil].
	children := parent children.
	index := children identityIndexOf: self ifAbsent: [^nil].
	index = 1 ifTrue: [^nil].
	^children at: index - 1 ifAbsent: []
]

{ #category : #printing }
PPXmlNode >> printOn: aStream [
	self printOn: aStream indent: 0
]

{ #category : #printing }
PPXmlNode >> printOn: aStream indent: anInteger [
	| visitor |
	visitor := XmlFormattingVisitor on: aStream.
	visitor indent: anInteger; visit: self
]

{ #category : #printing }
PPXmlNode >> printTextOn: rtf [
	self printTextOn: rtf indent: 0
]

{ #category : #printing }
PPXmlNode >> printTextOn: rtf indent: anInteger [
	| visitor |
	visitor := XmlPaintingVisitor on: rtf.
	visitor indent: anInteger; visit: self
]

{ #category : #printing }
PPXmlNode >> printXmlOn: aStream [
	self printOn: aStream indent: 0
]

{ #category : #inquiries }
PPXmlNode >> root [
	^parent isNil ifTrue: [self] ifFalse: [parent root]
]

{ #category : #'foreign node support' }
PPXmlNode >> selectors [
	^#()
]

