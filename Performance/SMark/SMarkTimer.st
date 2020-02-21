Class {
	#name : #SMarkTimer,
	#superclass : #Object,
	#instVars : [
		'#startTime',
		'#elapsedTime',
		'#name'
	],
	#category : #SMark
}

{ #category : #unclassified }
SMarkTimer class >> new [
	^self basicNew initialize
]

{ #category : #'instance creation' }
SMarkTimer class >> new: aName [
	| timer |
	timer := self new.
	timer name: aName.
	^timer
]

{ #category : #timing }
SMarkTimer >> currentMillis [
	^Time currentMicroseconds / 1000
]

{ #category : #initialization }
SMarkTimer >> initialize [
	super initialize.
	elapsedTime := 0
]

{ #category : #accessing }
SMarkTimer >> name [
	^name
]

{ #category : #accessing }
SMarkTimer >> name: aString [
	name := aString 
]

{ #category : #timing }
SMarkTimer >> reset [
	startTime := 0.
	elapsedTime := 0.
]

{ #category : #timing }
SMarkTimer >> start [
	startTime := self currentMillis.
]

{ #category : #timing }
SMarkTimer >> stop [
	| elapsedInThisPeriod current |
	current := self currentMillis.
	
	elapsedInThisPeriod := Time milliseconds: current since: startTime.
	
	elapsedTime := elapsedTime + elapsedInThisPeriod.
]

{ #category : #accessing }
SMarkTimer >> totalTime [
	^elapsedTime
]

