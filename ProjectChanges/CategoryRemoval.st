"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryRemoval,
	#superclass : #CategoryChange,
	#category : #ProjectChanges
}

{ #category : #perform }
CategoryRemoval >> basicPerform [
	self resolveClass organization removeCategory: category]

{ #category : #testing }
CategoryRemoval >> changesSomething [
	| class |
	(class := self resolveClass) isNil ifTrue: [^true].
	^class categories includes: category]

{ #category : #testing }
CategoryRemoval >> isOrganizationChange [
	^true]

{ #category : #'filein/out' }
CategoryRemoval >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	category := ast statements first arguments last value]

{ #category : #accessing }
CategoryRemoval >> sourceCode [
	^className, ' organization removeCategory: ', category storeString]

{ #category : #undo }
CategoryRemoval >> tip [
	^self resolveClass name , ' remove category ' , category storeString]

{ #category : #undo }
CategoryRemoval >> undo [
	^self projectChanges addCategory: category to: self resolveClass]

