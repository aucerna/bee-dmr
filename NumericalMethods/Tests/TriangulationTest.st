"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TriangulationTest,
	#superclass : #TestCase,
	#category : #'NumericalMethods\Tests'
}

{ #category : #all }
TriangulationTest >> testBasicTriangulation [
	| triangulation |
	triangulation := PointTriangulation new.
	triangulation
		A: 2 @ 3;
		B: 5 @ 4;
		b: 5 sqrt;
		a: 5 sqrt;
		compute.
	self assert: triangulation C ~ (3 @ 5)]

