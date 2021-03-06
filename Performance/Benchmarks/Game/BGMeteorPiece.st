"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #BGMeteorPiece,
	#superclass : #Object,
	#instVars : [
		'mask',
		'row'
	],
	#category : #Game
}

{ #category : #helpers }
BGMeteorPiece >> fillSolution: aString ncol: ncol withColor: c [
    | offset |
    offset := row * ncol.
    mask bitsDo: [:k | aString at: offset + k put: c]
]

{ #category : #testing }
BGMeteorPiece >> fitOnBoard: aBoardMask [
    ^0 == (aBoardMask bitAnd: mask)
]

{ #category : #'initialize-release' }
BGMeteorPiece >> forRow: rowOffset [
    row := rowOffset
]

{ #category : #accessing }
BGMeteorPiece >> mask [
    ^ mask
]

{ #category : #'initialize-release' }
BGMeteorPiece >> mask: aPieceMask [
    mask := aPieceMask
]

