"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassRename,
	#superclass : #ClassChange,
	#instVars : [
		'newName',
		'renameReferences'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ClassRename >> addToProject: aBeeModule [
	BeeModule allSimpleProjects
		do: [:p | p class: className wasRenamedTo: newName]]

{ #category : #perform }
ClassRename >> basicPerform [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^self].
	self project
		renameClass: class
		to: newName asSymbol
		renameReferences: renameReferences]

{ #category : #testing }
ClassRename >> canPerform [
	^super canPerform and: [self canRename]]

{ #category : #testing }
ClassRename >> canRename [
	^self resolveClass notNil andNot: [Smalltalk includesKey: newName]]

{ #category : #testing }
ClassRename >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [class := BeeModule resolveClass: className].
	class isNil ifTrue: [^true].
	^class name != newName]

{ #category : #initialization }
ClassRename >> initialize [
	super initialize.
	renameReferences := false]

{ #category : #perform }
ClassRename >> logsBeforePerform [
	^true]

{ #category : #accessing }
ClassRename >> newName [
	^newName]

{ #category : #accessing }
ClassRename >> newName: aString [
	newName := aString]

{ #category : #'filein/out' }
ClassRename >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements first.
	newName := statement arguments last value.
	renameReferences := statement selector value == #renameWithReferencesTo:]

{ #category : #accessing }
ClassRename >> refersTo [
	^{self class. className. newName}]

{ #category : #accessing }
ClassRename >> renameReferences: aBoolean [
	renameReferences := aBoolean]

{ #category : #accessing }
ClassRename >> sourceCode [
	| selector |
	selector := renameReferences
		ifTrue: [' renameWithReferencesTo: ']
		ifFalse: [' rename: '].
	^className , selector , newName storeString]

{ #category : #accessing }
ClassRename >> sourcePosition [
	^nil]

{ #category : #undo }
ClassRename >> tip [
	^'Class Rename ' , className , ' → ' , newName]

{ #category : #undo }
ClassRename >> undo [
	^self projectChanges renameClass: newName to: className]

