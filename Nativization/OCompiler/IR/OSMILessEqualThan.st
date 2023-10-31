"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMILessEqualThan,
	#superclass : #OSMICompare,
	#category : #IR
}

{ #category : #initialization }
OSMILessEqualThan >> initialize [
	name := #_smiLessEqualThan:.
	super initialize
]

{ #category : #arithmetic }
OSMILessEqualThan >> inverted [
	^OSMIGreaterEqualThan left: right right: left
]

{ #category : #arithmetic }
OSMILessEqualThan >> negated [
	^OSMIGreaterThan left: left right: right
]

