"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BeeProjectDefinition,
	#superclass : #BeeProject,
	#instVars : [
		'classDefinitions'
	],
	#category : #ProjectChanges
}

{ #category : #adding }
BeeProjectDefinition >> addClassDefinition: aClassDefinition [
	| oldVersion |
	self classes add: aClassDefinition.
	oldVersion := classDefinitions at: aClassDefinition className ifAbsent: [].
	oldVersion notNil
		ifTrue: [
			oldVersion propertyTable
				keysAndValuesDo: [:k :v | aClassDefinition propertyAt: k put: v].
			oldVersion become: aClassDefinition]
		ifFalse: [classDefinitions
			at: aClassDefinition className
			put: aClassDefinition]]

{ #category : #adding }
BeeProjectDefinition >> addMethodDefinition: aMethodDefinition [
	| def |
	def := self classDefinitionFor: aMethodDefinition className.
	def addSelector: aMethodDefinition selector withMethod: aMethodDefinition.
	(self includesClass: def) ifFalse: [self methods add: aMethodDefinition].
	aMethodDefinition category notNil ifTrue: [
		def organization
			classify: aMethodDefinition selector
			under: aMethodDefinition category]]

{ #category : #accessing }
BeeProjectDefinition >> allClassDefinitions [
	^classDefinitions reject: [:c | c className includesString: ' class']]

{ #category : #accessing }
BeeProjectDefinition >> categoriesFor: aClass [
	| className |
	className := aClass className.
	^(self methods
		select: [:m | m className = className]
		thenCollect: [:m | m category]) asSet asOrderedCollection sort]

{ #category : #accessing }
BeeProjectDefinition >> classDefinitionFor: className [
	^classDefinitions at: className ifAbsentPut: [| def class |
		def := ClassDefinition new.
		class := Smalltalk at: className asSymbol ifAbsent: nil.
		class notNil
			ifTrue: [def class: class]
			ifFalse: [def className: className].
		(className includesString: ' class')
			ifTrue: [def definition: className , ' instanceVariableNames: '''''].
		def project: self.
		def]]

{ #category : #accessing }
BeeProjectDefinition >> compiledMethodsFor: aClass [
	| cname |
	^(self includesClass: aClass)
		ifTrue: [aClass compiledMethods values]
		ifFalse: [
			cname := aClass className.
			self methods select: [:m | m className = cname]]]

{ #category : #testing }
BeeProjectDefinition >> includesClass: aClass [
	^self classes anySatisfy: [:c | c == aClass or: [c name = aClass]]]

{ #category : #initialization }
BeeProjectDefinition >> initialize [
	super initialize.
	classDefinitions := Dictionary new]

{ #category : #accessing }
BeeProjectDefinition >> methodAt: selector in: aClass [
	| cname |
	cname := aClass name.
	^self methods
		detect: [:cm | cm selector == selector and: [cm className = cname]]
		ifNone: nil]

{ #category : #accessing }
BeeProjectDefinition >> prerequisites [
	^spec prerequisites]

{ #category : #utils }
BeeProjectDefinition >> readFrom: aStream [
	Compiler evaluate: aStream nextChunk for: self.
	changes := ProjectChanges new project: self; readFrom: aStream.
	changes currentChanges do: [:c | c updateProject: self]]

{ #category : #initialization }
BeeProjectDefinition >> readFromFile [
	| fn file |
	fn := self class promptFileName.
	fn fileExists ifFalse: [^nil].
	self fullName: fn asString.
	file := fn asFile readStream.
	[self readFrom: file] ensure: [file close]]

{ #category : #accessing }
BeeProjectDefinition >> resolveClass: aClassName [
	^self classDefinitionFor: aClassName]

