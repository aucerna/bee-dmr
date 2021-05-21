"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SelectorClassification,
	#superclass : #MethodChange,
	#instVars : [
		'category',
		'old'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
SelectorClassification >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	category = changeRecord category ifFalse: [^false].
	^true]

{ #category : #accessing }
SelectorClassification >> basicPerform [
	| cl |
	cl := self resolveClass.
	cl isNil ifTrue: [^self].
	(cl selectors includes: selector) ifTrue: [
		old := cl categoryFor: selector.
		cl organization move: selector to: category.
		(cl selectorsInCategory: old) isEmptyOrNil
			ifTrue: [cl organization removeCategory: old]]]

{ #category : #testing }
SelectorClassification >> canUndo [
	^old notNil and: [super canUndo]]

{ #category : #accessing }
SelectorClassification >> category [
	^category]

{ #category : #accessing }
SelectorClassification >> category: aSymbol [
	category := aSymbol replaceAll: '&&' with: '&'.
	category := category asSymbol]

{ #category : #testing }
SelectorClassification >> changesSomething [
	| class |
	(class := self resolveClass) isNil ifTrue: [^true].
	(class includesSelector: selector) ifFalse: [^true].
	^(class categoryFor: selector) != category]

{ #category : #perform }
SelectorClassification >> compress: aChangeList [
	| md |
	self isUnclassified ifTrue: [^aChangeList].
	md := aChangeList
		reverseDetect: [:ch | 
			(ch isKindOf: MethodDefinition)
				and: [ch className = className]
				and: [ch selector = selector]]
		ifNone: nil.
	md notNil ifTrue: [
		md category: category.
		^aChangeList].
	^super compress: aChangeList]

{ #category : #accessing }
SelectorClassification >> currentVersion [
	| cls categ |
	cls := self resolveClass.
	cls isNil ifTrue: [^nil].
	(cls includesSelector: selector) ifFalse: [^nil].
	categ := cls categoryFor: selector.
	^self class new
		projectChanges: self projectChanges;
		author: self author;
		selector: selector;
		className: className;
		category: categ;
		yourself]

{ #category : #testing }
SelectorClassification >> isOrganizationChange [
	^true]

{ #category : #testing }
SelectorClassification >> isUnclassified [
	^category == ClassOrganizer default]

{ #category : #accessing }
SelectorClassification >> method: aCompiledMethod [
	selector := aCompiledMethod selector.
	className := aCompiledMethod classBinding name.
	category := aCompiledMethod category]

{ #category : #accessing }
SelectorClassification >> projects [
	^self method projects]

{ #category : #'filein/out' }
SelectorClassification >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	ast statements isEmpty
		ifFalse: [self category: ast statements first arguments last value]]

{ #category : #accessing }
SelectorClassification >> sourceCode [
	^className , ' organization move: ' , selector storeString , ' to: '
		, category storeString]

{ #category : #undo }
SelectorClassification >> tip [
	^'Classify ' , selector , ' under ' , category]

{ #category : #undo }
SelectorClassification >> undo [
	self projectChanges classify: selector in: self resolveClass under: old]

