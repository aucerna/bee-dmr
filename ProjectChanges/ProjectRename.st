"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectRename,
	#superclass : #ProjectChange,
	#instVars : [
		'newName',
		'oldName'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ProjectRename >> basicPerform [
	(BeeModule exists: newName)
		ifTrue: [ModuleAlreadyExistsException signalOn: newName].
	oldName := self project name.
	^self project rename: newName]

{ #category : #testing }
ProjectRename >> changesSomething [
	| project |
	(project := BeeModule named: newName) isNil ifTrue: [^true].
	^project name != newName]

{ #category : #accessing }
ProjectRename >> newName [
	^newName]

{ #category : #accessing }
ProjectRename >> newName: aString [
	newName := aString]

{ #category : #accessing }
ProjectRename >> oldName [
	^oldName]

{ #category : #perform }
ProjectRename >> perform [
	| p |
	p := super perform.
	p notNil
		ifTrue: [p clusters do: [:c | c changes project: p renamedTo: newName]]]

{ #category : #'file in/out' }
ProjectRename >> readFrom: aStream [
	| mssg ast |
	ast := self parse: aStream nextChunk.
	mssg := ast statements first.
	newName := mssg arguments last value]

{ #category : #accessing }
ProjectRename >> resolveProject [
	^super resolveProject ifNil: [BeeModule named: newName]]

{ #category : #accessing }
ProjectRename >> sourceCode [
	^'(BeeModule named: ' , self projectName storeString , ') rename: '
		, newName storeString]

{ #category : #undo }
ProjectRename >> tip [
	^'Rename project ' , oldName , ' → ' , newName]

{ #category : #undo }
ProjectRename >> undo [
	^self projectChanges renameProject: newName to: oldName]

