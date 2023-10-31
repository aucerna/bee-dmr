"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ONotEquals,
	#superclass : #OCompare,
	#category : #IR
}

{ #category : #initialization }
ONotEquals >> initialize [
	name := #_notEquals:.
	super initialize
]

{ #category : #arithmetic }
ONotEquals >> negated [
	^OEquals left: left right: right
]

