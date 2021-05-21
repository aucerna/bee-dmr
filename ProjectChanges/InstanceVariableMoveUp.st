"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableMoveUp,
	#superclass : #InstanceVariableChange,
	#category : #ProjectChanges
}

{ #category : #perform }
InstanceVariableMoveUp >> basicPerform [
	| cls |
	cls := self resolveClass.
	self project moveUpInstVar: variable of: cls.
	^cls]

{ #category : #testing }
InstanceVariableMoveUp >> changesJustOneClass [
	^false]

{ #category : #testing }
InstanceVariableMoveUp >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^true].
	^class instVarNames includes: variable]

{ #category : #perform }
InstanceVariableMoveUp >> logSuperclassRedefinition [
	| sc |
	sc := self resolveClass superclass.
	(ClassDefinition fromClass: sc)
		owner: owner;
		timestamp: timestamp;
		author: author;
		logActionWith: sc]

{ #category : #perform }
InstanceVariableMoveUp >> perform [
	| cls |
	cls := super perform.
	cls notNil ifTrue: [self logSuperclassRedefinition].
	^cls]

{ #category : #'filein/out' }
InstanceVariableMoveUp >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' moveUpInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' of: ';
			nextPutAll: className]]

{ #category : #undo }
InstanceVariableMoveUp >> tip [
	^'Move ' , variable , ' to ' , className]

{ #category : #undo }
InstanceVariableMoveUp >> undo [
	| cls |
	cls := self resolveClass.
	^self projectChanges moveDownInstVar: variable of: cls superclass to: cls]

