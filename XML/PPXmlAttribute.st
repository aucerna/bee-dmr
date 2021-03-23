"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlAttribute,
	#superclass : #PPXmlNode,
	#instVars : [
		'name',
		'value'
	],
	#category : #XML
}

{ #category : #'instance creation' }
PPXmlAttribute class >> name: aPPXmlName value: aString [
	^self new name: aPPXmlName; value: aString]

{ #category : #comparing }
PPXmlAttribute >> = anXmlNode [
	self == anXmlNode ifTrue: [^true].
	self class = anXmlNode class ifFalse: [^false].
	^self name = anXmlNode name and: [self value = anXmlNode value]]

{ #category : #visiting }
PPXmlAttribute >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlAttribute: self]

{ #category : #comparing }
PPXmlAttribute >> hash [
	^self name hashWith: self value]

{ #category : #testing }
PPXmlAttribute >> isAttribute [
	^true]

{ #category : #accessing }
PPXmlAttribute >> name [
	^name]

{ #category : #accessing }
PPXmlAttribute >> name: aPPXmlName [
	name := aPPXmlName isString
		ifTrue: [PPXmlName name: aPPXmlName]
		ifFalse: [aPPXmlName]]

{ #category : #accessing }
PPXmlAttribute >> value [
	^value]

{ #category : #accessing }
PPXmlAttribute >> value: aString [
	value := aString]

