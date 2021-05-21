"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableAddition,
	#superclass : #InstanceVariableChange,
	#category : #ProjectChanges
}

{ #category : #private }
InstanceVariableAddition >> basicPerform [
	| class ivars |
	class := self resolveClass ifNil: [^self].
	ivars := class instVarNames copyWith: variable.
	self installVariables: ivars to: class.
	^class]

{ #category : #testing }
InstanceVariableAddition >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^true].
	^(class instVarNames includes: variable) not]

{ #category : #accessing }
InstanceVariableAddition >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' addInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' to: ';
			nextPutAll: className]]

{ #category : #undo }
InstanceVariableAddition >> tip [
	^'Add ivar ' , variable , ' to ' , className]

{ #category : #undo }
InstanceVariableAddition >> undo [
	^self projectChanges removeInstVar: variable from: self resolveClass]

