"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssRelationshipSelector,
	#superclass : #CssSelector,
	#instVars : [
		'selectors'
	],
	#category : #CSS
}

{ #category : #accessing }
CssRelationshipSelector class >> operator [
	self subclassResponsibility]

{ #category : #accessing }
CssRelationshipSelector class >> operators [
	| out |
	out := '' writeStream.
	self subclasses do: [:ea | out nextPutAll: ea operator].
	^out contents]

{ #category : #'instance creation' }
CssRelationshipSelector class >> selectorForOperator: aString [
	^(self subclasses
		detect: [:ea | ea operator = aString]
		ifNone: [CssDescendantSelector]) new]

{ #category : #comparing }
CssRelationshipSelector >> = anObject [
	^self class = anObject class and: [selectors = anObject selectors]]

{ #category : #accessing }
CssRelationshipSelector >> addSelector: aCssSelector [
	selectors add: aCssSelector]

{ #category : #comparing }
CssRelationshipSelector >> hash [
	^self class hash + selectors hash]

{ #category : #initialization }
CssRelationshipSelector >> initialize [
	super initialize.
	selectors := OrderedCollection new]

{ #category : #testing }
CssRelationshipSelector >> isCSS3 [
	^selectors anySatisfy: #isCSS3]

{ #category : #testing }
CssRelationshipSelector >> isRelationshipSelector [
	^true]

{ #category : #testing }
CssRelationshipSelector >> isValid [
	^super isValid and: [selectors conform: #isValid]]

{ #category : #accessing }
CssRelationshipSelector >> keySelectors [
	^selectors last keySelectors]

{ #category : #accessing }
CssRelationshipSelector >> operator [
	^self class operator]

{ #category : #printing }
CssRelationshipSelector >> printOn: aStream [
	selectors do: [:ea | 
		ea printOn: aStream.
		ea == selectors last ifFalse: [aStream nextPutAll: self operator]]]

{ #category : #accessing }
CssRelationshipSelector >> removeLastSelector [
	^selectors removeLast]

{ #category : #unclassified }
CssRelationshipSelector >> selectorForOperator: aString from: aStream [
	| sel last comb s |
	aString = self operator ifTrue: [
		sel := CssUniversalSelector readFrom: aStream.
		^self addSelector: sel].
	last := self removeLastSelector.
	comb := CssRelationshipSelector selectorForOperator: aString.
	comb addSelector: last.
	sel := self selectors isEmpty
		ifFalse: [self addSelector: comb]
		ifTrue: [comb].
	s := CssSelector oneSelectorFromString: aStream upToEnd.
	comb addSelector: s.
	^sel]

{ #category : #unclassified }
CssRelationshipSelector >> selectorForTypeOperator: aString from: aStream [
	| sel last comb s |
	aString = self operator ifTrue: [
		sel := CssTypeSelector readFrom: aStream.
		^self addSelector: sel].
	last := self removeLastSelector.
	comb := CssTypeSelector selectorForOperator: aString.
	comb addSelector: last.
	sel := self selectors isEmpty
		ifFalse: [self addSelector: comb]
		ifTrue: [comb].
	s := CssSelector oneSelectorFromString: aStream upToEnd.
	comb addSelector: s.
	^sel]

{ #category : #accessing }
CssRelationshipSelector >> selectors [
	^selectors]

{ #category : #accessing }
CssRelationshipSelector >> selectors: aCollection [
	selectors := aCollection]

{ #category : #accessing }
CssRelationshipSelector >> selectorsMatching: aBlock [
	| matching |
	matching := OrderedCollection new.
	(aBlock value: self) ifTrue: [matching add: self].
	selectors gather: [:s | s selectorsMatching: aBlock] in: matching.
	^matching asArray]

