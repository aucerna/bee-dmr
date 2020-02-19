Class {
	#name : #MethodDictionary,
	#superclass : #IdentityDictionary,
	#category : #Kernel
}

{ #category : #constants }
MethodDictionary class >> defaultSize [
	^4
]

{ #category : #private }
MethodDictionary class >> reserveSlot [
	self allInstances do: [:md | | selector cm |		selector := md contents at: 1.		cm := md contents at: 2.		selector notNil ifTrue: [md removeKey: selector].		md contents at: 1 put: 0.		md incrementTally.		selector notNil ifTrue: [md at: selector put: cm]]
]

{ #category : #accessing }
MethodDictionary >> at: aSymbol put: aCompiledMethod [
	^Smalltalk put: aCompiledMethod at: aSymbol in: self
]

{ #category : #private }
MethodDictionary >> basicAt: aSymbol put: aCompiledMethod [
	[		(table atKey: aSymbol put: aCompiledMethod) == nil			ifTrue: [self incrementTally]] evaluateAtomically.	^aCompiledMethod
]

{ #category : #private }
MethodDictionary >> basicRemoveKey: aSymbol ifAbsent: aBlock [
	| copy |	(self includesKey: aSymbol) ifFalse: [^aBlock value].	self flushCache: aSymbol.	copy := MethodDictionary new.	self		keysAndValuesDo: [:selector :cm | selector == aSymbol			ifFalse: [copy basicAt: selector put: cm]].	[		table := copy contents owner: self.		tally := copy size] evaluateAtomically.	^aSymbol
]

{ #category : #private }
MethodDictionary >> contentOfSize: anInteger [
	| modulo |	modulo := self moduloFor: anInteger.	^(self bucketClass basicNew: modulo * 2) owner: self
]

{ #category : #copying }
MethodDictionary >> copy [
	^self objectShallowCopy postCopy
]

{ #category : #private }
MethodDictionary >> flushCache [
	self keysDo: [:selector | self flushCache: selector]
]

{ #category : #private }
MethodDictionary >> flushCache: aSymbol [
	GlobalDispatchCache current flush: aSymbol forSpecies: class.	SendSite flush: aSymbol
]

{ #category : #private }
MethodDictionary >> hashFor: object [
	^object basicHash
]

{ #category : #testing }
MethodDictionary >> isMethodDictionary [
	^true
]

{ #category : #private }
MethodDictionary >> moduloFor: size [
	| last powers |	powers := #(4 8 16 32 64 128 256 512 1024 2048 4096).	powers do: [:number | size < number ifTrue: [^number]].	last := powers last.	[size < last] whileFalse: [last := last * 2].	^last
]

{ #category : #copying }
MethodDictionary >> postCopy [
	table := table copy owner: self
]

{ #category : #removing }
MethodDictionary >> removeKey: aSymbol ifAbsent: aBlock [
	^Smalltalk removeKey: aSymbol from: self ifAbsent: aBlock
]

