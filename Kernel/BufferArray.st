Class {
	#name : #BufferArray,
	#superclass : #MemoryBuffer,
	#instVars : [
		'#count',
		'#type'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
BufferArray class >> at: anExternalMemory count: anInteger type: aClass [
	| array |
]

{ #category : #private }
BufferArray class >> convert: aCollection to: type [
	aCollection isEmpty ifTrue: [^aCollection].
]

{ #category : #'instance creation' }
BufferArray class >> externalNew: count of: aClass [
	| array |
]

{ #category : #'instance creation' }
BufferArray class >> externalOn: aCollection type: aClass [
	^self on: aCollection type: aClass external: true
]

{ #category : #'instance creation' }
BufferArray class >> externalOn: aCollection type: aClass size: anInteger [
	^self
]

{ #category : #'instance creation' }
BufferArray class >> new [
	^self new: 0
]

{ #category : #'instance creation' }
BufferArray class >> on: aCollection [
	^self new on: aCollection
]

{ #category : #'instance creation' }
BufferArray class >> on: aCollection type: aClass [
	^self on: aCollection type: aClass external: false
]

{ #category : #private }
BufferArray class >> on: aCollection type: aClass external: aBoolean [
	| size |
]

{ #category : #private }
BufferArray class >> on: aCollection
	| buffer |
]

{ #category : #private }
BufferArray class >> sizeOf: aCollection type: aClass [
	| collection size |
]

{ #category : #services }
BufferArray >> asArray [
	^self asArrayOf: type count: count
]

{ #category : #services }
BufferArray >> asArrayOf: aClass [
	count isNil ifTrue: [count := contents size // aClass sizeInBytes].
]

{ #category : #services }
BufferArray >> asArrayOf: aClass count: n [
	| offset length |
]

{ #category : #accessing }
BufferArray >> at: index [
	(index between: 1 and: count) ifFalse: [^self error: 'error in bounds'].
]

{ #category : #private }
BufferArray >> at: index fixedSize: n [
	| offset struct |
]

{ #category : #accessing }
BufferArray >> at: index putStruct: anExternalStructure [
	| n offset |
]

{ #category : #testing }
BufferArray >> canOptimizeConversion [
	^type hasFixedSize and: [type canUnderstand: #from:]
]

{ #category : #enumerating }
BufferArray >> collect: aBlock [
	| result value |
]

{ #category : #private }
BufferArray >> convert: aCollection [
	aCollection isEmpty ifTrue: [^aCollection].
]

{ #category : #accessing }
BufferArray >> count [
	^count
]

{ #category : #accessing }
BufferArray >> count: anInteger [
	count := anInteger
]

{ #category : #enumerating }
BufferArray >> do: aBlock [
	1 to: count do: [:i | | si |
]

{ #category : #private }
BufferArray >> entrySize [
	| struct |
]

{ #category : #services }
BufferArray >> externalCopy [
	| copy |
]

{ #category : #private }
BufferArray >> fastWithAll: aCollection [
	| n offset converted auxiliary |
]

{ #category : #accessing }
BufferArray >> length [
	^self sizeInBytes
]

{ #category : #private }
BufferArray >> on: aCollection [
	self on: aCollection type: aCollection anyone class
]

{ #category : #private }
BufferArray >> on: aCollection type: aClass [
	| size collection |
]

{ #category : #copying }
BufferArray >> shallowLocalCopy [
	| copy |
]

{ #category : #accessing }
BufferArray >> sizeInBytes [
	^self isInExternalMemory
]

{ #category : #accessing }
BufferArray >> type: aClass [
	type := aClass
]

{ #category : #private }
BufferArray >> withAll: aCollection [
	| collection offset |
]
