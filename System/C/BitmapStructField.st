Class {
	#name : #BitmapStructField,
	#superclass : #CStructField,
	#instVars : [
		'length'
	],
	#category : #C
}

{ #category : #testing }
BitmapStructField class >> accepts: aString [
	^aString includes: $:
]

{ #category : #offsets }
BitmapStructField >> alignAfter: displacement [
	offset := displacement
]

{ #category : #'source code' }
BitmapStructField >> getterSourceNamed: aString [
	^String streamContents: [:strm | 
		strm
			nextPutAll: aString;
			crtab;
			nextPutAll: '^self bits: (';
			nextPutAll: self stretch asString;
			nextPutAll: ') atOffset: ';
			nextPutAll: aString , ' // 4 * 4']
]

{ #category : #initialization }
BitmapStructField >> initialize [
	super initialize.
	length := 0
]

{ #category : #accessing }
BitmapStructField >> length [
	^length
]

{ #category : #accessing }
BitmapStructField >> length: anInteger [
	length := anInteger
]

{ #category : #printing }
BitmapStructField >> printOn: aStream indent: n [
	super printOn: aStream indent: n.
	aStream nextPutAll: ': '; nextPutAll: length asString.
	self printOffsetOn: aStream
]

{ #category : #printing }
BitmapStructField >> printTextOn: rtf indent: n [
	super printTextOn: rtf indent: n.
	rtf nextPutAll: ': '; nextPutAll: length asString.
	self printOffsetTextOn: rtf
]

{ #category : #'source code' }
BitmapStructField >> setterSourceNamed: aString [
	^String streamContents: [:strm | 
		strm
			nextPutAll: aString;
			nextPutAll: ': anInteger';
			crtab;
			nextPutAll: 'self bits: ';
			nextPut: $(;
			nextPutAll: self stretch asString;
			nextPutAll: ') atOffset: ';
			nextPutAll: aString;
			nextPutAll: ' // 4 * 4 put: anInteger']
]

{ #category : #accessing }
BitmapStructField >> sizeInBytes [
	^length / 8
]

{ #category : #initialization }
BitmapStructField >> stretch [
	| start |
	start := offset - offset floor * 8.
	^start thru: start + length - 1
]

