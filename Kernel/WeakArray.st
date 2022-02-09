"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #WeakArray,
	#superclass : #Array,
	#type : #variable,
	#category : #Kernel
}

{ #category : #'instance creation' }
WeakArray class >> new: anInteger [
	| array |
	array := super new: anInteger.
	array beWeak.
	^array
]

