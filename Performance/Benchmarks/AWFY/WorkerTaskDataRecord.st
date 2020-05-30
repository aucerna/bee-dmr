"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #WorkerTaskDataRecord,
	#superclass : #RBObject,
	#instVars : [
		'destination',
		'count'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord class >> create [
 ^ super new create 
]

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord >> count [
 ^ count 
]

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord >> count: aCount [
count := aCount 
]

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord >> create [

      destination := RBObject HandlerA.
      count := 0
]

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord >> destination [
 ^ destination 
]

{ #category : #'as yet unclassified' }
WorkerTaskDataRecord >> destination: aHandler [
 destination := aHandler 
]

