Class {
	#name : #GlobalDispatchCache,
	#superclass : #Object,
	#instVars : [
		'#contents'
	],
	#classVars : [
		'#Current',
		'#GlobalLookupCount'
	],
	#category : #Kernel
}

{ #category : #accessing }
GlobalDispatchCache class >> current [
	^Thread currentGlobalLookup ifNil: [Current]
]

{ #category : #accessing }
GlobalDispatchCache class >> current: aCache [
	Current := aCache
]

{ #category : #accessing }
GlobalDispatchCache class >> globalLookupCount [
	^GlobalLookupCount
]

{ #category : #accessing }
GlobalDispatchCache >> at: selector for: protocol [
	| index |
]

{ #category : #accessing }
GlobalDispatchCache >> at: selector for: protocol put: aCompiledMethod [
	| index |
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector for: protocol [
	| index |
]

{ #category : #services }
GlobalDispatchCache >> flush: selector for: aProtocol startingAt: position [
	contents
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector forSpecies: aSpecies [
	| index |
]

{ #category : #services }
GlobalDispatchCache >> flushAll: selector [
	1 to: contents _size by: 2 do: [:i | | method |
]

{ #category : #accessing }
GlobalDispatchCache >> indexOf: selector with: behavior [
	"
]

{ #category : #initialization }
GlobalDispatchCache >> initialize [
	contents := Array new: 16r20000 + (8 * 2)
]

{ #category : #accessing }
GlobalDispatchCache >> lookup: selector for: aProtocol startingAt: position [
	| index |
]

{ #category : #services }
GlobalDispatchCache >> lookupAndCache: selector in: aProtocol [
	| method |
]

{ #category : #services }
GlobalDispatchCache >> startingAt: position for: aProtocol put: aCompiledMethod [
	| index |
]
