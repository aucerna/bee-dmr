"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SharedPoolRemoval,
	#superclass : #ClassVariableRemoval,
	#category : #ProjectChanges
}

{ #category : #perform }
SharedPoolRemoval >> basicPerform [
	self resolveClass removeSharedPool: variable]

{ #category : #testing }
SharedPoolRemoval >> changesSomething [
	^self resolveClass notNil
		and: [self resolveClass sharedPools includes: variable]]

{ #category : #accessing }
SharedPoolRemoval >> poolName: aSymbol [
	variable := aSymbol asSymbol]

{ #category : #accessing }
SharedPoolRemoval >> sourceCode [
	^className , ' removeSharedPool: ' , variable storeString]

{ #category : #undo }
SharedPoolRemoval >> tip [
	^'Remove ' , variable , ' from ' , self resolveClass name]

{ #category : #undo }
SharedPoolRemoval >> undo [
	^self projectChanges addSharedPool: variable to: self resolveClass]

