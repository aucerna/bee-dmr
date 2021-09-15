"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #PinnedAllocator,
	#superclass : #Allocator,
	#category : #Kernel
}

{ #category : #copying }
PinnedAllocator >> allocate: anInteger [
	^memory pinnedAllocate: anInteger
]

