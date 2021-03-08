"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RtfCommandIterator,
	#superclass : #RtfProcessor,
	#instVars : [
		'block'
	],
	#category : #RTF
}

{ #category : #accessing }
RtfCommandIterator >> block: aBlock [
	block := aBlock]

{ #category : #'event handling' }
RtfCommandIterator >> controlWord: aString
with: anInteger
from: start
to: end [
	| arg |
	arg := anInteger notNil ifTrue: [anInteger asString] ifFalse: [''].
	block value: aString value: arg value: start]

