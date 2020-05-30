"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Ball,
	#superclass : #Object,
	#instVars : [
		'x',
		'y',
		'xVel',
		'yVel'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Ball class >> new: random [
 ^ self new initialize: random 
]

{ #category : #'as yet unclassified' }
Ball >> bounce [

    | xLimit yLimit bounced |
    xLimit  := yLimit := 500.
    bounced := false.

    x := x + xVel.
    y := y + yVel.
    x > xLimit ifTrue: [
      x := xLimit. xVel := 0 - xVel abs. bounced := true ].
    x < 0 ifTrue: [
      x := 0.      xVel := xVel abs.     bounced := true ].
    y > yLimit ifTrue: [
      y := yLimit. yVel := 0 - yVel abs. bounced := true ].
    y < 0 ifTrue: [
      y := 0.      yVel := yVel abs.     bounced := true ].
    ^ bounced
]

{ #category : #'as yet unclassified' }
Ball >> initialize: random [

    x := random next % 500.
    y := random next % 500.
    xVel := (random next % 300) - 150.
    yVel := (random next % 300) - 150.
]

