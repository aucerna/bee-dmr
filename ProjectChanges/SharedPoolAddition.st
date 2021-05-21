"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SharedPoolAddition,
	#superclass : #ClassVariableAddition,
	#category : #ProjectChanges
}

{ #category : #private }
SharedPoolAddition >> basicPerform [
	| class |
	class := self resolveClass.
	(class sharedPools includes: variable) ifTrue: [^nil].
	class addSharedPool: variable]

{ #category : #testing }
SharedPoolAddition >> changesSomething [
	^self resolveClass notNil
		andNot: [self resolveClass sharedPools includes: variable]]

{ #category : #accessing }
SharedPoolAddition >> poolName: aSymbol [
	variable := aSymbol asSymbol]

{ #category : #accessing }
SharedPoolAddition >> sourceCode [
	^className , ' addSharedPool: ' , variable storeString]

{ #category : #undo }
SharedPoolAddition >> tip [
	^self resolveClass , ' add pool ' , variable]

{ #category : #undo }
SharedPoolAddition >> undo [
	self projectChanges removeSharedPool: variable from: self resolveClass]

