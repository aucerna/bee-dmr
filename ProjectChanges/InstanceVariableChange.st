"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #InstanceVariableChange,
	#superclass : #VariableChange,
	#category : #ProjectChanges
}

{ #category : #private }
InstanceVariableChange >> changeClassFor: aClass [
	self ASSERT: (aClass allSuperclasses includes: self resolveClass).
	^SuperclassDefinition]

{ #category : #private }
InstanceVariableChange >> installVariables: ivars to: aClass [
	| installer |
	installer := aClass installer.
	aClass isMetaclass
		ifTrue: [installer classInstVarNames: ivars]
		ifFalse: [installer instanceVariableNames: ivars].
	installer install]

{ #category : #perform }
InstanceVariableChange >> logActionWith: result [
	super logActionWith: result.
	result notNil ifTrue: [self logClassRedefinition: result]]

{ #category : #perform }
InstanceVariableChange >> logClassRedefinition: aClass [
	(self projectChanges newChange: ClassRedefinition)
		class: aClass;
		owner: owner;
		timestamp: timestamp;
		author: author;
		perform]

{ #category : #perform }
InstanceVariableChange >> perform [
	| cls |
	cls := super perform.
	cls notNil ifTrue: [
		cls allSubclassesDo: [:sc | | ch |
			ch := sc project changes newChange: (self changeClassFor: sc).
			ch class: sc; perform]]]

