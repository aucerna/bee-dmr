"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryReorganization,
	#superclass : #ClassChange,
	#instVars : [
		'categories'
	],
	#category : #ProjectChanges
}

{ #category : #perform }
CategoryReorganization >> basicPerform [
	self propertyAt: #prev put: categories shallowCopy.
	self resolveClass organization reorganizeWith: categories]

{ #category : #undo }
CategoryReorganization >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #accessing }
CategoryReorganization >> categories: aCollection [
	categories := aCollection asArray]

{ #category : #testing }
CategoryReorganization >> changesSomething [
	| class |
	(class := self resolveClass) isNil ifTrue: [^true].
	^class categories asArray = categories]

{ #category : #accessing }
CategoryReorganization >> currentVersion [
	| class |
	^(class := self resolveClass) isNil ifFalse: [self copy categories: class organization selectors asArray]]

{ #category : #testing }
CategoryReorganization >> isOrganizationChange [
	^true]

{ #category : #'filein/out' }
CategoryReorganization >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	categories := ast statements first arguments first value]

{ #category : #accessing }
CategoryReorganization >> sourceCode [
	^className, ' organization reorganizeWith: ', categories literalString]

{ #category : #undo }
CategoryReorganization >> tip [
	^self resolveClass , ' category reorganization']

{ #category : #undo }
CategoryReorganization >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges reorganize: self resolveClass with: prev]

