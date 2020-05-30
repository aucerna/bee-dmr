"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #DeltaBlue,
	#superclass : #Benchmark,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
DeltaBlue class >> new [

    Strength initialize.
    ^ super new
]

{ #category : #'as yet unclassified' }
DeltaBlue >> innerBenchmarkLoop: innerIterations [

    Planner chainTest: innerIterations.
    Planner projectionTest: innerIterations.
    ^ true
]

