"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMINegate,
	#superclass : #OUnaryOperation,
	#category : #IR
}

{ #category : #initialization }
OSMINegate >> initialize [
	name := #_smiNegate.
	super initialize
]

