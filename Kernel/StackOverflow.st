"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #StackOverflow,
	#superclass : #Error,
	#category : #Kernel
}

{ #category : #accessing }
StackOverflow >> defaultDescription [
	^'Stack overflow'
]

