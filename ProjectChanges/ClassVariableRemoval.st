"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassVariableRemoval,
	#superclass : #ClassVariableChange,
	#category : #ProjectChanges
}

{ #category : #perform }
ClassVariableRemoval >> basicPerform [
	self resolveClass removeClassVarNamed: variable]

{ #category : #testing }
ClassVariableRemoval >> changesSomething [
	^self resolveClass notNil
		and: [self resolveClass classVarNames includes: variable]]

{ #category : #accessing }
ClassVariableRemoval >> sourceCode [
	^className , ' removeClassVariable: ' , variable storeString]

{ #category : #undo }
ClassVariableRemoval >> tip [
	^'Add ' , variable , ' to ' , self resolveClass name]

{ #category : #undo }
ClassVariableRemoval >> undo [
	^self projectChanges addClassVar: variable to: self resolveClass]

