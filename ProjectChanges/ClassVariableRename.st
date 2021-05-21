"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassVariableRename,
	#superclass : #ClassVariableChange,
	#instVars : [
		'new'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ClassVariableRename >> basicPerform [
	self projectChanges
		ignore: #addChange:
		while: [self project
			renameClassVar: variable
			of: self resolveClass
			to: new]]

{ #category : #testing }
ClassVariableRename >> canPerform [
	^super canPerform and: [self canRename]]

{ #category : #testing }
ClassVariableRename >> canRename [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^false].
	(class classVarNames includes: variable) ifFalse: [^false].
	(class allClassVarNames includes: new) ifTrue: [^false].
	(class allSubclasses anySatisfy: [:c | c classVarNames includes: new])
		ifTrue: [^false].
	^true]

{ #category : #testing }
ClassVariableRename >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^false].
	^class classVarNames includes: variable]

{ #category : #perform }
ClassVariableRename >> logsBeforePerform [
	^true]

{ #category : #accessing }
ClassVariableRename >> newName: aString [
	new := aString]

{ #category : #'filein/out' }
ClassVariableRename >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements first.
	variable := statement arguments first value.
	new := statement arguments third value]

{ #category : #accessing }
ClassVariableRename >> sourceCode [
	^self project referenceString , '  renameClassVar: ' , variable storeString
		, ' of: '
		, className
		, ' to: '
		, new storeString]

{ #category : #undo }
ClassVariableRename >> tip [
	^'Rename ' , variable , ' → ' , new]

{ #category : #undo }
ClassVariableRename >> undo [
	^self projectChanges renameClassVar: new of: self resolveClass to: variable]

