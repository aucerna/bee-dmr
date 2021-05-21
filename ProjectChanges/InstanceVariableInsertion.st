"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableInsertion,
	#superclass : #InstanceVariableChange,
	#instVars : [
		'next'
	],
	#category : #ProjectChanges
}

{ #category : #private }
InstanceVariableInsertion >> basicPerform [
	| class ivars |
	class := self resolveClass ifNil: [^self].
	ivars := class instVarNames asOrderedCollection.
	ivars
		add: variable
		before: next
		ifAbsent: [class instVarNames add: variable].
	self installVariables: ivars to: class.
	^class]

{ #category : #testing }
InstanceVariableInsertion >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^true].
	^(class instVarNames includes: variable) not]

{ #category : #accessing }
InstanceVariableInsertion >> next: aString [
	next := aString]

{ #category : #accessing }
InstanceVariableInsertion >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' insertInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' to: ';
			nextPutAll: className;
			nextPutAll: ' before: ';
			nextPutAll: next]]

{ #category : #perform }
InstanceVariableInsertion >> tip [
	^'Insert ivar ' , variable]

{ #category : #undo }
InstanceVariableInsertion >> undo [
	^self projectChanges removeInstVar: variable from: self resolveClass]

