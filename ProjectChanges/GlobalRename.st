"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GlobalRename,
	#superclass : #GlobalChange,
	#instVars : [
		'newName'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
GlobalRename >> addToProject: aBeeModule [
	BeeModule allSimpleProjects
		do: [:p | p global: globalName wasRenamedTo: newName]]

{ #category : #perform }
GlobalRename >> basicPerform [
	| assoc |
	assoc := Smalltalk associationAt: globalName ifAbsent: [^nil].
	^self project renameGlobal: assoc to: newName asSymbol]

{ #category : #testing }
GlobalRename >> canRename [
	^Smalltalk includesKey: globalName asSymbol]

{ #category : #testing }
GlobalRename >> changesSomething [
	^self resolveGlobal notNil]

{ #category : #perform }
GlobalRename >> logsBeforePerform [
	^true]

{ #category : #accessing }
GlobalRename >> newName: aString [
	newName := aString]

{ #category : #accessing }
GlobalRename >> sourceCode [
	^self project referenceString , ' renameGlobal: ' , globalName storeString
		, ' to: '
		, newName storeString]

{ #category : #undo }
GlobalRename >> tip [
	^'Rename ' , globalName , ' → ' , newName]

{ #category : #undo }
GlobalRename >> undo [
	^self projectChanges renameGlobal: newName to: globalName]

