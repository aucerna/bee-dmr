Class {
	#name : #XmlFormattingVisitor,
	#superclass : #XmlNodeVisitor,
	#instVars : [
		'stream',
		'indent'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
XmlFormattingVisitor class >> on: aStream [
	^self new on: aStream
]

{ #category : #private }
XmlFormattingVisitor >> cr [
	stream crtab: indent
]

{ #category : #accessing }
XmlFormattingVisitor >> indent: anInteger [
	indent := anInteger
]

{ #category : #initialization }
XmlFormattingVisitor >> initialize [
	super initialize.
	indent := 0
]

{ #category : #accessing }
XmlFormattingVisitor >> on: aStream [
	stream := aStream
]

{ #category : #printing }
XmlFormattingVisitor >> printAttribute: anXmlAttribute [
	self printAttributeName: anXmlAttribute name.
	anXmlAttribute value notNil
		ifTrue: [self
			printOperator: $=;
			printAttributeValue: anXmlAttribute value asString]
]

{ #category : #printing }
XmlFormattingVisitor >> printAttributeName: anXmlName [
	self printName: anXmlName
]

{ #category : #printing }
XmlFormattingVisitor >> printAttributeValue: aString [
	stream nextPutAll: aString doubleQuoted
]

{ #category : #printing }
XmlFormattingVisitor >> printClosingTagOf: anXmlElement [
	(anXmlElement children notEmpty andNot: [anXmlElement hasOnlyText])
		ifTrue: [stream crtab: indent].
	stream nextPutAll: '</' , anXmlElement tag , '>'
]

{ #category : #printing }
XmlFormattingVisitor >> printName: anXmlName [
	stream nextPutAll: anXmlName qualifiedName
]

{ #category : #printing }
XmlFormattingVisitor >> printOpeningTagOf: anXmlElement [
	| attributes n |
	stream nextPut: $<; nextPutAll: anXmlElement tag.
	attributes := anXmlElement attributes.
	n := attributes size.
	n >= 3 ifTrue: [indent := indent + 1].
	attributes do: [:attribute | 
		n > 3 ifTrue: [self cr] ifFalse: [stream space].
		self printAttribute: attribute].
	n >= 3 ifTrue: [indent := indent - 1].
	anXmlElement children isEmpty
		ifTrue: [stream nextPutAll: ' />']
		ifFalse: [stream nextPut: $>]
]

{ #category : #printing }
XmlFormattingVisitor >> printOperator: aCharacter [
	stream nextPut: aCharacter
]

{ #category : #printing }
XmlFormattingVisitor >> printProcessing: anXmlProcessing [
	stream
		nextPutAll: '<?';
		nextPutAll: anXmlProcessing target;
		nextPutAll: anXmlProcessing data;
		nextPutAll: '?>'
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlAttribute: anXmlAttribute [
	self printAttributeName: anXmlAttribute name.
	anXmlAttribute value notNil
		ifTrue: [self
			printOperator: $=;
			printAttributeValue: anXmlAttribute value asString]
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlComment: anXmlComment [
	stream
		nextPutAll: '<!--';
		nextPutAll: anXmlComment data;
		nextPutAll: '-->'
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlDoctype: anXmlDoctype [
	anXmlDoctype
		tab: indent;
		nextPutAll: '<!DOCTYPE';
		nextPutAll: anXmlDoctype data;
		nextPut: $>
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlDocument: anXmlDocument [
	stream tab: indent.
	anXmlDocument children
		do: [:node | self visit: node]
		separatedBy: [self cr]
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlElement: anXmlElement [
	self printOpeningTagOf: anXmlElement.
	anXmlElement children isEmpty ifTrue: [^self].
	indent := indent + 1.
	anXmlElement hasOnlyText ifFalse: [self cr].
	anXmlElement children do: [:node | self visit: node] separatedBy: [self cr].
	indent := indent - 1.
	self printClosingTagOf: anXmlElement
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlMacro: anXmlMacro [
	stream
		nextPutAll: '<@';
		nextPutAll: anXmlMacro data;
		nextPut: $>
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlName: anXmlName [
	self printName: anXmlName
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlProcessing: anXmlProcessing [
	self printProcessing: anXmlProcessing
]

{ #category : #visiting }
XmlFormattingVisitor >> visitXmlText: anXmlText [
	stream nextPutAll: anXmlText data
]

