"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEAbstractParser,
	#superclass : #PPCompositeParser,
	#category : #JavaScript
}

{ #category : #utilities }
JSEAbstractParser >> anyOf: anArray [
	" parser that matches one of the elements "

	self subclassResponsibility]

{ #category : #private }
JSEAbstractParser >> arrayFromStartAndStarElements: elementAndStarElements [

	| array firstElement otherElements |
	firstElement := elementAndStarElements at: 1.
	otherElements := elementAndStarElements at: 2.
	array := Array new: otherElements size + 1.
	array at: 1 put: firstElement.
	otherElements notEmpty
		ifTrue: [ array replaceFrom: 2 to: array size with: otherElements ].
	^ array]

{ #category : #initialization }
JSEAbstractParser >> fastInitializeStartingAt: aSymbol [
	"
	this is an optimized version that tries to avoid sending the expensive #oneWayBecome:
	"
	| allVariableNames ignoredVariableNames productionIndexesAndNames actualParsers |
	self initialize.
	"find all the productions that need to be initialized"
	allVariableNames := self class allInstVarNames
		collect: [:each | each asSymbol].
	ignoredVariableNames := self class ignoredNames
		collect: [:each | each asSymbol].
	productionIndexesAndNames := ((1 to: self class instSize)
		collect: [:index | index -> (allVariableNames at: index)])
		reject: [:assoc | ignoredVariableNames includes: assoc value].
	"initialize productions with an undefined parser to be replaced later"
	productionIndexesAndNames
		do: [:assoc | self
			instVarAt: assoc key
			put: (PPUnresolvedParser named: assoc value)].
	" define parsers. all parsers referenced by instVar accessors are still unresolved  "
	actualParsers := Array new: self class instSize.
	productionIndexesAndNames do: [:assoc | | actualParser |
		(self respondsTo: assoc value)
			ifTrue: [
				actualParser := self perform: assoc value.
				actualParser == self
					ifTrue: [self error: assoc value , ' did not return a new parser'].
				actualParser name: assoc value.
				actualParsers at: assoc key put: actualParser]
			ifFalse: [self error: 'Unable to initialize ' , assoc value printString]].
	" replace unresolved parsers "
	productionIndexesAndNames
		do: [:assoc | | unresolvedParser actualParser instVarIndex productionIndex |
			instVarIndex := assoc key.
			unresolvedParser := self instVarAt: instVarIndex.
			actualParser := actualParsers at: instVarIndex.
			actualParser name = assoc value
				ifTrue: [unresolvedParser become: actualParser]
				ifFalse: [
					" Special case: a production returns another production. This requires #becomeForward:.
					The referenced production should be inlined in the grammer "
					productionIndex := (productionIndexesAndNames
						detect: [:a | a value = actualParser name])
						key.
					unresolvedParser become: (self instVarAt: productionIndex)]].
	parser := self perform: aSymbol]

{ #category : #initialization }
JSEAbstractParser >> initializeStartingAt: aSymbol [

	self fastInitializeStartingAt: aSymbol]

