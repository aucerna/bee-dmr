"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HeatingDevice,
	#superclass : #TemperatureController,
	#instVars : [
		'factor',
		'xi',
		'maxTrials',
		'm1',
		'm2',
		'mu'
	],
	#category : #NumericalMethods
}

{ #category : #inputs }
HeatingDevice >> acceptanceRatio [
	^xi]

{ #category : #inputs }
HeatingDevice >> acceptanceRatio: aNumber [
	xi := aNumber]

{ #category : #'heating / cooling' }
HeatingDevice >> heat [
	temperature := temperature * factor]

{ #category : #inputs }
HeatingDevice >> heatingFactor [
	^factor]

{ #category : #inputs }
HeatingDevice >> heatingFactor: aNumber [
	factor := aNumber]

{ #category : #initialization }
HeatingDevice >> initialize [
	super initialize.
	factor := 2.0.
	xi := 0.8.
	maxTrials := 10]

{ #category : #testing }
HeatingDevice >> isMelted [
	^mu > 0 and: [temperature > (mu negated / xi ln)]]

{ #category : #inputs }
HeatingDevice >> maxTrials [
	^maxTrials]

{ #category : #inputs }
HeatingDevice >> maxTrials: anInteger [
	maxTrials := anInteger]

{ #category : #private }
HeatingDevice >> reset [
	super reset.
	m1 := m2 := 0.
	mu := 0.0.
	temperature := solver costScale / 2.0]

{ #category : #testing }
HeatingDevice >> shouldJump: increment [
	increment > 0
		ifTrue: [
			mu := mu * m2 + increment / (m2 + 1).
			m2 := m2 + 1]
		ifFalse: [m1 := m1 + 1].
	^super shouldJump: increment]

{ #category : #testing }
HeatingDevice >> shouldTryAgain [
	^trials < maxTrials]

{ #category : #'heating / cooling' }
HeatingDevice >> startCycling [
	super startCycling.
	m1 := m2 := 0.
	mu := 0.0]

