"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Error,
	#superclass : #Exception,
	#category : #Kernel
}

{ #category : #testing }
Error >> isResumable [
	^false
]

