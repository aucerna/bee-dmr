Class {
	#name : #PPXmlParent,
	#superclass : #PPXmlNode,
	#instVars : [
		'#children'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
PPXmlParent class >> children: aCollection [
	^self new children: aCollection
]

{ #category : #comparing }
PPXmlParent >> = anXmlNode [
	self == anXmlNode ifTrue: [^true].
	self class = anXmlNode class ifFalse: [^false].
	children size = anXmlNode children size ifFalse: [^false].
	children
		with: anXmlNode children
		do: [:first :second | first = second ifFalse: [^false]].
	^true
]

{ #category : #'adding / removing' }
PPXmlParent >> addChild: aPPXmlNode [
	| child |
	child := (aPPXmlNode isKindOf: PPXmlNode)
		ifTrue: [aPPXmlNode]
		ifFalse: [PPXmlText new data: aPPXmlNode asString].
	child parent: self.
	^children add: child
]

{ #category : #inquiries }
PPXmlParent >> anyElementNamed: name [
	| elements |
	elements := self elementsNamed: name.
	^elements anyone
]

{ #category : #accessing }
PPXmlParent >> children [
	^children
]

{ #category : #accessing }
PPXmlParent >> children: aCollection [
	children := aCollection.
	children do: [:node | node parent: self]
]

{ #category : #accessing }
PPXmlParent >> childrenNamed: aString [
	^children detect: [:n | n name isLike: aString] ifNone: nil
]

{ #category : #inquiries }
PPXmlParent >> elementsNamed: name [
	| elements |
	elements := OrderedCollection new.
	self
		nodesDo: [:e | (e isElement and: [e name isLike: name])
			ifTrue: [elements add: e]].
	^elements
]

{ #category : #testing }
PPXmlParent >> hasChildren [
	^children size > 0
]

{ #category : #comparing }
PPXmlParent >> hash [
	| hash |
	hash := children size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (children at: i)].
	^hash
]

{ #category : #testing }
PPXmlParent >> hasOnlyText [
	^children size = 1 and: [| child |
		child := children anyone.
		(child isKindOf: PPXmlText) or: [child isKindOf: PPXmlMacro]]
]

{ #category : #initialization }
PPXmlParent >> initialize [
	super initialize.
	children := OrderedCollection new
]

{ #category : #testing }
PPXmlParent >> isEmptyText [
	^false
]

{ #category : #copying }
PPXmlParent >> postCopy [
	super postCopy.
	self children: (children collect: [:node | node copy])
]

{ #category : #'adding / removing' }
PPXmlParent >> removeChild: aPPXmlNode [
	^children remove: aPPXmlNode ifAbsent: nil
]

