"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryRename,
	#superclass : #CategoryChange,
	#instVars : [
		'newName'
	],
	#category : #ProjectChanges
}

{ #category : #accessing }
CategoryRename >> basicPerform [
	self resolveClass organization
		renameCategory: category
		toBe: newName]

{ #category : #accessing }
CategoryRename >> category [
	^category]

{ #category : #accessing }
CategoryRename >> category: aSymbol [
	category := aSymbol asSymbol]

{ #category : #testing }
CategoryRename >> changesSomething [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^true].
	^class categories includes: category]

{ #category : #testing }
CategoryRename >> isOrganizationChange [
	^true]

{ #category : #accessing }
CategoryRename >> newName [
	^newName]

{ #category : #accessing }
CategoryRename >> newName: aString [
	newName := aString]

{ #category : #'filein/out' }
CategoryRename >> readFrom: aStream [
	| ast arguments |
	ast := self parse: aStream nextChunk.
	arguments := ast statements first arguments.
	category := arguments first value.
	newName := arguments last value]

{ #category : #accessing }
CategoryRename >> refersTo [
	^{self class. className. category}]

{ #category : #accessing }
CategoryRename >> sourceCode [
	^className, ' organization renameCategory: ', category storeString, ' toBe: ', newName storeString]

{ #category : #undo }
CategoryRename >> tip [
	^'Category ' , category storeString , ' → ' , newName storeString]

{ #category : #undo }
CategoryRename >> undo [
	^self projectChanges
		renameCategory: newName
		inClass: self resolveClass
		to: category]

