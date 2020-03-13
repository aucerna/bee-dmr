"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RichObject,
	#superclass : #Object,
	#classVars : [
		'DeviceA',
		'DeviceB',
		'DevicePacketKind',
		'HandlerA',
		'HandlerB',
		'Idler',
		'NoTask',
		'NoWork',
		'Worker',
		'WorkPacketKind'
	],
	#category : #SMRichards
}

{ #category : #'as yet unclassified' }
RichObject class >> DeviceA [
	^ DeviceA
]

{ #category : #'as yet unclassified' }
RichObject class >> DeviceB [
	^ DeviceB
]

{ #category : #'as yet unclassified' }
RichObject class >> DevicePacketKind [
	^ DevicePacketKind
]

{ #category : #'as yet unclassified' }
RichObject class >> HandlerA [
	^ HandlerA
]

{ #category : #'as yet unclassified' }
RichObject class >> HandlerB [
	^ HandlerB
]

{ #category : #'as yet unclassified' }
RichObject class >> Idler [
	^ Idler
]

{ #category : #initialize }
RichObject class >> initialize [
    	DeviceA := 5.
    	DeviceB := 6.
    	DevicePacketKind := 1.
    	HandlerA := 3.
    	HandlerB := 4.
    	Idler := 1.
	   NoWork := nil.
	   NoTask := nil.
    	Worker := 2.
    	WorkPacketKind := 2
]

{ #category : #'as yet unclassified' }
RichObject class >> NoTask [
	^ NoTask
]

{ #category : #'as yet unclassified' }
RichObject class >> NoWork [
	^ NoWork
]

{ #category : #'as yet unclassified' }
RichObject class >> Worker [
	^ Worker
]

{ #category : #'as yet unclassified' }
RichObject class >> WorkPacketKind [
	^ WorkPacketKind
]

{ #category : #utilities }
RichObject >> append: packet head: queueHead [
    | mouse link |
    packet link: RichObject NoWork.
    RichObject NoWork == queueHead ifTrue: [ ^ packet ].
    mouse := queueHead.
    [RichObject NoWork == (link := mouse link)]
        whileFalse: [ mouse := link ].
    mouse link: packet.
    ^ queueHead
]

