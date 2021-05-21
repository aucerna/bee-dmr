"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassVariableMoveDown,
	#superclass : #ClassVariableChange,
	#instVars : [
		'target'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
ClassVariableMoveDown >> basicPerform [
	self project
		moveDownClassVar: variable
		of: self resolveClass
		to: self targetClass]

{ #category : #undo }
ClassVariableMoveDown >> canUndo [
	^target isString and: [super canUndo]]

{ #category : #testing }
ClassVariableMoveDown >> changesJustOneClass [
	^false]

{ #category : #testing }
ClassVariableMoveDown >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^true].
	^class classVarNames includes: variable]

{ #category : #'filein/out' }
ClassVariableMoveDown >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements first.
	variable := statement arguments first value.
	target := statement arguments last value]

{ #category : #'filein/out' }
ClassVariableMoveDown >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' moveDownClassVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' of: ';
			nextPutAll: className;
			nextPutAll: ' to: ';
			nextPutAll: target]]

{ #category : #accessing }
ClassVariableMoveDown >> target: aString [
	target := aString]

{ #category : #accessing }
ClassVariableMoveDown >> targetClass [
	^self targetClassOf: target]

{ #category : #accessing }
ClassVariableMoveDown >> targetClasses [
	^target collect: [:t | self targetClassOf: t]]

{ #category : #undo }
ClassVariableMoveDown >> tip [
	^'Move ' , variable , ' to ' , self targetClass name]

{ #category : #undo }
ClassVariableMoveDown >> undo [
	^target isString
		ifTrue: [self projectChanges moveUpClassVar: variable of: self targetClass]]

