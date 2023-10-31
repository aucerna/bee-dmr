"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIGreaterThan,
	#superclass : #OSMICompare,
	#category : #IR
}

{ #category : #initialization }
OSMIGreaterThan >> initialize [
	name := #_smiGreaterThan:.
	super initialize
]

{ #category : #arithmetic }
OSMIGreaterThan >> inverted [
	^OSMILessThan left: right right: left
]

{ #category : #arithmetic }
OSMIGreaterThan >> negated [
	^OSMILessEqualThan left: left right: right
]

