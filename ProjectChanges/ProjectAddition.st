"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ProjectAddition,
	#superclass : #ClusterChange,
	#instVars : [
		'next'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
ProjectAddition >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	next = changeRecord nextProjectName ifFalse: [^false].
	^true]

{ #category : #perform }
ProjectAddition >> basicPerform [
	| project p |
	p := self resolveProject.
	p isNil ifTrue: [
		('WARNING: Project ' , childProject , ' not found') print.
		^self].
	project := self resolveNextProject.
	project isNil
		ifTrue: [self project add: p]
		ifFalse: [self project add: p before: project]]

{ #category : #testing }
ProjectAddition >> changesSomething [
	self isProjectLoaded ifFalse: [^true].
	^super changesSomething]

{ #category : #accessing }
ProjectAddition >> nextProjectName [
	^next]

{ #category : #accessing }
ProjectAddition >> nextProjectName: aString [
	next := aString]

{ #category : #'filein/out' }
ProjectAddition >> readFrom: aStream [
	| ast msg |
	ast := self parse: aStream nextChunk.
	msg := ast statements first.
	childProject := msg arguments first value.
	next := msg arguments size = 2 ifTrue: [(msg arguments at: 2) value]]

{ #category : #accessing }
ProjectAddition >> refersTo [
	^next isNil
		ifTrue: [{self class. childProject}]
		ifFalse: [{self class. childProject. next}]]

{ #category : #accessing }
ProjectAddition >> resolveNextProject [
	^next notNil ifTrue: [BeeModule getProject: next]]

{ #category : #accessing }
ProjectAddition >> sourceCode [
	| source |
	source := self project referenceString , ' add: ' , childProject storeString.
	next notNil ifTrue: [source := source , ' before: ' , next storeString].
	^source]

{ #category : #undo }
ProjectAddition >> undo [
	^self projectChanges forgetProject: self resolveProject]

