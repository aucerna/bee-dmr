"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassRedefinition,
	#superclass : #ClassDefinition,
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ClassRedefinition class >> fromClass: aClass [
	^self new
		class: aClass;
		project: aClass project;
		timestamp: Timestamp current]

{ #category : #perform }
ClassRedefinition >> basicPerform [
	| class |
	class := Smalltalk classNamed: className.
	class organization changeLink: self.
	^class]

{ #category : #testing }
ClassRedefinition >> isUserChange [
	^false]

{ #category : #testing }
ClassRedefinition >> shouldLogOnSmalltalkChanges [
	^false]

{ #category : #testing }
ClassRedefinition >> trackSubclasses [
	]

