"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlElement,
	#superclass : #PPXmlParent,
	#instVars : [
		'name',
		'attributes',
		'stretch'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
PPXmlElement class >> name: aPPXmlName [
	^self new name: aPPXmlName
]

{ #category : #'instance creation' }
PPXmlElement class >> name: aPPXmlName attributes: attributes children: children [
	^self new
		name: aPPXmlName;
		attributes: attributes;
		children: children
]

{ #category : #'instance creation' }
PPXmlElement class >> name: aPPXmlName children: children [
	^self new name: aPPXmlName; children: children
]

{ #category : #comparing }
PPXmlElement >> = anXmlNode [
	super = anXmlNode ifFalse: [^false].
	self name = anXmlNode name ifFalse: [^false].
	self attributes size = anXmlNode attributes size ifFalse: [^false].
	self attributes
		with: anXmlNode attributes
		do: [:first :second | first = second ifFalse: [^false]].
	^true
]

{ #category : #visiting }
PPXmlElement >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlElement: self
]

{ #category : #'accessing-attributes' }
PPXmlElement >> attributeAt: aString [
	^self attributeAt: aString ifAbsent: nil
]

{ #category : #'accessing-attributes' }
PPXmlElement >> attributeAt: aString ifAbsent: aBlock [
	attributes do: [:s | s name localName = aString ifTrue: [^s value]].
	^aBlock value
]

{ #category : #'accessing-attributes' }
PPXmlElement >> attributeAt: aString put: anObject [
	| attribute |
	attribute := self attributeAt: aString ifAbsent: nil.
	attribute isNil
		ifTrue: [
			attribute := PPXmlAttribute name: aString value: anObject.
			attributes add: attribute]
		ifFalse: [attribute value: anObject]
]

{ #category : #accessing }
PPXmlElement >> attributes [
	^attributes
]

{ #category : #accessing }
PPXmlElement >> attributes: aCollection [
	attributes := aCollection.
	attributes do: [:attribute | attribute parent: self]
]

{ #category : #comparing }
PPXmlElement >> hash [
	^super hash hashWith: self name
]

{ #category : #initialization }
PPXmlElement >> initialize [
	super initialize.
	attributes := OrderedCollection new
]

{ #category : #testing }
PPXmlElement >> isElement [
	^true
]

{ #category : #accessing }
PPXmlElement >> name [
	^name
]

{ #category : #accessing }
PPXmlElement >> name: aPPXmlName [
	name := aPPXmlName isString
		ifTrue: [PPXmlName name: aPPXmlName]
		ifFalse: [aPPXmlName]
]

{ #category : #copying }
PPXmlElement >> postCopy [
	super postCopy.
	self attributes: (attributes collect: [:attribute | attribute copy])
]

{ #category : #accessing }
PPXmlElement >> stretch [
	^stretch
]

{ #category : #accessing }
PPXmlElement >> stretch: aStretch [
	stretch := aStretch
]

{ #category : #accessing }
PPXmlElement >> tag [
	^name qualifiedName
]

