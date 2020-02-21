Class {
	#name : #SMarkTest,
	#superclass : #TestCase,
	#category : #Tests
}

{ #category : #running }
SMarkTest >> setUp [
	"Necessary for Squeak 4.2 compatibility, since method anotations are not supported in the base image."
	(self respondsTo:  #timeout:) ifTrue: [
		self timeout: 300.
	].
]

{ #category : #tests }
SMarkTest >> testBasicRun [
	| runner results benchResult result |
	runner := SMarkLoops run.
	results := runner results.
	result := results at: 'IntLoop'.
	self assert: (result isKindOf: Collection).
	self assert: result size equals: 1.
	benchResult := result at: 1.
	self assert: (benchResult isKindOf: SMarkResult).
	self assert: benchResult total notNil
]

