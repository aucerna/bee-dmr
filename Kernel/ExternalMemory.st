"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ExternalMemory,
	#superclass : #Object,
	#instVars : [
		'address'
	],
	#classVars : [
		'NullAddress'
	],
	#category : #Kernel
}

{ #category : #inspecting }
ExternalMemory class >> aspects [
	^#(#asInteger)
]

{ #category : #'instance creation' }
ExternalMemory class >> at: anInteger [
	^self new address: anInteger
]

{ #category : #'instance creation' }
ExternalMemory class >> fromByteArray: aByteArray [
	| count memory |
	count := aByteArray sizeInBytes.
	memory := self allocate: count.
	^memory replaceBytesUpTo: count with: aByteArray
]

{ #category : #'instance creation' }
ExternalMemory class >> fromString: aString [
	| bytes extra memory |
	bytes := aString sizeInBytes.
	extra := aString characterSize.
	memory := self allocate: bytes + extra.
	memory replaceBytesUpTo: bytes with: aString.
	^memory
]

{ #category : #testing }
ExternalMemory class >> hasFixedSize [
	^self hasVariableSize not
]

{ #category : #testing }
ExternalMemory class >> hasVariableSize [
	^false
]

{ #category : #initialization }
ExternalMemory class >> initializeConstants [
	NullAddress := ByteArray new: WordSize
]

{ #category : #accessing }
ExternalMemory class >> sizeInBytes [
	^WordSize
]

{ #category : #arithmetic }
ExternalMemory >> - anInteger [
	^self + anInteger negated
]

{ #category : #arithmetic }
ExternalMemory >> + anInteger [
	^ExternalMemory at: self asInteger + anInteger
]

{ #category : #comparing }
ExternalMemory >> = anExternalMemory [
	self class == anExternalMemory class ifFalse: [^false].
	^address = anExternalMemory contents
]

{ #category : #private }
ExternalMemory >> address: anInteger [
	address pointerAtOffset: 0 put: anInteger
]

{ #category : #converting }
ExternalMemory >> asInteger [
	^self asUnsignedInteger
]

{ #category : #converting }
ExternalMemory >> asParameter [
	^address
]

{ #category : #converting }
ExternalMemory >> asUnsignedInteger [
	^address pointerAtOffset: 0
]

{ #category : #accessing }
ExternalMemory >> at: index [
	^self byteAtOffset: index - 1
]

{ #category : #accessing }
ExternalMemory >> at: index ifAbsent: aBlock [
	index > self length ifTrue: [^aBlock value].
	^self at: index
]

{ #category : #accessing }
ExternalMemory >> at: index put: byte [
	^self byteAtOffset: index - 1 put: byte
]

{ #category : #accessing }
ExternalMemory >> byteAt: anInteger [
	^self byteAtOffset: anInteger - 1
]

{ #category : #accessing }
ExternalMemory >> byteAt: anInteger put: byte [
	^self byteAtOffset: anInteger - 1 put: byte
]

{ #category : #accessing }
ExternalMemory >> byteAtOffset: offset [
	^(address _basicAt: 1) _byteAt: offset + 1
]

{ #category : #private }
ExternalMemory >> byteAtOffset: offset put: byte [
	^(address _basicAt: 1) _byteAt: offset + 1 put: byte
]

{ #category : #services }
ExternalMemory >> bytes [
	self subclassResponsibility
]

{ #category : #services }
ExternalMemory >> clear: n [
	| blank |
	blank := ByteArray new: n.
	self replaceFrom: 1 to: n with: blank startingAt: 1
]

{ #category : #accessing }
ExternalMemory >> contents [
	^address
]

{ #category : #copying }
ExternalMemory >> copy [
	^self shouldNotImplement
]

{ #category : #copying }
ExternalMemory >> copyFrom: start to: stop [
	| size |
	size := stop - start + 1.
	^(ByteArray new: size)
		replaceFrom: 1
		to: size
		with: self
		startingAt: start
]

{ #category : #services }
ExternalMemory >> externalCopy [
	^self
]

{ #category : #finalization }
ExternalMemory >> finalizationRegistry [
	^Smalltalk resourceRegistry
]

{ #category : #finalization }
ExternalMemory >> finalize [
	^self release
]

{ #category : #finalization }
ExternalMemory >> free [
	self release; ignoreFinalization
]

{ #category : #comparing }
ExternalMemory >> hash [
	^address hash
]

{ #category : #inquiries }
ExternalMemory >> indexOf: byte [
	| offset |
	offset := 0.
	[
		(self byteAtOffset: offset) = byte ifTrue: [^offset + 1].
		offset := offset + 1] repeat
]

{ #category : #inquiries }
ExternalMemory >> indexOf: byte
between: start
and: end
ifAbsent: aBlock [
	| index |
	index := start.
	[index <= end] whileTrue: [
		(self at: index) = byte ifTrue: [^index].
		index := index + 1].
	^aBlock value
]

{ #category : #inquiries }
ExternalMemory >> indexOf: byte startingAt: start ifAbsent: aBlock [
	^self indexOf: byte between: start and: self length ifAbsent: aBlock
]

{ #category : #inquiries }
ExternalMemory >> indexOfSubcollection: aCollection
from: start
to: stop
td1: aDictionary [
	| m k |
	m := aCollection sizeInBytes.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i object delta |
		i := 1.
		[i <= m and: [(aCollection at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		object := self at: k + m.
		delta := aDictionary at: object ifAbsent: [m + 1].
		delta isNil ifTrue: [delta := m + 1].
		k := k + delta].
	^0
]

{ #category : #initialization }
ExternalMemory >> initialize [
	super initialize.
	address := ByteArray new: self class sizeInBytes
]

{ #category : #accessing }
ExternalMemory >> invalidate [
	self address: 0
]

{ #category : #testing }
ExternalMemory >> isExternalMemory [
	^true
]

{ #category : #testing }
ExternalMemory >> isValid [
	^address != NullAddress
]

{ #category : #private }
ExternalMemory >> largeAtOffset: offset [
	offset _isSmallInteger
		ifFalse: [^self error: offset printString , ' must be an SmallInteger'].
	(offset < 0 or: [offset + 8 > self length])
		ifTrue: [^self error: 'out of bounds'].
	^(self objectAtValidOffset: offset) _asSmallInteger
]

{ #category : #accessing }
ExternalMemory >> length [
	^nil
]

{ #category : #accessing }
ExternalMemory >> longAtOffset: offset [
	offset _isSmallInteger
		ifFalse: [^self error: offset printString , ' should be an SmallInteger'].
	^self longAtValidOffset: offset
]

{ #category : #accessing }
ExternalMemory >> longAtOffset: offset put: integer [
	integer < 0
		ifTrue: [self uLongAtOffset: offset put: integer + 16r100000000]
		ifFalse: [self uLongAtOffset: offset put: integer]
]

{ #category : #accessing }
ExternalMemory >> longAtValidOffset: offset [
	| lo hi sign |
	lo := self uShortAtOffset: offset.
	hi := self uShortAtOffset: offset + 2.
	sign := hi bitAnd: 16r8000.
	hi := hi - (sign * 2).
	^hi * 16r10000 + lo
]

{ #category : #services }
ExternalMemory >> makeBytes [
	| bytes |
	bytes := self bytes.
	self free.
	^bytes
]

{ #category : #services }
ExternalMemory >> makeFloat [
	^Float fromByteArray: self makeBytes
]

{ #category : #services }
ExternalMemory >> makeString [
	| string |
	string := String fromMemory: self.
	self free.
	^string
]

{ #category : #services }
ExternalMemory >> makeULong [
	| ulong |
	ulong := self uLongAtOffset: 0.
	self free.
	^ulong
]

{ #category : #services }
ExternalMemory >> makeUnicode [
	| unicode |
	unicode := WideString fromMemory: self.
	self free.
	^unicode
]

{ #category : #private }
ExternalMemory >> objectAtValidOffset: offset [
	^(address _basicAt: 1) _objectAtOffset: offset
]

{ #category : #converting }
ExternalMemory >> pointedMemory [
	^self
]

{ #category : #accessing }
ExternalMemory >> uLargeAtOffset: offset [
	^((address _basicAt: 1) _primitiveULargeAtOffset: offset) ifNil: [
		(address _basicAt: 1)
			_primitiveULargeAtOffset: offset
			into: (LargePositiveInteger new: 8)]
]

{ #category : #accessing }
ExternalMemory >> uLargeAtOffset: offset put: anInteger [
	^(address _basicAt: 1) _primitiveULargeAtOffset: offset put: anInteger
]

{ #category : #printing }
ExternalMemory >> printOn: aStream [
	| hex |
	aStream nextPutAll: self class name , '{'.
	hex := self isValid
		ifTrue: [self asInteger printPaddedWith: $0 to: 8 base: 16]
		ifFalse: ['invalid'].
	aStream nextPutAll: hex; nextPut: $}
]

{ #category : #converting }
ExternalMemory >> readStream [
	| stream |
	stream := InternalReadStream on: self.
	^stream readLimit: SmallInteger maximum
]

{ #category : #finalization }
ExternalMemory >> release [
	self releaseMemory; invalidate
]

{ #category : #finalization }
ExternalMemory >> releaseMemory [
	"
	default is do nothing
	"
	
]

{ #category : #accessing }
ExternalMemory >> replaceBytesUpTo: count with: aCollection [
	^self replaceBytesFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #accessing }
ExternalMemory >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ExternalMemory >> replaceFrom: start
to: stop
with: anObject
startingAt: position [
	| pos |
	pos := anObject isUnicodeString
		ifTrue: [anObject indexAt: position]
		ifFalse: [position].
	self
		replaceBytesFrom: start
		to: stop
		with: anObject
		startingAt: pos
]

{ #category : #accessing }
ExternalMemory >> segmentFrom: index size: size [
	^ByteArraySegment on: self from: index size: size
]

{ #category : #finalization }
ExternalMemory >> sessionShutdown [
	self ignoreFinalization
]

{ #category : #startup }
ExternalMemory >> sessionStartup [
	self invalidate
]

{ #category : #accessing }
ExternalMemory >> size [
	^address size
]

{ #category : #accessing }
ExternalMemory >> sizeInBytes [
	^self class sizeInBytes
]

{ #category : #converting }
ExternalMemory >> smallPointer [
	^address smallPointerAtOffset: 0
]

{ #category : #converting }
ExternalMemory >> smallPointer: anInteger [
	^address smallPointerAtOffset: 0 put: anInteger
]

{ #category : #accessing }
ExternalMemory >> smallPointerAtOffset: offset [
	| low high |
	WordSize = 8 ifTrue: [^(self pointerAtOffset: offset) // 2].
	low := self uShortAtOffset: offset.
	low := low bitShift: -1.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 15.
	^high + low
]

{ #category : #accessing }
ExternalMemory >> smallPointerAtOffset: offset put: anInteger [
	| low high |
	WordSize = 8 ifTrue: [^self pointerAtOffset: offset put: anInteger * 2].
	low := anInteger bitAnd: 0xFFFF.
	low := low bitShift: 1.
	low := low bitAnd: 0xFFFF.
	self uShortAtOffset: offset put: low.
	high := anInteger bitShift: -15.
	self uShortAtOffset: offset + 2 put: high
]

{ #category : #accessing }
ExternalMemory >> uLargeAtOffset: offset [
	^((address _basicAt: 1) _primitiveULargeAtOffset: offset) ifNil: [
		(address _basicAt: 1)
			_primitiveULargeAtOffset: offset
			into: (LargePositiveInteger new: 8)]
]

{ #category : #accessing }
ExternalMemory >> uLargeAtOffset: offset put: anInteger [
	^(address _basicAt: 1) _primitiveULargeAtOffset: offset put: anInteger
]

{ #category : #accessing }
ExternalMemory >> uLongAtOffset: offset [
	^((address _basicAt: 1) _primitiveULongAtOffset: offset) ifNil: [
		(address _basicAt: 1)
			_primitiveULongAtOffset: offset
			into: (LargePositiveInteger new: 4)]
]

{ #category : #accessing }
ExternalMemory >> uLongAtOffset: offset put: anInteger [
	^(address _basicAt: 1) _primitiveULongAtOffset: offset put: anInteger
]

{ #category : #accessing }
ExternalMemory >> uShortAtOffset: offset [
	^(self byteAtOffset: offset) + ((self byteAtOffset: offset + 1) bitShift: 8)
]

{ #category : #accessing }
ExternalMemory >> uShortAtOffset: offset put: integer [
	self
		byteAtOffset: offset put: (integer bitAnd: 16rFF);
		byteAtOffset: offset + 1 put: ((integer bitShift: -8) bitAnd: 16rFF)
]

{ #category : #accessing }
ExternalMemory >> uShortAtValidOffset: offset [
	^(self byteAtOffset: offset + 1) * 16r100 + (self byteAtOffset: offset)
]

{ #category : #services }
ExternalMemory >> writeStream [
	| writer |
	writer := InternalWriteStream on: self.
	writer writeLimit: self length.
	^writer
]

