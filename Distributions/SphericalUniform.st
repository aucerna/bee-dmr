"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SphericalUniform,
	#superclass : #MultivariatedDistribution,
	#instVars : [
		'angle',
		'z',
		'radius'
	],
	#category : #Distributions
}

{ #category : #private }
SphericalUniform class >> radius: rho [
	"
	SphericalUniform radius: 1000
	"
	^self radius: rho uniform: Random new]

{ #category : #private }
SphericalUniform class >> radius: rho uniform: uniform [
	^self new radius: rho; uniform: uniform]

{ #category : #examples }
SphericalUniform class >> sampleInstance [
	^self radius: 1.0]

{ #category : #'random sampling' }
SphericalUniform >> next [
	| phi height h a b c |
	phi := angle next.
	height := z next.
	h := (1.0 - height squared) sqrt.
	a := phi cos * h * radius.
	b := phi sin * h * radius.
	c := height * radius.
	^{a. b. c}]

{ #category : #accessing }
SphericalUniform >> parameterArray [
	^{radius}]

{ #category : #accessing }
SphericalUniform >> radius: rho [
	radius := rho.
	angle := UniformDistribution between: 0.0 and: 2.0 * Number pi.
	z := UniformDistribution between: -1.0 and: 1.0.
	self uniform: uniform]

{ #category : #printing }
SphericalUniform >> storeString [
	^self class name , ' radius: ' , radius storeString]

{ #category : #accessing }
SphericalUniform >> uniform: aRandom [
	super uniform: aRandom.
	angle notNil ifTrue: [angle uniform: aRandom].
	z notNil ifTrue: [z uniform: aRandom]]

