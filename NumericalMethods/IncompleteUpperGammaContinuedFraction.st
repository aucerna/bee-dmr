"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #IncompleteUpperGammaContinuedFraction,
	#superclass : #ContinuedFractionA,
	#instVars : [
		's',
		'z'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
IncompleteUpperGammaContinuedFraction class >> a: a x: x [
	"
	IncompleteUpperGammaContinuedFraction a: 2 x: 5
	"
	^self new a: a x: x]

{ #category : #'instance creation' }
IncompleteUpperGammaContinuedFraction class >> epsilon: epsilon
iterations: iterations
a: a
x: x [
	"
	IncompleteUpperGammaContinuedFraction epsilon: 0.0000000003 iterations: 100 a: 2 x: 5
	"
	| gamma |
	gamma := self a: a x: x.
	^gamma epsilon: epsilon; iterations: iterations]

{ #category : #accessing }
IncompleteUpperGammaContinuedFraction >> a: a x: x [
	s := a.
	z := x.
	self reset]

{ #category : #streaming }
IncompleteUpperGammaContinuedFraction >> advance [
	n := n + 1.0.
	an := s - n * n.
	bn := bn + 2.0]

{ #category : #actions }
IncompleteUpperGammaContinuedFraction >> reset [
	super reset.
	an := 0.0.
	bn := z - s + 1.0]

{ #category : #evaluation }
IncompleteUpperGammaContinuedFraction >> value [
	^1.0 / (z - s + 1.0 + super value)]

