"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Richards,
	#superclass : #Benchmark,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Richards >> benchmark [

    ^ Scheduler new start.
]

{ #category : #'as yet unclassified' }
Richards >> verifyResult: result [

    ^ result
]

