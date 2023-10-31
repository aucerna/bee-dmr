"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMILessThan,
	#superclass : #OSMICompare,
	#category : #IR
}

{ #category : #initialization }
OSMILessThan >> initialize [
	name := #_smiLessThan:.
	super initialize
]

{ #category : #arithmetic }
OSMILessThan >> inverted [
	^OSMIGreaterThan left: right right: left
]

{ #category : #arithmetic }
OSMILessThan >> negated [
	^OSMIGreaterEqualThan left: left right: right
]

