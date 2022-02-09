"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #GlobalDispatchCache,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#classVars : [
		'Current',
		'GlobalLookupCount'
	],
	#category : #Kernel
}

{ #category : #accessing }
GlobalDispatchCache class >> current: aCache [
	Current := aCache
]

{ #category : #accessing }
GlobalDispatchCache class >> globalLookupCount [
	^GlobalLookupCount
]

{ #category : #accessing }
GlobalDispatchCache >> at: selector for: aBehavior [
	| index |
	index := self indexOf: selector with: aBehavior.
	^self lookup: selector for: aBehavior startingAt: index
]

{ #category : #accessing }
GlobalDispatchCache >> at: aSymbol for: aBehavior put: aCompiledMethod [
	| index |
	index := self indexOf: aSymbol with: aBehavior.
	^self startingAt: index for: aBehavior put: aCompiledMethod
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector for: aBehavior [
	| index |
	index := self indexOf: selector with: aBehavior.
	^self flush: selector for: aBehavior startingAt: index
]

{ #category : #services }
GlobalDispatchCache >> flush: selector for: aBehavior startingAt: position [
	contents
		_basicAt: position put: nil;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector forSpecies: aSpecies [
	| index |
	(aSpecies == Object or: [aSpecies == ProtoObject or: [aSpecies == nil]])
		ifTrue: [^self flushAll: selector].
	aSpecies withAllSubclassesDo: [:species | 
		index := self indexOf: selector with: species instanceBehavior.
		self flush: selector for: species instanceBehavior startingAt: index]
]

{ #category : #services }
GlobalDispatchCache >> flushAll: selector [
	1 to: contents _size by: 2 do: [:i | | method |
		method := contents _basicAt: i.
		(method !== nil and: [method selector == selector])
			ifTrue: [contents _basicAt: i put: nil]]
]

{ #category : #accessing }
GlobalDispatchCache >> indexOf: selector with: behavior [
	"
	we always return odd values so that the table has
	 the next (even) index to store the cached value
	"
	| hash |
	hash := (selector _basicHash bitXor: behavior _basicHash) bitAnd: 16rFFFF.
	^hash + hash + 1
]

{ #category : #initialization }
GlobalDispatchCache >> initialize [
	contents := Array new: 16r20000 + (8 * 2)
]

{ #category : #accessing }
GlobalDispatchCache >> lookup: selector for: aBehavior startingAt: position [
	| index |
	index := position.
	8 timesRepeat: [| method protocol |
		method := contents _basicAt: index.
		method == nil ifTrue: [^nil].
		protocol := contents _basicAt: index + 1.
		(protocol == aBehavior and: [method selector == selector]) ifTrue: [^method].
		index := index + 2].
	^nil
]

{ #category : #services }
GlobalDispatchCache >> lookupAndCache: aSymbol in: aBehavior [
	| method |
	aBehavior hasInstanceBehavior
		ifTrue: [^self _lookup: aSymbol in: aBehavior].
	method := self at: aSymbol for: aBehavior.
	method == nil ifTrue: [
		GlobalLookupCount := GlobalLookupCount + 1.
		method := self _lookup: aSymbol in: aBehavior.
		self at: aSymbol for: aBehavior put: method].
	^method
]

{ #category : #services }
GlobalDispatchCache >> startingAt: position for: aBehavior put: aCompiledMethod [
	| index |
	index := position.
	8 timesRepeat: [| method |
		method := contents _basicAt: index.
		method == nil ifTrue: [
			contents objectAtValid: index put: aCompiledMethod.
			^contents objectAtValid: index + 1 put: aBehavior].
		index := index + 2].
	contents
		objectAtValid: position put: aCompiledMethod;
		objectAtValid: position + 1 put: aBehavior;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
]

