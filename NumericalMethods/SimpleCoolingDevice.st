"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimpleCoolingDevice,
	#superclass : #CoolingDevice,
	#instVars : [
		'factor',
		'coolings',
		'maxCoolings',
		'meltThreshold',
		'maxJumps',
		'maxTrials',
		'maxTemp'
	],
	#category : #NumericalMethods
}

{ #category : #services }
SimpleCoolingDevice >> configureFor: size [
	size < 50 ifTrue: [^self reset].
	meltThreshold := 0.9.
	temperature := 0.5.
	maxJumps := (2.0 * size) sqrt.
	maxTrials := 2.0 * size sqrt.
	maxCoolings := 100.
	factor := 0.9]

{ #category : #'heating / cooling' }
SimpleCoolingDevice >> cool [
	super cool.
	temperature := temperature * factor.
	coolings := coolings + 1]

{ #category : #inputs }
SimpleCoolingDevice >> coolingFactor [
	^factor]

{ #category : #inputs }
SimpleCoolingDevice >> coolingFactor: aNumber [
	factor := aNumber]

{ #category : #'heating / cooling' }
SimpleCoolingDevice >> heat [
	temperature := self heatingFactor * temperature]

{ #category : #inputs }
SimpleCoolingDevice >> heatingFactor [
	^2.0]

{ #category : #initialization }
SimpleCoolingDevice >> initialize [
	super initialize.
	meltThreshold := 0.9.
	maxJumps := 10.
	maxTrials := 10.
	maxCoolings := 100.
	factor := 0.9.
	temperature := 0.5]

{ #category : #testing }
SimpleCoolingDevice >> isFrozen [
	^coolings >= maxCoolings]

{ #category : #testing }
SimpleCoolingDevice >> isMelted [
	trials = 0 ifTrue: [^false].
	^jumps asFloat / trials asFloat >= meltThreshold]

{ #category : #inputs }
SimpleCoolingDevice >> maxCoolings [
	^maxCoolings]

{ #category : #inputs }
SimpleCoolingDevice >> maxCoolings: aNumber [
	maxCoolings := aNumber asInteger]

{ #category : #inputs }
SimpleCoolingDevice >> maxJumps [
	^maxJumps]

{ #category : #inputs }
SimpleCoolingDevice >> maxJumps: anInteger [
	maxJumps := anInteger]

{ #category : #accessing }
SimpleCoolingDevice >> maxTemperature [
	^maxTemp]

{ #category : #inputs }
SimpleCoolingDevice >> maxTrials [
	^maxTrials]

{ #category : #inputs }
SimpleCoolingDevice >> maxTrials: anInteger [
	maxTrials := anInteger]

{ #category : #inputs }
SimpleCoolingDevice >> meltThreshold [
	^meltThreshold]

{ #category : #inputs }
SimpleCoolingDevice >> meltThreshold: aNumber [
	meltThreshold := aNumber asFloat]

{ #category : #private }
SimpleCoolingDevice >> reset [
	super reset.
	coolings := 0]

{ #category : #testing }
SimpleCoolingDevice >> shouldTryAgain [
	^jumps < maxJumps and: [trials < maxTrials]]

{ #category : #'heating / cooling' }
SimpleCoolingDevice >> warm [
	super warm.
	temperature := temperature / factor.
	coolings := 0]

