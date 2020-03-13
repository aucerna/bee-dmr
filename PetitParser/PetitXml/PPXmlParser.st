"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlParser,
	#superclass : #PPXmlGrammar,
	#category : #PetitXml
}

{ #category : #'PM support' }
PPXmlParser class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	super aboutToSaveLibraryOn: aCodeSegmentBuilder.
	aCodeSegmentBuilder map: current to: nil
]

{ #category : #initialization }
PPXmlParser class >> current [
	current isNil ifTrue: [self initializeCurrent].
	^current
]

{ #category : #initialization }
PPXmlParser class >> initializeCurrent [
	current := self new
]

{ #category : #parsing }
PPXmlParser class >> parse: aString for: requestor [
	^super parse: aString trimBlanks for: requestor
]

{ #category : #parsing }
PPXmlParser class >> parse: anObject startingAt: aSymbol [
	^aSymbol == self startSymbol
		ifTrue: [self current parse: anObject]
		ifFalse: [super parse: anObject startingAt: aSymbol]
]

{ #category : #grammar }
PPXmlParser >> attribute [
	^super attribute
		==> [:nodes | PPXmlAttribute name: nodes first value: nodes second]
]

{ #category : #grammar }
PPXmlParser >> attributes [
	^super attributes ==> [:nodes | 
		nodes
			inject: OrderedCollection new
			into: [:result :each | result addLast: each; yourself]]
]

{ #category : #'grammar-character' }
PPXmlParser >> characterData [
	^super characterData
		==> [:nodes | nodes trimBlanks isEmpty ifFalse: [PPXmlText data: nodes]]
]

{ #category : #grammar }
PPXmlParser >> comment [
	"
	[15]   	Comment	   ::=   	'<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
	"
	^super comment ==> [:node | PPXmlComment data: node]
]

{ #category : #grammar }
PPXmlParser >> doctype [
	^super doctype ==> [:node | PPXmlDoctype data: node]
]

{ #category : #grammar }
PPXmlParser >> document [
	^super document
		==> [:nodes | PPXmlDocument children: (nodes reject: [:each | each isNil])]
]

{ #category : #grammar }
PPXmlParser >> element [
	^super element ==> [:nodes | 
		element := PPXmlElement
			name: nodes first
			attributes: nodes second
			children: nodes third.
		nodes size > 3 ifTrue: [element stretch: nodes fourth].
		element]
]

{ #category : #'grammar-character' }
PPXmlParser >> macro [
	^super macro ==> [:nodes | PPXmlMacro new name: nodes third]
]

{ #category : #grammar }
PPXmlParser >> processing [
	^super processing
		==> [:nodes | PPXmlProcessing target: nodes first data: nodes second]
]

{ #category : #grammar }
PPXmlParser >> qualified [
	^super qualified ==> [:token | PPXmlName name: token]
]

