"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Module,
	#superclass : #Object,
	#instVars : [
		'name',
		'version',
		'exports',
		'namespace',
		'hash',
		'cachedLookups'
	],
	#category : #Kernel
}

{ #category : #services }
Module >> bind: aModule as: aSymbol [
	namespace at: aSymbol put: aModule.
	self justDefined: aSymbol
]

{ #category : #private }
Module >> bindAllIn: aModule [
	aModule exports keysAndValuesDo: [:symbol :value |
		namespace at: symbol put: value.
		self justDefined: symbol].
]

{ #category : #services }
Module >> bindKernelExports [
	self bindAllIn: Kernel
]

{ #category : #initialization }
Module >> defaultName [
	| classname i |
	classname := self class name.
	i := classname indexOfString: 'Module'.
	^i = 0 ifTrue: [classname] ifFalse: [classname copyTo: i - 1]
]

{ #category : #services }
Module >> exports [
	| result |
	result := Dictionary new.
	exports do: [:name | | value |
		value := namespace at: name.
		result at: name put: value].
	^result
]

{ #category : #services }
Module >> export: anObject as: aSymbol [
	namespace at: aSymbol put: anObject.
	exports add: aSymbol
]

{ #category : #services }
Module >> exportClass: aClass [
	self export: aClass as: aClass name
]

{ #category : #services }
Module >> import: aSymbol [
	namespace at: aSymbol ifPresent: [:module | ^module].
	module := Kernel loadModule: aSymbol.
	namespace at: aSymbol put: module.
	self bind: module as: aSymbol.
	^module
]

{ #category : #initializing }
Module >> initialize [
	name := self defaultName.
	namespace := Namespace new.
	exports := Set new.
	cachedLookups := Dictionary new
]

{ #category : #private }
Module >> justDefined: aSymbol [
	| lookups |
	lookups := cachedLookups at: aSymbol ifAbsent: [^nil].
	lookups do: [:lookup | lookup flush]
]

{ #category : #accessing }
Module >> namespace [
	^namespace
]
