Class {
	#name : #PPXmlName,
	#superclass : #PPXmlNode,
	#instVars : [
		'#prefix',
		'#local',
		'#uri'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
PPXmlName class >> name: aString [
	^self name: aString uri: nil
]

{ #category : #'instance creation' }
PPXmlName class >> name: aString uri: anUrl [
	^self new initializeName: aString uri: anUrl
]

{ #category : #comparing }
PPXmlName >> = anXmlName [
	self == anXmlName ifTrue: [^true].
	self class = anXmlName class ifFalse: [^false].
	^self namespacePrefix = anXmlName namespacePrefix
		and: [self localName = anXmlName localName]
]

{ #category : #visiting }
PPXmlName >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlName: self
]

{ #category : #comparing }
PPXmlName >> hash [
	^self namespacePrefix hashWith: self localName
]

{ #category : #initialization }
PPXmlName >> initializeName: aString uri: anUrl [
	| index |
	(index := aString indexOf: $:) = 0
		ifTrue: [
			prefix := nil.
			local := aString]
		ifFalse: [
			prefix := aString copyFrom: 1 to: index - 1.
			local := aString copyFrom: index + 1 to: aString size].
	uri := anUrl
]

{ #category : #comparing }
PPXmlName >> isLike: name [
	name isSymbol ifTrue: [^local = name asString].
	^name isString
		ifTrue: [prefix isEmptyOrNil and: [local = name]]
		ifFalse: [self = name]
]

{ #category : #accessing }
PPXmlName >> localName [
	^local
]

{ #category : #accessing }
PPXmlName >> namespacePrefix [
	^prefix
]

{ #category : #inquiries }
PPXmlName >> qualifiedName [
	^String streamContents: [:strm | 
		prefix notNil ifTrue: [strm nextPutAll: prefix; nextPut: $:].
		strm nextPutAll: local]
]

{ #category : #accessing }
PPXmlName >> uri [
	^uri
]

