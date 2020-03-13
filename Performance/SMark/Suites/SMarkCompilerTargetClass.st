"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkCompilerTargetClass,
	#superclass : #Class,
	#category : #Suites
}

{ #category : #unclassified }
SMarkCompilerTargetClass class >> new [
	^self basicNew initialize
]

{ #category : #compiling }
SMarkCompilerTargetClass >> acceptsLoggingOfCompilation [
	"Answer whether the receiver's method submisions and class defintions should be logged to the changes file and to the current change set."

	^ false
]

{ #category : #'accessing method dictionary' }
SMarkCompilerTargetClass >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aCategory notifying: requestor [
	| priorMethodOrNil oldProtocol newProtocol |
	priorMethodOrNil := self compiledMethodAt: selector ifAbsent: [nil].
	self addSelectorSilently: selector withMethod: compiledMethod.
	oldProtocol := self organization categoryOfElement: selector.

	self classify: selector under: aCategory.

	newProtocol := self organization categoryOfElement: selector.
]

{ #category : #initialization }
SMarkCompilerTargetClass >> initialize [
	super initialize.
	self build
]

