"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #NBody,
	#superclass : #Benchmark,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
NBody class >> new [

    Body initialize.
      ^ super new
]

{ #category : #'as yet unclassified' }
NBody >> innerBenchmarkLoop: innerIterations [

    | system |
    system := NBodySystem new.
    
    1 to: innerIterations do: [:i |
      system advance: 0.01.
    ].
    
    ^ self verify: system energy for: innerIterations.
]

{ #category : #'as yet unclassified' }
NBody >> verify: result for: innerIterations [
	innerIterations = 250000 ifTrue: [^result = -0.1690859889909308].
	innerIterations = 1 ifTrue: [^result = -0.16907495402506745].
	self
		printLn: 'No verification result for ' , innerIterations asString
			, ' found'.
	self printLn: 'Result is: ' , result asString.
	^false
]

