"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimpsonMethodTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #all }
SimpsonMethodTest >> test1 [
	| simpson |
	simpson := SimpsonMethod new.
	simpson
		f: (Function on: [:x | x squared]);
		a: 0;
		b: 1;
		n: 20;
		compute.
	self assert: (simpson integral - 0.333) abs < 0.001]

{ #category : #all }
SimpsonMethodTest >> test2 [
	| simpson |
	simpson := SimpsonMethod new.
	simpson
		f: (Function on: [:x | x]);
		a: 0;
		b: 1;
		n: 20;
		compute.
	self assert: (simpson integral - 0.5) abs < 0.001]

{ #category : #all }
SimpsonMethodTest >> test3 [
	| simpson |
	simpson := SimpsonMethod new.
	simpson
		f: (Function on: [:x | x squared negated exp]);
		a: 0;
		b: 1;
		n: 100;
		compute.
	self assert: (simpson integral - 0.74682413289) abs < 0.000001]

