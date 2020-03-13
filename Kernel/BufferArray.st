"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #BufferArray,
	#superclass : #MemoryBuffer,
	#instVars : [
		'count',
		'type'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
BufferArray class >> at: anExternalMemory count: anInteger type: aClass [
	| array |
	array := self atMemory: anExternalMemory.
	^array count: anInteger; type: aClass
]

{ #category : #private }
BufferArray class >> convert: aCollection to: type [
	aCollection isEmpty ifTrue: [^aCollection].
	(aCollection first isKindOf: type) ifTrue: [^aCollection].
	^aCollection collect: [:object | type from: object]
]

{ #category : #'instance creation' }
BufferArray class >> externalNew: count of: aClass [
	| array |
	array := self external: count * aClass sizeInBytes.
	^array count: count; type: aClass
]

{ #category : #'instance creation' }
BufferArray class >> externalOn: aCollection type: aClass [
	^self on: aCollection type: aClass external: true
]

{ #category : #'instance creation' }
BufferArray class >> externalOn: aCollection type: aClass size: anInteger [
	^self
		on: aCollection
		type: aClass
		external: true
		size: anInteger
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
	size := self sizeOf: aCollection type: aClass.
	^self
		on: aCollection
		type: aClass
		external: aBoolean
		size: size
]

{ #category : #private }
BufferArray class >> on: aCollection
type: aClass
external: aBoolean
size: anInteger [
	| buffer |
	buffer := aBoolean
		ifTrue: [self external: anInteger]
		ifFalse: [self new: anInteger].
	^buffer
		count: aCollection size;
		type: aClass;
		withAll: aCollection
]

{ #category : #private }
BufferArray class >> sizeOf: aCollection type: aClass [
	| collection size |
	aClass hasFixedSize ifTrue: [^aClass sizeInBytes * aCollection size].
	collection := self convert: aCollection to: aClass.
	size := 0.
	collection do: [:struct | size := size + struct sizeInBytes].
	^size
]

{ #category : #services }
BufferArray >> asArray [
	^self asArrayOf: type count: count
]

{ #category : #services }
BufferArray >> asArrayOf: aClass [
	count isNil ifTrue: [count := contents size // aClass sizeInBytes].
	^self asArrayOf: aClass count: count
]

{ #category : #services }
BufferArray >> asArrayOf: aClass count: n [
	| offset length |
	offset := 0.
	length := aClass sizeInBytes.
	^(1 to: n) collect: [:i | | data |
		data := self bytesAtOffset: offset count: length.
		offset := offset + length.
		aClass usingBytes: data asByteArray]
]

{ #category : #accessing }
BufferArray >> at: index [
	(index between: 1 and: count) ifFalse: [^self error: 'error in bounds'].
	type hasFixedSize
		ifTrue: [^self at: index fixedSize: self entrySize]
		ifFalse: [self error: 'cannot use indexed access']
]

{ #category : #private }
BufferArray >> at: index fixedSize: n [
	| offset struct |
	offset := index - 1 * n.
	self isInExternalMemory ifTrue: [^type atMemory: contents + offset].
	struct := type new: n.
	^struct fillFrom: contents startingAt: offset + 1
]

{ #category : #accessing }
BufferArray >> at: index putStruct: anExternalStructure [
	| n offset |
	n := type sizeInBytes.
	anExternalStructure class == type ifFalse: [self error: 'wrong object'].
	anExternalStructure sizeInBytes = n
		ifFalse: [self error: 'wrong data size'].
	offset := index - 1 * n.
	contents
		replaceFrom: offset + 1
		to: offset + n
		with: anExternalStructure contents
		startingAt: 1
]

{ #category : #testing }
BufferArray >> canOptimizeConversion [
	^type hasFixedSize and: [type canUnderstand: #from:]
]

{ #category : #enumerating }
BufferArray >> collect: aBlock [
	| result value |
	result := OrderedCollection new.
	self do: [:each | 
		value := aBlock evaluateWith: each.
		result add: value].
	^result
]

{ #category : #private }
BufferArray >> convert: aCollection [
	aCollection isEmpty ifTrue: [^aCollection].
	(aCollection first isKindOf: type) ifTrue: [^aCollection].
	^aCollection collect: [:element | type from: element]
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
		si := self at: i.
		aBlock evaluateWith: si]
]

{ #category : #private }
BufferArray >> entrySize [
	| struct |
	type hasFixedSize ifTrue: [^type sizeInBytes].
	struct := type usingBytes: contents.
	^struct sizeInBytes
]

{ #category : #services }
BufferArray >> externalCopy [
	| copy |
	self isInExternalMemory ifTrue: [^self].
	copy := super externalCopy.
	^copy type: type; count: count
]

{ #category : #private }
BufferArray >> fastWithAll: aCollection [
	| n offset converted auxiliary |
	aCollection isEmpty ifTrue: [^self].
	n := type sizeInBytes.
	offset := 1.
	converted := aCollection anyone isKindOf: type.
	converted ifFalse: [auxiliary := type new].
	aCollection do: [:each | | struct |
		struct := converted ifTrue: [each] ifFalse: [auxiliary from: each].
		contents
			replaceFrom: offset
			to: offset + n - 1
			with: struct asParameter
			startingAt: 1.
		offset := offset + n]
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
	type := aClass.
	count := aCollection size.
	collection := self convert: aCollection.
	size := self class sizeOf: collection type: type.
	contents := ByteArray new: size.
	self withAll: collection
]

{ #category : #copying }
BufferArray >> shallowLocalCopy [
	| copy |
	copy := super shallowLocalCopy.
	^copy type: type; count: count
]

{ #category : #accessing }
BufferArray >> sizeInBytes [
	^self isInExternalMemory
		ifTrue: [count * type sizeInBytes]
		ifFalse: [contents size]
]

{ #category : #accessing }
BufferArray >> type: aClass [
	type := aClass
]

{ #category : #private }
BufferArray >> withAll: aCollection [
	| collection offset |
	self canOptimizeConversion ifTrue: [^self fastWithAll: aCollection].
	collection := self convert: aCollection.
	offset := 1.
	collection do: [:struct | | n |
		n := struct sizeInBytes.
		contents
			replaceFrom: offset
			to: offset + n - 1
			with: struct asParameter
			startingAt: 1.
		offset := offset + n]
]

