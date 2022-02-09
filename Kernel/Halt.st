"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Halt,
	#superclass : #Exception,
	#category : #Kernel
}

{ #category : #accessing }
Halt >> defaultDescription [
	^'halt'
]

