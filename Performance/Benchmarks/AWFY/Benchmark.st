"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #Benchmark,
	#superclass : #Object,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
Benchmark >> benchmark [
 self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
Benchmark >> innerBenchmarkLoop: innerIterations [

      1 to: innerIterations do: [:i |
        (self verifyResult: self benchmark) ifFalse: [ ^ false ].
      ].
      ^ true
]

{ #category : #'as yet unclassified' }
Benchmark >> printLn: aString [
	Smalltalk transcript nextPutAll: aString; cr
]

{ #category : #'as yet unclassified' }
Benchmark >> verifyResult: result [
 self subclassResponsibility 
]

