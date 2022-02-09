"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #DummyGlobalDispatchCache,
	#superclass : #GlobalDispatchCache,
	#category : #Kernel
}

{ #category : #services }
DummyGlobalDispatchCache >> lookupAndCache: selector in: aBehavior [
	^self _lookup: selector in: aBehavior
]

