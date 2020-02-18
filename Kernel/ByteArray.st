Class {
	#name : #ByteArray,
	#superclass : #ArrayedCollection,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #'instance creation' }
ByteArray class >> fromBytes: anObject length: anInteger [
	| bytes |
]

{ #category : #'instance creation' }
ByteArray class >> fromMemory: anExternalMemory length: anInteger [
	^self fromBytes: anExternalMemory length: anInteger
]

{ #category : #converting }
ByteArray >> asByteArray [
	^self
]

{ #category : #converting }
ByteArray >> asExternalHandle [
	^ExternalHandle fromBytes: self
]

{ #category : #converting }
ByteArray >> asExternalInt32 [
	^ExternalInt32 fromBytes: self
]

{ #category : #converting }
ByteArray >> asParameter [
	^self
]

{ #category : #converting }
ByteArray >> asString [
	| string n |
]

{ #category : #printing }
ByteArray >> basicPrintOn: aStream [
	self printOn: aStream base: 16
]

{ #category : #printing }
ByteArray >> basicPrintTextOn: rtf [
	self printOn: rtf base: 16
]

{ #category : #converting }
ByteArray >> binaryReadStream [
	^self readStream
]

{ #category : #printing }
ByteArray >> canBePrintedAsLiteral [
	^true
]

{ #category : #copying }
ByteArray >> copyToGlobalMemory [
	^GlobalMemory fromByteArray: self
]

{ #category : #copying }
ByteArray >> copyToMemory: anExternalMemory [
	anExternalMemory replaceFrom: 1 to: self size with: self startingAt: 1
]

{ #category : #services }
ByteArray >> eol [
	| n byte |
]

{ #category : #copying }
ByteArray >> externalCopy [
	^ExternalMemory fromByteArray: self
]

{ #category : #comparing }
ByteArray >> goodHash [
	| hash |
]

{ #category : #comparing }
ByteArray >> hash [
	| hash |
]

{ #category : #printing }
ByteArray >> integerAt: i bytes: n [
	| word m |
]

{ #category : #testing }
ByteArray >> isByteArray [
	^true
]

{ #category : #testing }
ByteArray >> isValid [
	^true
]

{ #category : #marshalling }
ByteArray >> largeAtOffset: offset [
	| integer lo hi |
]

{ #category : #marshalling }
ByteArray >> primitiveLongAtOffset: [
offset
]

{ #category : #marshalling }
ByteArray >> longAtOffset: offset put: anInteger [
	| ulong |
]

{ #category : #converting }
ByteArray >> pointedMemory [
	^ExternalMemory at: self
]

{ #category : #marshalling }
ByteArray >> primitiveULargeAtOffset: [
offset
]

{ #category : #marshalling }
ByteArray >> primitiveULargeAtOffset: offset [
put: anInteger
]

{ #category : #printing }
ByteArray >> printOn: aStream base: anInteger [
	aStream nextPutAll: '#['.
]

{ #category : #replacing }
ByteArray >> replaceBytesUpTo: count with: aCollection [
	^self replaceBytesFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFrom: start to: stop with: aCollection [
	stop - start + 1 <= aCollection sizeInBytes
]

{ #category : #replacing }
ByteArray >> replaceFrom: start
	| pos |
]

{ #category : #converting }
ByteArray >> segmentFrom: index size: size [
	^ByteArraySegment on: self from: index size: size
]

{ #category : #marshalling }
ByteArray >> primitiveShortAtOffset: [
offset
]

{ #category : #accessing }
ByteArray >> sizeInBytes [
	^self size
]

{ #category : #accessing }
ByteArray >> smallPointerAtOffset: offset [
	| low high |
]

{ #category : #accessing }
ByteArray >> smallPointerAtOffset: offset put: anInteger [
	| low high |
]

{ #category : #printing }
ByteArray >> storeOn: aStream [
	self storeOn: aStream base: 16
]

{ #category : #printing }
ByteArray >> storeOn: aStream base: anInteger [
	aStream nextPutAll: '#['.
]

{ #category : #printing }
ByteArray >> storeOn: aStream base: base bytes: bytes [
	| limit digits width n stream end |
]

{ #category : #printing }
ByteArray >> storeStringBase: base [
	^self storeStringBase: base bytes: 1
]

{ #category : #printing }
ByteArray >> storeStringBase: base bytes: bytes [
	^String
]

{ #category : #accessing }
ByteArray >> uLargeAtOffset: offset [
	| low hi |
]

{ #category : #accessing }
ByteArray >> uLargeAtOffset: offset put: integer [
	| low hi |
]

{ #category : #marshalling }
ByteArray >> primitiveULongAtOffset: [
offset
]

{ #category : #marshalling }
ByteArray >> primitiveULongAtOffset: offset [
put: anInteger
]

{ #category : #marshalling }
ByteArray >> primitiveUShortAtOffset: [
offset
]

{ #category : #marshalling }
ByteArray >> primitiveUShortAtOffset: offset [
put: anInteger
]

{ #category : #accessing }
ByteArray >> utf16 [
	^UTF16 current decode: self
]
