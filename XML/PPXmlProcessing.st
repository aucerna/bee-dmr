"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PPXmlProcessing,
	#superclass : #PPXmlData,
	#instVars : [
		'target'
	],
	#category : #XML
}

{ #category : #'instance creation' }
PPXmlProcessing class >> target: target data: data [
	^self new target: target; data: data]

{ #category : #comparing }
PPXmlProcessing >> = anXmlNode [
	^super = anXmlNode and: [self target = anXmlNode target]]

{ #category : #visiting }
PPXmlProcessing >> acceptVisitor: anXmlNodeVisitor [
	anXmlNodeVisitor visitXmlProcessing: self]

{ #category : #comparing }
PPXmlProcessing >> hash [
	^super hash hashWith: self target]

{ #category : #testing }
PPXmlProcessing >> isProcessing [
	^true]

{ #category : #accessing }
PPXmlProcessing >> target [
	^target]

{ #category : #accessing }
PPXmlProcessing >> target: aString [
	target := aString]

