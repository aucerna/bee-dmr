"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableRemoval,
	#superclass : #InstanceVariableChange,
	#category : #ProjectChanges
}

{ #category : #private }
InstanceVariableRemoval >> basicPerform [
	| class ivars index next |
	class := self resolveClass ifNil: [^self].
	index := class instVarNames indexOf: variable.
	ivars := class instVarNames copyWithout: variable.
	next := ivars at: index ifAbsent: nil.
	self
		propertyAt: #next put: next;
		installVariables: ivars to: class.
	^class]

{ #category : #testing }
InstanceVariableRemoval >> canPerform [
	super canPerform ifFalse: [^false].
	^self resolveClass instVarNames includes: variable]

{ #category : #undo }
InstanceVariableRemoval >> canUndo [
	self propertyAt: #next ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
InstanceVariableRemoval >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^false].
	^class instVarNames includes: variable]

{ #category : #accessing }
InstanceVariableRemoval >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: self project referenceString;
			nextPutAll: ' removeInstVar: ';
			nextPutAll: variable storeString;
			nextPutAll: ' from: ';
			nextPutAll: className]]

{ #category : #undo }
InstanceVariableRemoval >> tip [
	^'Remove ' , variable , ' from ' , className]

{ #category : #undo }
InstanceVariableRemoval >> undo [
	| next |
	next := self propertyAt: #next ifAbsent: nil.
	^self projectChanges
		insertInstVar: variable
		to: self resolveClass
		before: next]

