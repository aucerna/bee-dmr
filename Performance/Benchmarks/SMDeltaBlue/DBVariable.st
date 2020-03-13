"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #DBVariable,
	#superclass : #Object,
	#instVars : [
		'constraints',
		'determinedBy',
		'mark',
		'stay',
		'value',
		'walkStrength'
	],
	#category : #SMDeltaBlue
}

{ #category : #'instance creation' }
DBVariable class >> new [
	^self basicNew initialize
]

{ #category : #'instance creation' }
DBVariable class >> value: aValue [

	^self new value: aValue
]

{ #category : #accessing }
DBVariable >> addConstraint: aConstraint [
	"Add the given constraint to the set of all constraints that refer
	 to me."

	constraints add: aConstraint.
]

{ #category : #accessing }
DBVariable >> constraints [
	^ constraints
]

{ #category : #accessing }
DBVariable >> determinedBy [
	^ determinedBy
]

{ #category : #accessing }
DBVariable >> determinedBy: anObject [
	determinedBy := anObject
]

{ #category : #initialize }
DBVariable >> initialize [
	value := 0.
	constraints := OrderedCollection new: 2.
	determinedBy := nil.
	walkStrength := DBStrength absoluteWeakest.
	stay := true.
	mark := 0.
]

{ #category : #printing }
DBVariable >> longPrintOn: aStream [
	^ super longPrintOn: aStream
"	self shortPrintOn: aStream.
	aStream nextPutAll: '   Constraints: '.
	(constraints isEmpty)
		ifTrue: [aStream cr; tab; nextPutAll: 'none']
		ifFalse:
			[constraints do:
				[: c | aStream cr; tab. c shortPrintOn: aStream]].
	(determinedBy isNil) ifFalse:
		[aStream cr; nextPutAll: '   Determined by: '.
		 aStream cr; tab. determinedBy shortPrintOn: aStream].
	aStream cr."
]

{ #category : #accessing }
DBVariable >> mark [
	^ mark
]

{ #category : #accessing }
DBVariable >> mark: anObject [
	mark := anObject
]

{ #category : #printing }
DBVariable >> printOn: aStream [
	^ super printOn: aStream
	"self shortPrintOn: aStream"
]

{ #category : #accessing }
DBVariable >> removeConstraint: c [
	"Remove all traces of c from this variable."

	constraints remove: c ifAbsent: [].
	(determinedBy == c) ifTrue: [determinedBy := nil].
]

{ #category : #update }
DBVariable >> setValue: aValue [
	"Attempt to assign the given value to me using a strength of
	 #preferred."

	self setValue: aValue strength: #preferred.
]

{ #category : #update }
DBVariable >> setValue: aValue strength: strengthSymbol [
	"Attempt to assign the given value to me using the given strength."

	| editConstraint |
	editConstraint := DBEditConstraint var: self strength: strengthSymbol.
	(editConstraint isSatisfied) ifTrue:
		[self value: aValue.
		 DBPlanner propagateFrom: self].
	editConstraint destroyConstraint.
]

{ #category : #printing }
DBVariable >> shortPrintOn: aStream [
	^ super shortPrintOn: aStream.
"
	aStream nextPutAll: 'V(', self printString, ', '.
	aStream nextPutAll: walkStrength printString, ', '.
	(stay isNil) ifFalse:
		[aStream nextPutAll: (stay ifTrue: ['stay, '] ifFalse: ['changing, '])].
	aStream nextPutAll: value printString.
	aStream nextPutAll: ')'.
	aStream cr."
]

{ #category : #accessing }
DBVariable >> stay [
	^ stay
]

{ #category : #accessing }
DBVariable >> stay: aBoolean [
	stay := aBoolean
]

{ #category : #accessing }
DBVariable >> value [
	^ value
]

{ #category : #accessing }
DBVariable >> value: anObject [
	value := anObject
]

{ #category : #accessing }
DBVariable >> walkStrength [
	^ walkStrength
]

{ #category : #accessing }
DBVariable >> walkStrength: aStrength [
	walkStrength := aStrength
]

