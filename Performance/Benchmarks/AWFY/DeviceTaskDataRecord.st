"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #DeviceTaskDataRecord,
	#superclass : #RBObject,
	#instVars : [
		'pending'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
DeviceTaskDataRecord class >> create [

    ^ super new create
]

{ #category : #'as yet unclassified' }
DeviceTaskDataRecord >> create [
 pending := RBObject NoWork 
]

{ #category : #'as yet unclassified' }
DeviceTaskDataRecord >> pending [
 ^ pending 
]

{ #category : #'as yet unclassified' }
DeviceTaskDataRecord >> pending: packet [
 pending := packet 
]

