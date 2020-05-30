"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #CD,
	#superclass : #Benchmark,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
CD class >> new [

    Constants initialize.
    ^ super new
]

{ #category : #'as yet unclassified' }
CD >> benchmark: numAircrafts [

    | numFrames simulator detector actualCollisions |
    numFrames := 200.
    
    simulator := Simulator new: numAircrafts.
    detector  := CollisionDetector new.
    
    actualCollisions := 0.
    
    0 to: numFrames - 1 do: [:i |
      | time collisions |
      time := i / 10.0.
      collisions := detector handleNewFrame: (simulator simulate: time).
      actualCollisions := actualCollisions + collisions size ].
    
    ^ actualCollisions
]

{ #category : #'as yet unclassified' }
CD >> innerBenchmarkLoop: innerIterations [

    ^ self verify: (self benchmark: innerIterations) resultFor: innerIterations
]

{ #category : #'as yet unclassified' }
CD >> verify: actualCollisions resultFor: numAircrafts [

    numAircrafts = 1000 ifTrue: [ ^ actualCollisions = 14484 ].
    numAircrafts =  500 ifTrue: [ ^ actualCollisions = 14484 ].
    numAircrafts =  250 ifTrue: [ ^ actualCollisions = 10830 ].
    numAircrafts =  100 ifTrue: [ ^ actualCollisions =  4305 ].
    numAircrafts =   10 ifTrue: [ ^ actualCollisions =   390 ].
    
    ScriptConsole println: ('No verification result for ', numAircrafts asString, ' found.').
    ScriptConsole println: ('Result is: ', actualCollisions asString).
    ^ false
]

