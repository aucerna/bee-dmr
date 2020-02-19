Class {
	#name : #DummyGlobalDispatchCache,
	#superclass : #GlobalDispatchCache,
	#category : #Kernel
}

{ #category : #services }
DummyGlobalDispatchCache >> lookupAndCache: selector in: aProtocol [
	^self _lookup: selector in: aProtocol
]

