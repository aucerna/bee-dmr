"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodSpec,
	#superclass : #Object,
	#instVars : [
		'selector',
		'class',
		'source',
		'category',
		'module',
		'ast'
	],
	#category : #Specs
}

{ #category : #comparing }
MethodSpec >> = aMethodSpec [
	^aMethodSpec class = self class
		and: [aMethodSpec selector == selector]
		and: [aMethodSpec classBinding = class]]

{ #category : #converting }
MethodSpec >> ast [
	self canBeCompiled ifFalse: [^nil].
	^ast ifNil: [ast := self compiler parseMethod: source]]

{ #category : #accessing }
MethodSpec >> category [
	^self isExtension
		ifTrue: ['*' , (module name readStream upToLast: $-)]
		ifFalse: [category]]

{ #category : #accessing }
MethodSpec >> category: aString [
	category := aString]

{ #category : #accessing }
MethodSpec >> classBinding [
	^class]

{ #category : #accessing }
MethodSpec >> classBinding: aSpeciesSpec [
	class := aSpeciesSpec]

{ #category : #inquiries }
MethodSpec >> classname [
	^class name]

{ #category : #private }
MethodSpec >> compiler [
	^nil]

{ #category : #comparing }
MethodSpec >> hash [
	^class name hash hashWith: selector]

{ #category : #testing }
MethodSpec >> isExtension [
	^class isExtension]

{ #category : #accessing }
MethodSpec >> module [
	^module]

{ #category : #accessing }
MethodSpec >> module: aModuleSpec [
	module := aModuleSpec]

{ #category : #printing }
MethodSpec >> printOn: aStream [
	aStream nextPutAll: class name asString , '>>#' , selector asString]

{ #category : #services }
MethodSpec >> resolveClass [
	^module resolveSpecies: class name]

{ #category : #accessing }
MethodSpec >> selector [
	^selector]

{ #category : #accessing }
MethodSpec >> selector: aSymbol [
	selector := aSymbol]

{ #category : #accessing }
MethodSpec >> source [
	^source]

{ #category : #accessing }
MethodSpec >> source: aString [
	source := aString.
	ast := nil]

{ #category : #accessing }
MethodSpec >> sourceCode [
	^source]

{ #category : #testing }
MethodSpec >> usesInstanceVariableNamed: aString [
	^(self ast variableNamed: aString) notNil]

