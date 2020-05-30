"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RBObject,
	#superclass : #Object,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
RBObject class >> DeviceA [
 ^ 5 
]

{ #category : #'as yet unclassified' }
RBObject class >> DeviceB [
 ^ 6 
]

{ #category : #'as yet unclassified' }
RBObject class >> DevicePacketKind [
 ^ 1 
]

{ #category : #'as yet unclassified' }
RBObject class >> HandlerA [
 ^ 3 
]

{ #category : #'as yet unclassified' }
RBObject class >> HandlerB [
 ^ 4 
]

{ #category : #'as yet unclassified' }
RBObject class >> Idler [
 ^ 1 
]

{ #category : #'as yet unclassified' }
RBObject class >> NoTask [
 ^ nil 
]

{ #category : #'as yet unclassified' }
RBObject class >> NoWork [
 ^ nil 
]

{ #category : #'as yet unclassified' }
RBObject class >> Worker [
 ^ 2 
]

{ #category : #'as yet unclassified' }
RBObject class >> WorkPacketKind [
 ^ 2 
]

{ #category : #'as yet unclassified' }
RBObject >> append: packet head: queueHead [

    | mouse link |
    packet link: RBObject NoWork.
    RBObject NoWork == queueHead ifTrue: [ ^ packet ].
    mouse := queueHead.
    [RBObject NoWork == (link := mouse link)]
            whileFalse: [mouse := link].
    mouse link: packet.
    ^ queueHead
]

