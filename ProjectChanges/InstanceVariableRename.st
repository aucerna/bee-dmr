"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableRename,
	#superclass : #InstanceVariableChange,
	#instVars : [
		'newName'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
InstanceVariableRename >> basicPerform [
	| cls |
	cls := self resolveClass.
	self project renameInstVar: variable of: cls to: newName.
	self logClassRedefinition: cls.
	^cls]

{ #category : #testing }
InstanceVariableRename >> canPerform [
	^super canPerform and: [self canRename]]

{ #category : #testing }
InstanceVariableRename >> canRename [
	| class |
	class := self resolveClass ifNil: [^false].
	(class instVarNames includes: variable) ifFalse: [^false].
	(class allInstVarNames includes: newName) ifTrue: [^false].
	(class allSubclasses anySatisfy: [:c | c instVarNames includes: newName])
		ifTrue: [^false].
	^true]

{ #category : #accessing }
InstanceVariableRename >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^false].
	^class instVarNames includes: variable]

{ #category : #perform }
InstanceVariableRename >> logsBeforePerform [
	^true]

{ #category : #accessing }
InstanceVariableRename >> newName: aString [
	newName := aString]

{ #category : #'filein/out' }
InstanceVariableRename >> readFrom: aStream [
	| ast statement |
	ast := self parse: aStream nextChunk.
	statement := ast statements first.
	variable := statement arguments first value.
	newName := statement arguments third value]

{ #category : #accessing }
InstanceVariableRename >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' renameInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' of: ';
			nextPutAll: className;
			nextPutAll: ' to: ';
			nextPutAll: newName storeString]]

{ #category : #undo }
InstanceVariableRename >> tip [
	^'Rename ' , variable , ' → ' , newName]

{ #category : #undo }
InstanceVariableRename >> undo [
	^self projectChanges
		renameInstVar: newName
		of: self resolveClass
		to: variable]

