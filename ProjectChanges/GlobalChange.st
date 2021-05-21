"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GlobalChange,
	#superclass : #ProjectChange,
	#instVars : [
		'globalName'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
GlobalChange >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	globalName = changeRecord globalName ifFalse: [^false].
	^true]

{ #category : #accessing }
GlobalChange >> classBinding [
	^UndefinedObject]

{ #category : #private }
GlobalChange >> defaultProject [
	| sp assoc |
	sp := super defaultProject.
	sp isDefaultProject ifFalse: [^sp].
	assoc := self resolveGlobal.
	assoc notNil
		ifTrue: [sp := BeeModule allSimpleProjects
			select: [:p | p includesObject: assoc value]].
	^sp size > 0 ifTrue: [sp asArray first] ifFalse: [BeeModule default]]

{ #category : #accessing }
GlobalChange >> globalName [
	^globalName

	]

{ #category : #accessing }
GlobalChange >> globalName: aSymbol [
	globalName := aSymbol

	]

{ #category : #testing }
GlobalChange >> isNewerThanCurrent [
	^self changesSomething]

{ #category : #'filein/out' }
GlobalChange >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	globalName := ast statements first arguments last value]

{ #category : #accessing }
GlobalChange >> refersTo [
	^{self class. globalName}]

{ #category : #accessing }
GlobalChange >> resolveClass [
	^nil]

{ #category : #accessing }
GlobalChange >> resolveGlobal [
	^Smalltalk associationAt: globalName ifAbsent: nil]

