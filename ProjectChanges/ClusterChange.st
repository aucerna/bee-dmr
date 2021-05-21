"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClusterChange,
	#superclass : #ProjectChange,
	#instVars : [
		'childProject'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
ClusterChange >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	childProject = changeRecord childProject ifFalse: [^false].
	^true]

{ #category : #perform }
ClusterChange >> basicPerform [
	| p |
	p := self resolveProject.
	self project add: p.
	^p]

{ #category : #testing }
ClusterChange >> changesSomething [
	| p |
	p := BeeModule named: childProject.
	^p isNil or: [(self project includes: p) not]]

{ #category : #accessing }
ClusterChange >> childProject [
	^childProject]

{ #category : #accessing }
ClusterChange >> childProject: aString [
	childProject := aString]

{ #category : #accessing }
ClusterChange >> classBinding [
	^UndefinedObject]

{ #category : #private }
ClusterChange >> defaultProject [
	| p |
	p := projectChanges isString ifTrue: [BeeModule named: projectChanges].
	p notNil ifTrue: [projectChanges := p changes].
	^p ifNil: [BeeModule default]]

{ #category : #'file in/out' }
ClusterChange >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	childProject := ast statements first arguments last value]

{ #category : #accessing }
ClusterChange >> refersTo [
	^{self class. childProject}]

{ #category : #accessing }
ClusterChange >> resolveClass [
	^nil]

{ #category : #accessing }
ClusterChange >> resolveProject [
	^BeeModule getProject: childProject]

{ #category : #accessing }
ClusterChange >> sourceCode [
	^self project referenceString , ' add: ' , childProject storeString]

{ #category : #undo }
ClusterChange >> undo [
	^self projectChanges forgetProject: self resolveProject]

