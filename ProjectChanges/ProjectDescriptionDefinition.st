"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectDescriptionDefinition,
	#superclass : #ProjectChange,
	#instVars : [
		'description'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ProjectDescriptionDefinition >> basicPerform [
	self propertyAt: #prev put: self project description.
	self project description: description]

{ #category : #undo }
ProjectDescriptionDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
ProjectDescriptionDefinition >> changesSomething [
	^self project description != description]

{ #category : #accessing }
ProjectDescriptionDefinition >> currentVersion [
	^self copy description: self project description]

{ #category : #accessing }
ProjectDescriptionDefinition >> description: aString [
	description := aString]

{ #category : #initialization }
ProjectDescriptionDefinition >> initialize [
	super initialize.
	description := '']

{ #category : #'filein/out' }
ProjectDescriptionDefinition >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	description := ast statements first arguments first value]

{ #category : #accessing }
ProjectDescriptionDefinition >> refersTo [
	^{self class. self project name}]

{ #category : #accessing }
ProjectDescriptionDefinition >> resolveClass [
	^nil]

{ #category : #'filein/out' }
ProjectDescriptionDefinition >> sourceCode [
	^'(BeeModule getProject: ' , self projectName storeString , ')'
		, ' description: '
		, description storeString]

{ #category : #undo }
ProjectDescriptionDefinition >> tip [
	^'Project Description → ' , description lines anyone asString]

{ #category : #undo }
ProjectDescriptionDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges description: prev]

