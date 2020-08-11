"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TemperatureController,
	#superclass : #Object,
	#instVars : [
		'temperature',
		'trials',
		'jumps',
		'random',
		'solver'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
TemperatureController class >> for: aSimulatedAnnealingSolver [
	^self new solver: aSimulatedAnnealingSolver]

{ #category : #'instance creation' }
TemperatureController class >> new [
	^super new initialize]

{ #category : #inputs }
TemperatureController >> acceptanceRatio [
	^nil]

{ #category : #inputs }
TemperatureController >> acceptanceRatio: aNumber [
	]

{ #category : #'heating / cooling' }
TemperatureController >> cool [
	"
	do nothing
	"
	]

{ #category : #inputs }
TemperatureController >> distanceParameter [
	^nil]

{ #category : #inputs }
TemperatureController >> distanceParameter: aNumber [
	]

{ #category : #'heating / cooling' }
TemperatureController >> heat [
	"
	do nothing
	"
	]

{ #category : #initialization }
TemperatureController >> initialize [
	super initialize.
	self random: Random current]

{ #category : #testing }
TemperatureController >> isFrozen [
	^self subclassResponsibility]

{ #category : #testing }
TemperatureController >> isMelted [
	^self subclassResponsibility]

{ #category : #accessing }
TemperatureController >> justJumped [
	jumps := jumps + 1]

{ #category : #accessing }
TemperatureController >> justTried [
	trials := trials + 1]

{ #category : #inputs }
TemperatureController >> maxJumps [
	^nil]

{ #category : #inputs }
TemperatureController >> maxJumps: aNumber [
	]

{ #category : #inputs }
TemperatureController >> maxTrials [
	^nil]

{ #category : #inputs }
TemperatureController >> maxTrials: aNumber [
	]

{ #category : #accessing }
TemperatureController >> random: aRandom [
	random := aRandom]

{ #category : #private }
TemperatureController >> reset [
	trials := jumps := 0]

{ #category : #testing }
TemperatureController >> shouldJump: increment [
	| p |
	temperature = 0.0 ifTrue: [^increment < 0].
	increment < 0.0 ifTrue: [^true].
	p := increment / temperature.
	self ASSERT: p >= 0.0.
	^p negated exp > self stayProbability]

{ #category : #testing }
TemperatureController >> shouldTryAgain [
	^self subclassResponsibility]

{ #category : #accessing }
TemperatureController >> solver: anAnnealingAlgorithm [
	solver := anAnnealingAlgorithm]

{ #category : #'heating / cooling' }
TemperatureController >> startCycling [
	trials := jumps := 0]

{ #category : #private }
TemperatureController >> stayProbability [
	^random next]

{ #category : #inputs }
TemperatureController >> stopParameter [
	^nil]

{ #category : #inputs }
TemperatureController >> stopParameter: aNumber [
	]

{ #category : #accessing }
TemperatureController >> temperature [
	^temperature]

{ #category : #accessing }
TemperatureController >> temperature: aNumber [
	temperature := aNumber]

{ #category : #accessing }
TemperatureController >> uniform [
	^random]

{ #category : #services }
TemperatureController >> warm [
	]

