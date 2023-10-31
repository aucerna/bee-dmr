"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMIGreaterEqualThan,
	#superclass : #OSMICompare,
	#category : #IR
}

{ #category : #initialization }
OSMIGreaterEqualThan >> initialize [
	name := #_smiGreaterEqualThan:.
	super initialize
]

{ #category : #arithmetic }
OSMIGreaterEqualThan >> inverted [
	^OSMILessEqualThan left: right right: left
]

{ #category : #arithmetic }
OSMIGreaterEqualThan >> negated [
	^OSMILessThan left: left right: right
]

