"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #IdleTaskDataRecord,
	#superclass : #RBObject,
	#instVars : [
		'control',
		'count'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
IdleTaskDataRecord class >> create [
 ^ super new create 
]

{ #category : #'as yet unclassified' }
IdleTaskDataRecord >> control [
 ^ control 
]

{ #category : #'as yet unclassified' }
IdleTaskDataRecord >> control: aNumber [

    control := aNumber
]

{ #category : #'as yet unclassified' }
IdleTaskDataRecord >> count [
 ^ count 
]

{ #category : #'as yet unclassified' }
IdleTaskDataRecord >> count: aCount [

    count := aCount
]

{ #category : #'as yet unclassified' }
IdleTaskDataRecord >> create [

    control := 1.
    count := 10000
]

