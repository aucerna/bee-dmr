"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OCopyOperation,
	#superclass : #OUnaryOperation,
	#category : #IR
}

{ #category : #initialization }
OCopyOperation >> initialize [
	name := #copy.
	super initialize
]

