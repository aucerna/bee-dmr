"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OPushOperation,
	#superclass : #OUnaryOperation,
	#category : #IR
}

{ #category : #initialization }
OPushOperation >> initialize [
	name := #push.
	super initialize
]

