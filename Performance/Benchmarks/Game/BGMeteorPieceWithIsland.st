"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGMeteorPieceWithIsland,
	#superclass : #BGMeteorPiece,
	#instVars : [
		'islands',
		'aPieceCouldFitIntoIsland'
	],
	#category : #Game
}

{ #category : #testing }
BGMeteorPieceWithIsland >> fitOnBoard: aBoardMask [
    | occupied |
    ^0 == (aBoardMask bitAnd: mask) and:
        [(occupied := aBoardMask bitAnd: islands) = islands
            or: [aPieceCouldFitIntoIsland and: [(islands - occupied) bitCount = 5]]]
]

{ #category : #'initialize-release' }
BGMeteorPieceWithIsland >> islands: islandMask [
    islands := islandMask.
    aPieceCouldFitIntoIsland := islands bitCount >= 5
]

