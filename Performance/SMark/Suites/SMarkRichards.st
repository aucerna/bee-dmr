"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #SMarkRichards,
	#superclass : #SMarkSuite,
	#category : #Suites
}

{ #category : #benchs }
SMarkRichards >> benchRichards [
	self richObject initialize.
	^self richRunner start
]

{ #category : #benchs }
SMarkRichards >> defaultProblemSize [
	^ 500
]

{ #category : #benchs }
SMarkRichards >> problemSize [
	| ps |
	ps := super problemSize.
	ps isInteger ifFalse: [^self defaultProblemSize].
	^ps
]

{ #category : #benchs }
SMarkRichards >> richObject [
	^Smalltalk at: #RichObject
]

{ #category : #benchs }
SMarkRichards >> richRunner [
	^Smalltalk at: #RichRunner
]

{ #category : #benchs }
SMarkRichards >> verifyRichards: result [
	^ result
]

