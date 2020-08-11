"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GoldenRatioContinuedFraction,
	#superclass : #ContinuedFractionB,
	#category : #NumericalMethods
}

{ #category : #streaming }
GoldenRatioContinuedFraction >> advance [
	n := n + 1]

{ #category : #actions }
GoldenRatioContinuedFraction >> reset [
	super reset.
	an := bn := 1]

