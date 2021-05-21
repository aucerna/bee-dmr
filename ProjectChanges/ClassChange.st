"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassChange,
	#superclass : #ProjectChange,
	#instVars : [
		'className'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
ClassChange >> = changeRecord [
	changeRecord class = self class ifFalse: [^false].
	className = changeRecord className ifFalse: [^false].
	^super = changeRecord]

{ #category : #testing }
ClassChange >> canPerform [
	^super canPerform and: [self resolveClass notNil]]

{ #category : #accessing }
ClassChange >> changeForCurrentVersion [
	| c |
	c := self currentVersion.
	^c isNil
		ifTrue: [
			ClassRemoval new
				projectChanges: self projectChanges;
				author: self projectChanges currentUser;
				className: self className;
				yourself]
		ifFalse: [c isSpecies ifTrue: [ClassDefinition fromClass: c] ifFalse: [c]]]

{ #category : #testing }
ClassChange >> changesJustOneClass [
	^true]

{ #category : #accessing }
ClassChange >> classBinding [
	^self resolveClass ifNil: [ClassDefinition new className: className]]

{ #category : #accessing }
ClassChange >> className [
	^className]

{ #category : #accessing }
ClassChange >> className: aString [
	className := aString]

{ #category : #accessing }
ClassChange >> contextClass [
	^self resolveClass ifNil: [UndefinedObject]]

{ #category : #accessing }
ClassChange >> currentVersion [
	| compiler |
	compiler := Compiler silentForClass: UndefinedObject.
	^(compiler evaluate: className)
		ifNotNil: [:result | result isSpecies ifTrue: [result]]]

{ #category : #private }
ClassChange >> defaultProject [
	| p class projects |
	p := projectChanges isString ifTrue: [BeeModule named: projectChanges].
	p notNil ifTrue: [
		projectChanges := p changes.
		^p].
	className ifNil: [^BeeModule default].
	class := BeeModule resolveClass: className.
	projects := BeeModule projectsFor: self selector class: class.
	projects isEmpty ifTrue: [^BeeModule default].
	^projects size = 1 ifTrue: [projects anyone] ifFalse: [BeeModule default]]

{ #category : #comparing }
ClassChange >> hash [
	^self class hashWith: author with: className]

{ #category : #'file in/out' }
ClassChange >> headerSpec [
	| spec |
	spec := super headerSpec.
	spec add: #className.
	^spec]

{ #category : #testing }
ClassChange >> isClassChange [
	^true]

{ #category : #accessing }
ClassChange >> refersTo [
	^{self class. className}]

{ #category : #inquiries }
ClassChange >> refersToClass: aClass [
	^aClass name = className]

{ #category : #accessing }
ClassChange >> resolveClass [
	^(projectChanges isNil or: [projectChanges isString])
		ifTrue: [Smalltalk classNamed: className]
		ifFalse: [self project resolveClass: className]]

{ #category : #printing }
ClassChange >> shortPrintStringOn: aStream [
	aStream
		nextPutAll: self shortClassName;
		nextPut: $-;
		nextPutAll: self className]

