"
    Copyright (c) 2022, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ModuleClosure,
	#superclass : #Object,
	#instVars : [
		'queue',
		'module',
		'builder',
		'mapping'
	],
	#category : #'ModuleClosure'
}

{ #category : #closure }
ModuleClosure >> traverse: roots [
	| obj |
	queue addAll: roots.
	[ queue isEmpty ]
		whileFalse: [
			obj := queue removeFirst.
			self addSlotsOf: obj ]
]

{ #category : #closure }
ModuleClosure >> addSlotsOf: anObject remaining: remaining [
	| b |
	b := obj behavior.
	self follow: b.
	1 to: anObject _pointersSize do: [ :i | | slot |
		slot := anObject _basicAt: i.
		slot _isSmallInteger ifFalse: [ self follow: slot ] ]
]

{ #category : #accessing }
ModuleClosure >> builder: anImageSegmentBuilder [
	builder := anImageSegmentBuilder
]

{ #category : #closure }
ModuleClosure >> follow: anObject [
	| surrogate |
	surrogate := self surrogateFor: anObject.
	(surrogate isNil or: [surrogate _isSmallInteger]) ifTrue: [^self].

	(builder alreadyAdded: surrogate) ifTrue: [^self].
	builder add: surrogate.
	queue add: surrogate
]

{ #category : #initialization }
ModuleClosure >> initialize [
	mapping := IdentityDictionary new.
	queue := OrderedCollection new: 2000.
]

{ #category : #accessing }
ModuleClosure >> roots: aCollection [
	roots := aCollection
]

{ #category : #accessing }
ModuleClosure >> surrogateFor: anObject [
	^mapping at: anObject ifAbsent: [anObject]
]

