"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CategoryChange,
	#superclass : #ClassChange,
	#instVars : [
		'category'
	],
	#category : #ProjectChanges
}

{ #category : #testing }
CategoryChange >> canPerform [
	^super canPerform and: [self resolveClass categories includes: category]]

{ #category : #accessing }
CategoryChange >> category [
	^category]

{ #category : #accessing }
CategoryChange >> category: aSymbol [
	category := aSymbol asSymbol]

{ #category : #accessing }
CategoryChange >> refersTo [
	^{self class. className. category}]

