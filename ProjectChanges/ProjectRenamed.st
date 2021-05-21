"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectRenamed,
	#superclass : #ClusterChange,
	#instVars : [
		'newName'
	],
	#category : #ProjectChanges
}

{ #category : #testing }
ProjectRenamed >> changesSomething [
	^(self project includes: (BeeModule named: childProject))
		andNot: [(BeeModule named: newName) isNil]]

{ #category : #testing }
ProjectRenamed >> isUserChange [
	^false]

{ #category : #accessing }
ProjectRenamed >> newName [
	^newName]

{ #category : #accessing }
ProjectRenamed >> newName: aString [
	newName := aString]

{ #category : #'filein/out' }
ProjectRenamed >> readFrom: aStream [
	| mssg ast |
	ast := self parse: aStream nextChunk.
	mssg := ast statements first.
	childProject := mssg arguments first value.
	newName := mssg arguments last value]

{ #category : #accessing }
ProjectRenamed >> resolveProject [
	^super resolveProject ifNil: [BeeModule named: newName]]

{ #category : #accessing }
ProjectRenamed >> sourceCode [
	^'(BeeModule named: ' , self project name storeString , ') module: '
		, childProject storeString
		, ' wasRenamedTo: '
		, newName storeString]

{ #category : #undo }
ProjectRenamed >> undo [
	| p |
	p := BeeModule named: newName.
	^self projectChanges project: p renamedTo: childProject]

