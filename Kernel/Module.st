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
		'imports',
		'namespace',
		'hash',
		'loadAction',
		'cachedLookups'
	],
	#category : #Kernel
}


{ #category : #initializing }
Module >> initialize [
	namespace := Namespace new.
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

