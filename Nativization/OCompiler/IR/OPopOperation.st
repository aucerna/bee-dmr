"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OPopOperation,
	#superclass : #ONullaryOperation,
	#category : #IR
}

{ #category : #initialization }
OPopOperation >> initialize [
	name := #pop.
	super initialize
]

