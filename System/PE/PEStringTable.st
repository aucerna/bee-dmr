"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #PEStringTable,
	#superclass : #Object,
	#instVars : [
		'#strings',
		'#segment',
		'#start',
		'#bytes',
		'#offsets',
		'#size'
	],
	#category : #PE
}

{ #category : #'instance creation' }
PEStringTable class >> new [
	^super new initialize
]

{ #category : #'adding / removing' }
PEStringTable >> add: aString [
	self addStrings: {aString}
]

{ #category : #'adding / removing' }
PEStringTable >> addStrings: aCollection [
	strings addAll: aCollection.
	size := self prepaddedStrings sum: [:symbol | 2 + symbol size + 1]
]

{ #category : #'adding / removing' }
PEStringTable >> at: anInteger in: aSegment [
	start := anInteger.
	segment := aSegment
]

{ #category : #'adding / removing' }
PEStringTable >> bytes: aByteArray [
	bytes := aByteArray
]

{ #category : #'adding / removing' }
PEStringTable >> endOffset [
	^start + size
]

{ #category : #initialization }
PEStringTable >> initialize [
	strings := OrderedCollection new.
	offsets := Dictionary new.
	start := size := 0
]

{ #category : #'adding / removing' }
PEStringTable >> offset [
	^start
]

{ #category : #'adding / removing' }
PEStringTable >> offsetOf: aString [
	^offsets at: aString
]

{ #category : #'adding / removing' }
PEStringTable >> prepaddedStrings [
	^strings
		collect: [:symbol | symbol size even
			ifTrue: [symbol nullTerminated]
			ifFalse: [symbol]]
]

{ #category : #'adding / removing' }
PEStringTable >> setup [
	| offset |
	offset := start.
	self prepaddedStrings do: [:symbol | 
		offset := offset + 2.
		bytes bytesAtOffset: offset put: symbol.
		offsets at: symbol trimNullEnd put: offset.
		offset := offset + symbol size + 1].
	self ASSERT: size = (offset - start)
]

{ #category : #private }
PEStringTable >> size [
	^size
]

