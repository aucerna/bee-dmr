"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #EndOfStream,
	#superclass : #Error,
	#category : #Kernel
}

{ #category : #accessing }
EndOfStream >> defaultDescription [
	^'end of stream'
]

