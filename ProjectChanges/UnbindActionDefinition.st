"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UnbindActionDefinition,
	#superclass : #ActionDefinition,
	#category : #ProjectChanges
}

{ #category : #private }
UnbindActionDefinition >> actionTypeSelector [
	^#unloadAction]

{ #category : #perform }
UnbindActionDefinition >> basicPerform [
	self propertyAt: #prev put: self project unloadAction.
	self project unloadAction: self action]

{ #category : #undo }
UnbindActionDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
UnbindActionDefinition >> changesSomething [
	^self project unloadAction != self action]

{ #category : #perform }
UnbindActionDefinition >> tip [
	^self project name , ' unloadAction → ' , action asString]

{ #category : #undo }
UnbindActionDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges unloadAction: prev]

