"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RichDeviceTaskDataRecord,
	#superclass : #RichObject,
	#instVars : [
		'pending'
	],
	#category : #SMRichards
}

{ #category : #'instance creation' }
RichDeviceTaskDataRecord class >> create [
	^ super basicNew create
]

{ #category : #initialization }
RichDeviceTaskDataRecord >> create [
	pending := RichObject NoWork
]

{ #category : #accessing }
RichDeviceTaskDataRecord >> pending [
	^ pending
]

{ #category : #accessing }
RichDeviceTaskDataRecord >> pending: packet [
	pending := packet
]

