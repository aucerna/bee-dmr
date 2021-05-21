"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassVariableMoveUp,
	#superclass : #ClassVariableChange,
	#category : #ProjectChanges
}

{ #category : #perform }
ClassVariableMoveUp >> basicPerform [
	self project moveUpClassVar: variable of: self resolveClass]

{ #category : #testing }
ClassVariableMoveUp >> changesJustOneClass [
	^false]

{ #category : #testing }
ClassVariableMoveUp >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^true].
	^class classVarNames includes: variable]

{ #category : #'filein/out' }
ClassVariableMoveUp >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' moveUpClassVar: ' , variable storeString;
			nextPutAll: ' of: ';
			nextPutAll: className]]

{ #category : #undo }
ClassVariableMoveUp >> tip [
	^'Move ' , variable , ' to ' , self resolveClass superclass name]

{ #category : #undo }
ClassVariableMoveUp >> undo [
	| cls |
	cls := self resolveClass.
	^self projectChanges moveDownClassVar: variable of: cls superclass to: cls]

