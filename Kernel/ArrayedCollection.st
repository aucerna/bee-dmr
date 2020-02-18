Class {
	#name : #ArrayedCollection,
	#superclass : #SequenceableCollection,
	#category : #Kernel
}

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject [
	| array |
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject [
	| array |
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject with: thirdObject [
	| array |
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject
	| array |
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject withAll: aCollection [
	| array |
]

{ #category : #'instance creation' }
ArrayedCollection class >> withAll: aCollection with: anObject [
	| instance |
]

{ #category : #adding }
ArrayedCollection >> add: anObject [
	^self shouldNotImplement
]

{ #category : #enumerating }
ArrayedCollection >> collect: aBlock [
	| array size |
]

{ #category : #enumerating }
ArrayedCollection >> collect: collectBlock thenSelect: selectBlock [
	| array size |
]

{ #category : #services }
ArrayedCollection >> concurrentCollect: aBlock [
	| answer size token |
]

{ #category : #copying }
ArrayedCollection >> copyReplaceFrom: start to: stop with: aCollection [
	| copy n size |
]

{ #category : #copying }
ArrayedCollection >> deepCopy [
	^self objectDeepCopy
]

{ #category : #accessing }
ArrayedCollection >> longAtValidOffset: offset [
	| lo hi sign |
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULargeAtOffset: [
offset
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULargeAtOffset: offset [
put: anInteger
]

{ #category : #unclassified }
ArrayedCollection >> primitiveLongAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveShortAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULargeAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULargeAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULongAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULongAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveUShortAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveUShortAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
]

{ #category : #removing }
ArrayedCollection >> remove: anObject ifAbsent: aBlock [
	^self shouldNotImplement
]

{ #category : #accessing }
ArrayedCollection >> reversed [
	| limit result |
]

{ #category : #enumerating }
ArrayedCollection >> select: aBlock [
	| size selected |
]

{ #category : #enumerating }
ArrayedCollection >> select: selectBlock thenCollect: collectBlock [
	| size selected |
]

{ #category : #unclassified }
ArrayedCollection >> primitiveShortAtOffset: [
offset
]

{ #category : #accessing }
ArrayedCollection >> shortAtValidOffset: offset [
	| lo hi sign |
]

{ #category : #accessing }
ArrayedCollection >> size [
	^self primitiveSize
]

{ #category : #printing }
ArrayedCollection >> storeOn: aStream [
	| size index firstTime |
]

{ #category : #private }
ArrayedCollection >> uLargeAtValidOffset: offset [
	^(self _uLargeAtOffset: offset)
]

{ #category : #unclassified }
ArrayedCollection >> uLargeAtValidOffset: offset put: anInteger [
	anInteger size > 8 ifTrue: [self error: 'does not fit in 64 bits'].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULongAtOffset: [
offset
]

{ #category : #unclassified }
ArrayedCollection >> primitiveULongAtOffset: offset [
put: anInteger
]

{ #category : #accessing }
ArrayedCollection >> uLongAtValidOffset: offset [
	^(self _uLongAtOffset: offset)
]

{ #category : #accessing }
ArrayedCollection >> uLongAtValidOffset: offset put: anInteger [
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
]

{ #category : #unclassified }
ArrayedCollection >> primitiveUShortAtOffset: [
offset
]

{ #category : #unclassified }
ArrayedCollection >> primitiveUShortAtOffset: offset [
put: anInteger
]

{ #category : #accessing }
ArrayedCollection >> uShortAtValidOffset: offset [
	^(self byteAtValid: offset + 2) * 16r100 + (self byteAtValid: offset + 1)
]

{ #category : #unclassified }
ArrayedCollection >> uShortAtValidOffset: offset put: anInteger [
	anInteger size > 2 ifTrue: [self error: 'does not fit in 16 bits'].
]

{ #category : #accessing }
ArrayedCollection >> validShortAtValidOffset: offset put: anInteger [
	| hi lo |
]

{ #category : #enumerating }
ArrayedCollection >> withIndexCollect: aBlock [
	| answer size |
]
