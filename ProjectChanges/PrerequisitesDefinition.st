"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PrerequisitesDefinition,
	#superclass : #ProjectChange,
	#instVars : [
		'prerequisites'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
PrerequisitesDefinition >> basicPerform [
	prerequisites isNil ifTrue: [^self].
	self propertyAt: #prev put: self project prerequisites.
	prerequisites do: [:string | self project addPrerequisite: string]]

{ #category : #undo }
PrerequisitesDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
PrerequisitesDefinition >> changesSomething [
	| project current equal |
	project := self project.
	current := project prerequisites.
	current isNil ifTrue: [current := #()].
	equal := (current collect: #asFilename)
		equalsTo: (prerequisites collect: #asFilename).
	^equal not]

{ #category : #'version support' }
PrerequisitesDefinition >> currentVersion [
	^self copy prerequisites: self project prerequisites]

{ #category : #accessing }
PrerequisitesDefinition >> prerequisites [
	^prerequisites]

{ #category : #accessing }
PrerequisitesDefinition >> prerequisites: aCollection [
	prerequisites := aCollection ifNil: #()]

{ #category : #'filein/out' }
PrerequisitesDefinition >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	prerequisites := ast statements first arguments first value.
	prerequisites isNil ifTrue: [prerequisites := #()]]

{ #category : #accessing }
PrerequisitesDefinition >> refersTo [
	^{self project name}]

{ #category : #'filein/out' }
PrerequisitesDefinition >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: '(BeeModule getProject: ';
			nextPutAll: self projectName storeString;
			nextPutAll: ') prerequisites: ';
			nextPutAll: prerequisites asArray literalString]]

{ #category : #undo }
PrerequisitesDefinition >> tip [
	| string |
	string := prerequisites isNil
		ifTrue: ['']
		ifFalse: [prerequisites phrase: #asString].
	^'Prerequisites → ' , string]

{ #category : #undo }
PrerequisitesDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges prerequisites: prev]

