"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #AssertionFailure,
	#superclass : #Halt,
	#category : #Kernel
}

{ #category : #accessing }
AssertionFailure >> defaultDescription [
	^'assertion failed'
]

