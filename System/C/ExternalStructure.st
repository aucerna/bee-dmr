"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Extension { #name : #ExternalStructure }

{ #category : '*C' }
ExternalStructure class >> def [
	^''
]

{ #category : '*C' }
ExternalStructure class >> generate [
	self typedef generate.
	self typedef64 writeOffsets64
]

{ #category : '*C' }
ExternalStructure class >> initializeOffsets [
	| cls cvars offsets pd |
	self ASSERT: self !== WindowsStructure.
	self ASSERT: self !== ExternalStructure.
	cls := self.
	[cls isNil or: [cls classVariables includesKey: 'Offsets']]
		whileFalse: [cls := cls superclass].
	cls isNil ifTrue: [cls := self].
	cvars := cls classVariables.
	offsets := PoolDictionary new.
	pd := cvars at: 'Offsets' ifAbsent: nil.
	pd isNil ifTrue: [pd := cvars at: 'Offsets' put: offsets].
	cls instVarNamed: 'classVariables' put: cvars.
	self initializeOffsets: offsets.
	offsets !== pd ifTrue: [offsets keysAndValuesDo: [:k :v | pd at: k put: v]]
]

{ #category : '*C' }
ExternalStructure class >> initializeOffsets: aPoolDictionary [
	self structDeclaration writeOffsetsOn: aPoolDictionary
]

