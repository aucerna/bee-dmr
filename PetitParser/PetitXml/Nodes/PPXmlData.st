"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPXmlData,
	#superclass : #PPXmlNode,
	#instVars : [
		'data'
	],
	#category : #Nodes
}

{ #category : #'instance creation' }
PPXmlData class >> data: aString [
	^self new data: aString
]

{ #category : #comparing }
PPXmlData >> = anXmlNode [
	self == anXmlNode ifTrue: [^true].
	self class = anXmlNode class ifFalse: [^false].
	^self data = anXmlNode data
]

{ #category : #inquiries }
PPXmlData >> contentString [
	^data
]

{ #category : #accessing }
PPXmlData >> data [
	^data
]

{ #category : #accessing }
PPXmlData >> data: aString [
	data := aString
]

{ #category : #comparing }
PPXmlData >> hash [
	^self data hash
]

{ #category : #testing }
PPXmlData >> isEmptyText [
	^false
]

