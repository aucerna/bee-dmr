"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RichWorkerTaskDataRecord,
	#superclass : #RichObject,
	#instVars : [
		'destination',
		'count'
	],
	#category : #SMRichards
}

{ #category : #'instance creation' }
RichWorkerTaskDataRecord class >> create [
	^ super basicNew create
]

{ #category : #accessing }
RichWorkerTaskDataRecord >> count [
	^ count
]

{ #category : #accessing }
RichWorkerTaskDataRecord >> count: anInteger [
	count := anInteger
]

{ #category : #'instance creation' }
RichWorkerTaskDataRecord >> create [
    destination := RichObject HandlerA.
    count := 0
]

{ #category : #accessing }
RichWorkerTaskDataRecord >> destination [
	^ destination
]

{ #category : #accessing }
RichWorkerTaskDataRecord >> destination: anObject [
	destination := anObject
]

