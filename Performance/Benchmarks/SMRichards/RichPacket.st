"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #RichPacket,
	#superclass : #RichObject,
	#instVars : [
		'data',
		'datum',
		'identity',
		'kind',
		'link'
	],
	#category : #SMRichards
}

{ #category : #'instance creation' }
RichPacket class >> create: link identity: identity kind: kind [
    ^ self basicNew
		link: link
		identity: identity
		kind: kind
]

{ #category : #accessing }
RichPacket >> data [
	^ data
]

{ #category : #accessing }
RichPacket >> datum [
	^ datum
]

{ #category : #accessing }
RichPacket >> datum: anObject [
	datum := anObject
]

{ #category : #accessing }
RichPacket >> identity [
	^ identity
]

{ #category : #accessing }
RichPacket >> identity: anObject [
	identity := anObject
]

{ #category : #accessing }
RichPacket >> kind [
	^ kind
]

{ #category : #accessing }
RichPacket >> link [
	^ link
]

{ #category : #accessing }
RichPacket >> link: aWorkQueue [
	link := aWorkQueue
]

{ #category : #initialize }
RichPacket >> link: aLink identity: anIdentity kind: aKind [
    link := aLink.
    identity := anIdentity. 
    kind := aKind.
    datum := 1.
    data := ByteArray new: 4
]

