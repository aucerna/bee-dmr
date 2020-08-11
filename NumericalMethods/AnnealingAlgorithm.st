"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #AnnealingAlgorithm,
	#superclass : #Object,
	#instVars : [
		'problem',
		'cooler',
		'heater',
		'current',
		'cost',
		'uniform',
		'state',
		'stop',
		'best',
		'bestCost'
	],
	#category : #NumericalMethods
}

{ #category : #initialization }
AnnealingAlgorithm class >> availableEvents [
	^super availableEvents
		add: #heating;
		add: #jumped:;
		add: #cooling;
		yourself]

{ #category : #'instance creation' }
AnnealingAlgorithm class >> forProblem: aCombinatorialProblem [
	^self new problem: aCombinatorialProblem]

{ #category : #'instance creation' }
AnnealingAlgorithm class >> new [
	^super new initialize]

{ #category : #services }
AnnealingAlgorithm class >> solve: aCombinatorialProblem [
	| solver |
	solver := self forProblem: aCombinatorialProblem.
	solver solve.
	^solver currentPoint]

{ #category : #inputs }
AnnealingAlgorithm >> acceptanceRatio [
	^heater acceptanceRatio]

{ #category : #inputs }
AnnealingAlgorithm >> acceptanceRatio: aNumber [
	heater acceptanceRatio: aNumber]

{ #category : #accessing }
AnnealingAlgorithm >> control [
	^self currentDevice temperature]

{ #category : #accessing }
AnnealingAlgorithm >> cooler [
	^cooler]

{ #category : #accessing }
AnnealingAlgorithm >> cooler: aCoolingDevice [
	cooler := aCoolingDevice]

{ #category : #accessing }
AnnealingAlgorithm >> coolerClass: aClass [
	cooler class == aClass ifTrue: [^self].
	cooler := aClass for: self]

{ #category : #accessing }
AnnealingAlgorithm >> cost [
	^cost]

{ #category : #inquiries }
AnnealingAlgorithm >> costIncrementFor: delta [
	^problem costIncrementFor: delta on: current]

{ #category : #inquiries }
AnnealingAlgorithm >> costScale [
	^problem costScale]

{ #category : #accessing }
AnnealingAlgorithm >> current [
	^current]

{ #category : #inquiries }
AnnealingAlgorithm >> currentCost [
	^cost ifNil: [problem costAt: current]]

{ #category : #accessing }
AnnealingAlgorithm >> currentDevice [
	self isCooling ifTrue: [^cooler].
	^heater]

{ #category : #accessing }
AnnealingAlgorithm >> currentPoint [
	^current]

{ #category : #execution }
AnnealingAlgorithm >> cycleOn: device [
	| delta |
	device startCycling.
	[device shouldTryAgain] whileTrue: [| increment |
		delta := self trialJump.
		increment := self distanceIncrementFor: delta.
		(device shouldJump: increment) ifTrue: [
			self jump: delta.
			device justJumped].
		device justTried]]

{ #category : #inquiries }
AnnealingAlgorithm >> distanceIncrementFor: delta [
	| increment difference |
	increment := self costIncrementFor: delta.
	difference := self currentCost - problem goal.
	^(difference + increment) abs - difference abs]

{ #category : #inputs }
AnnealingAlgorithm >> distanceParameter [
	^cooler distanceParameter]

{ #category : #inputs }
AnnealingAlgorithm >> distanceParameter: aNumber [
	cooler distanceParameter: aNumber]

{ #category : #inquiries }
AnnealingAlgorithm >> distanceToGoal [
	^(self currentCost - problem goal) abs]

{ #category : #execution }
AnnealingAlgorithm >> freeze [
	stop ifTrue: [^self].
	cooler temperature: heater temperature.
	self shake: 0]

{ #category : #accessing }
AnnealingAlgorithm >> heater [
	^heater]

{ #category : #accessing }
AnnealingAlgorithm >> heater: aHeatingDevice [
	heater := aHeatingDevice]

{ #category : #accessing }
AnnealingAlgorithm >> heaterClass: aClass [
	heater class == aClass ifTrue: [^self].
	heater := aClass for: self]

{ #category : #initialization }
AnnealingAlgorithm >> initialize [
	super initialize.
	state := #idle.
	stop := false.
	self initializeCooler; initializeHeater; initializeRandom]

{ #category : #initialization }
AnnealingAlgorithm >> initializeCooler [
	cooler := SimpleCoolingDevice for: self]

{ #category : #initialization }
AnnealingAlgorithm >> initializeCost [
	cost := problem costAt: current.
	best := current.
	bestCost := cost]

{ #category : #initialization }
AnnealingAlgorithm >> initializeCurrent [
	current := problem initialSolution]

{ #category : #initialization }
AnnealingAlgorithm >> initializeHeater [
	heater := HeatingDevice for: self]

{ #category : #initialization }
AnnealingAlgorithm >> initializeRandom [
	self uniform: Random new]

{ #category : #testing }
AnnealingAlgorithm >> isCooling [
	^state == #cooling]

{ #category : #testing }
AnnealingAlgorithm >> isHeating [
	^state == #heating]

{ #category : #testing }
AnnealingAlgorithm >> isIdle [
	^state == #idle]

{ #category : #execution }
AnnealingAlgorithm >> jump: delta [
	| increment |
	increment := self costIncrementFor: delta.
	problem modify: current with: delta.
	cost := cost + increment.
	self distanceToGoal < (bestCost - problem goal) abs ifTrue: [
		best := current.
		bestCost := cost].
	self triggerEvent: #jumped: with: delta]

{ #category : #inputs }
AnnealingAlgorithm >> maxJumps [
	^cooler maxJumps]

{ #category : #inputs }
AnnealingAlgorithm >> maxJumps: aNumber [
	cooler maxJumps: aNumber.
	heater maxJumps: aNumber]

{ #category : #inputs }
AnnealingAlgorithm >> maxTrials [
	^self currentDevice maxTrials]

{ #category : #inputs }
AnnealingAlgorithm >> maxTrials: aNumber [
	cooler maxTrials: aNumber.
	heater maxTrials: aNumber]

{ #category : #execution }
AnnealingAlgorithm >> melt [
	stop ifTrue: [^self].
	state := #heating.
	self triggerEvent: #heating.
	[heater isMelted] whileFalse: [
		stop ifTrue: [^self].
		heater heat.
		self cycleOn: heater]]

{ #category : #accessing }
AnnealingAlgorithm >> neighborhoodSize [
	^self subclassResponsibility]

{ #category : #accessing }
AnnealingAlgorithm >> problem [
	^problem]

{ #category : #accessing }
AnnealingAlgorithm >> problem: aCombinatorialProblem [
	problem := aCombinatorialProblem]

{ #category : #inquiries }
AnnealingAlgorithm >> relativeDistanceToGoal [
	^(self currentCost relativeDistanceTo: problem goal) abs]

{ #category : #execution }
AnnealingAlgorithm >> reset [
	cooler reset.
	heater reset.
	state := #idle.
	stop := false]

{ #category : #execution }
AnnealingAlgorithm >> shake: n [
	stop ifTrue: [^self].
	state := #cooling.
	self triggerEvent: #cooling.
	n timesRepeat: [cooler warm].
	[cooler isFrozen] whileFalse: [
		stop ifTrue: [^self].
		self cycleOn: cooler.
		cooler cool].
	current := best.
	cost := bestCost.
	self triggerEvent: #jumped: with: nil]

{ #category : #testing }
AnnealingAlgorithm >> shouldJump: delta [
	| increment |
	increment := self distanceIncrementFor: delta.
	^cooler shouldJump: increment]

{ #category : #execution }
AnnealingAlgorithm >> solve [
	self
		reset;
		initializeCurrent;
		initializeCost;
		melt;
		freeze.
	state := #idle]

{ #category : #accessing }
AnnealingAlgorithm >> state [
	^state]

{ #category : #execution }
AnnealingAlgorithm >> stop [
	stop := true.
	state := #idle]

{ #category : #inputs }
AnnealingAlgorithm >> stopParameter [
	^cooler stopParameter]

{ #category : #inputs }
AnnealingAlgorithm >> stopParameter: aNumber [
	cooler stopParameter: aNumber]

{ #category : #accessing }
AnnealingAlgorithm >> temperature [
	^self control]

{ #category : #execution }
AnnealingAlgorithm >> trialJump [
	^self subclassResponsibility]

{ #category : #accessing }
AnnealingAlgorithm >> uniform [
	^cooler uniform]

{ #category : #accessing }
AnnealingAlgorithm >> uniform: aRandom [
	cooler random: aRandom.
	heater random: aRandom.
	uniform := aRandom]

{ #category : #services }
AnnealingAlgorithm >> useDefaultParameters [
	"
	do nothing
	"
	]

