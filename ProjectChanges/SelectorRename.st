"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SelectorRename,
	#superclass : #ProjectChange,
	#instVars : [
		'selector',
		'newSelector'
	],
	#category : #ProjectChanges
}

{ #category : #comparing }
SelectorRename >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	^selector = changeRecord selector
		and: [newSelector = changeRecord newSelector]
		and: [self projectName = changeRecord projectName]]

{ #category : #perform }
SelectorRename >> basicPerform [
	self projectChanges
		whenReceiving: #newChange:
		evaluate: [self logActionWith: nil]
		afterThat: [self projectChanges stopSpying: #newChange:].
	[self project renameSelector: selector as: newSelector]
		ensure: [self projectChanges stopSpying: #newChange:].
	^nil]

{ #category : #testing }
SelectorRename >> canPerform [
	^selector hasImplementors or: [selector hasSenders]]

{ #category : #testing }
SelectorRename >> changesClass: aClass [
	| m |
	(self project includesClass: aClass selector: newSelector) ifTrue: [^true].
	m := aClass >> newSelector.
	(m notNil and: [m timestamp notNil] and: [m timestamp >= timestamp])
		ifTrue: [^true].
	m := aClass class >> newSelector.
	(m notNil and: [m timestamp notNil] and: [m timestamp >= timestamp])
		ifTrue: [^true].
	Smalltalk
		sendersOf: newSelector
		in: aClass
		do: [:cm | (cm timestamp notNil and: [cm timestamp >= timestamp])
			ifTrue: [^true]].
	Smalltalk
		sendersOf: newSelector
		in: aClass class
		do: [:cm | (cm timestamp notNil and: [cm timestamp >= timestamp])
			ifTrue: [^true]].
	^false]

{ #category : #testing }
SelectorRename >> changesSelector: aSymbol in: aClass [
	| cm |
	aSymbol == newSelector
		ifTrue: [(self project includesClass: aClass selector: aSymbol)
			ifTrue: [^true]].
	cm := aClass isClass ifTrue: [aClass >> aSymbol].
	cm isNil ifTrue: [^false].
	(cm isSenderOf: newSelector) ifFalse: [^false].
	^cm timestamp notNil and: [cm timestamp >= timestamp]]

{ #category : #testing }
SelectorRename >> changesSomething [
	^selector hasImplementors
		or: [newSelector hasImplementors not]
		or: [selector hasSenders]]

{ #category : #accessing }
SelectorRename >> classBinding [
	^UndefinedObject]

{ #category : #testing }
SelectorRename >> isSelectorRename [
	^true]

{ #category : #accessing }
SelectorRename >> newSelector [
	^newSelector]

{ #category : #accessing }
SelectorRename >> newSelector: aSymbol [
	newSelector := aSymbol]

{ #category : #'filein/out' }
SelectorRename >> readFrom: aStream [
	| ast arguments |
	ast := self parse: aStream nextChunk.
	ast statements isEmpty ifFalse: [
		arguments := ast statements first arguments.
		selector := arguments first value.
		newSelector := arguments second value]]

{ #category : #accessing }
SelectorRename >> refersTo [
	^{self class. self projectName. selector}]

{ #category : #accessing }
SelectorRename >> resolveClass [
	^nil]

{ #category : #accessing }
SelectorRename >> selector [
	^selector]

{ #category : #accessing }
SelectorRename >> selector: aSymbol [
	selector := aSymbol]

{ #category : #accessing }
SelectorRename >> sourceCode [
	^self project referenceString , ' renameSelector: ' , selector storeString
		, ' as: '
		, newSelector storeString]

{ #category : #undo }
SelectorRename >> tip [
	^'Rename ' , selector storeString , ' → ' , newSelector storeString]

{ #category : #undo }
SelectorRename >> undo [
	^self projectChanges renameSelector: newSelector as: selector]

