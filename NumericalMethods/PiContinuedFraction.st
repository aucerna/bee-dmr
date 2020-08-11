"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PiContinuedFraction,
	#superclass : #ContinuedFractionB,
	#category : #NumericalMethods
}

{ #category : #streaming }
PiContinuedFraction >> advance [
	n := n + 1.
	n = 1
		ifTrue: [
			an := 0.
			bn := 2]
		ifFalse: [
			an := n = 2 ifTrue: [2] ifFalse: [n - 1 * (n - 2)].
			bn := 1]]

{ #category : #initialization }
PiContinuedFraction >> initialize [
	super initialize.
	self reset]

