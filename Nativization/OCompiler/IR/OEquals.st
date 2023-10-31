"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OEquals,
	#superclass : #OCompare,
	#category : #IR
}

{ #category : #initialization }
OEquals >> initialize [
	name := #_equals:.
	super initialize
]

{ #category : #arithmetic }
OEquals >> negated [
	^ONotEquals left: left right: right
]

