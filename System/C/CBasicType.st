"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #CBasicType,
	#superclass : #CType,
	#instVars : [
		'name',
		'size',
		'sizeExpression'
	],
	#category : #C
}

{ #category : #testing }
CBasicType >> isUnresolved [
	^self isVoid
]

{ #category : #testing }
CBasicType >> isVoid [
	^name = 'void'
]

{ #category : #accessing }
CBasicType >> keyword [
	name = 'unsigned long' ifTrue: [^'uLongAtOffset:'].
	name = 'unsigned int' ifTrue: [^'uLongAtOffset:'].
	name = 'int' ifTrue: [^'longAtOffset:'].
	name = 'long' ifTrue: [^'longAtOffset:'].
	name = 'word' ifTrue: [^'uShortAtOffset:'].
	name = 'unsigned short' ifTrue: [^'uShortAtOffset:'].
	name = 'short' ifTrue: [^'shortAtOffset:'].
	name = 'char' ifTrue: [^'ansiAtOffset:'].
	name = 'unsigned char' ifTrue: [^'ansiAtOffset:'].
	name = 'wchar' ifTrue: [^'stringAtOffset:'].
	name = 'byte' ifTrue: [^'byteAtOffset:'].
	name = 'boolean' ifTrue: [^'booleanAtOffset:'].
	name = 'double' ifTrue: [^'floatAtOffset:'].
	name = 'ExternalFloat' ifTrue: [^'realAtOffset:'].
	name = 'large' ifTrue: [^'largeAtOffset:'].
	name = 'long long' ifTrue: [^'largeAtOffset:'].
	name = 'float' ifTrue: [^'realAtOffset:'].
	self ASSERT: false.
	^'uLongAtOffset:'
]

{ #category : #accessing }
CBasicType >> name [
	^name
]

{ #category : #accessing }
CBasicType >> name: aSymbol [
	name := aSymbol
]

{ #category : #printing }
CBasicType >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #printing }
CBasicType >> printTextOn: rtf [
	rtf useColor: PaintingVisitor new instVarColor while: [rtf italic: name]
]

{ #category : #accessing }
CBasicType >> size: anInteger [
	size := anInteger
]

{ #category : #accessing }
CBasicType >> sizeExpression [
	^sizeExpression ifNil: [size printString]
]

{ #category : #accessing }
CBasicType >> sizeExpression: aString [
	sizeExpression := aString
]

{ #category : #accessing }
CBasicType >> sizeInBytes [
	^size
]

