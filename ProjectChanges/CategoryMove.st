"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryMove,
	#superclass : #CategoryChange,
	#instVars : [
		'destination'
	],
	#category : #ProjectChanges
}

{ #category : #private }
CategoryMove >> basicPerform [
	| class selectors |
	class := self resolveClass ifNil: [^nil].
	selectors := class selectorsInCategory: category.
	self propertyAt: #prev put: selectors copy.
	class organization moveCategory: category into: destination]

{ #category : #testing }
CategoryMove >> canUndo [
	self resolveClass ifNil: [^false].
	self propertyAt: #prev ifAbsent: [^false].
	^true]

{ #category : #testing }
CategoryMove >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^false].
	^class categories includes: category]

{ #category : #accessing }
CategoryMove >> destination [
	^destination]

{ #category : #accessing }
CategoryMove >> destination: aSymbol [
	destination := aSymbol asSymbol]

{ #category : #testing }
CategoryMove >> isOrganizationChange [
	^true]

{ #category : #'file in/out' }
CategoryMove >> readFrom: aStream [
	| ast arguments |
	ast := self parse: aStream nextChunk.
	arguments := ast statements first arguments.
	category := arguments first value asSymbol.
	destination := arguments last value asSymbol]

{ #category : #accessing }
CategoryMove >> refersTo [
	^{self class. className. category. destination}]

{ #category : #accessing }
CategoryMove >> sourceCode [
	^String streamContents: [:strm | 
		strm
			nextPutAll: className;
			nextPutAll: ' organization moveCategory: ';
			nextPutAll: category asSymbol storeString;
			nextPutAll: ' into: ';
			nextPutAll: destination asSymbol storeString]]

{ #category : #perform }
CategoryMove >> tip [
	^'Category ' , category storeString , ' → ' , destination storeString]

{ #category : #private }
CategoryMove >> undo [
	| selectors organization |
	selectors := self propertyAt: #prev.
	organization := self resolveClass organization.
	selectors do: [:s | organization move: s to: category]]

