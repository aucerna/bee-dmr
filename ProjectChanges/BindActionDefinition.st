"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BindActionDefinition,
	#superclass : #ActionDefinition,
	#category : #ProjectChanges
}

{ #category : #perform }
BindActionDefinition >> basicPerform [
	self propertyAt: #prev put: self project loadAction.
	self project loadAction: self action]

{ #category : #undo }
BindActionDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
BindActionDefinition >> changesSomething [
	^self project loadAction != self action]

{ #category : #undo }
BindActionDefinition >> tip [
	^self project name , ' loadAction → ' , action asString]

{ #category : #undo }
BindActionDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges loadAction: prev]

