"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableMoveDown,
	#superclass : #InstanceVariableChange,
	#instVars : [
		'target'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
InstanceVariableMoveDown >> basicPerform [
	| cls |
	cls := self resolveClass.
	target isString
		ifTrue: [self project
			moveDownInstVar: variable
			of: cls
			to: self targetClass]
		ifFalse: [self project
			moveDownInstVar: variable
			of: cls
			toAll: self targetClasses].
	^cls]

{ #category : #testing }
InstanceVariableMoveDown >> canUndo [
	^target isString and: [super canUndo]]

{ #category : #private }
InstanceVariableMoveDown >> changeClassFor: aClass [
	(self targetClasses includes: aClass) ifTrue: [^ClassRedefinition].
	^super changeClassFor: aClass]

{ #category : #testing }
InstanceVariableMoveDown >> changesJustOneClass [
	^false]

{ #category : #testing }
InstanceVariableMoveDown >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^true].
	^class instVarNames includes: variable]

{ #category : #'filein/out' }
InstanceVariableMoveDown >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements first.
	variable := statement arguments first value.
	target := statement arguments last value]

{ #category : #'filein/out' }
InstanceVariableMoveDown >> sourceCode [
	^String streamContents: [:strm | | to |
		to := target isString ifTrue: [' to: '] ifFalse: [' toAll: '].
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' moveDownInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' of: ';
			nextPutAll: className;
			nextPutAll: to;
			nextPutAll: target]]

{ #category : #accessing }
InstanceVariableMoveDown >> target: literal [
	target := literal]

{ #category : #accessing }
InstanceVariableMoveDown >> targetClass [
	^self targetClassOf: target]

{ #category : #accessing }
InstanceVariableMoveDown >> targetClasses [
	^target isString
		ifTrue: [{self targetClass}]
		ifFalse: [target collect: [:t | self targetClassOf: t]]]

{ #category : #perform }
InstanceVariableMoveDown >> tip [
	| destination |
	destination := target isString
		ifTrue: [target]
		ifFalse: [target phrase: #asString].
	^'Move ' , variable , ' to ' , destination]

{ #category : #undo }
InstanceVariableMoveDown >> undo [
	target isString
		ifTrue: [self projectChanges moveUpInstVar: variable of: self targetClass]]

