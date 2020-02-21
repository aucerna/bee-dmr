Class {
	#name : #SingleStructField,
	#superclass : #CStructField,
	#category : #C
}

{ #category : #testing }
SingleStructField class >> accepts: aString [
	^aString conform: [:ch | ch isLetter or: [ch = $_] or: [ch isDigit]]
]

{ #category : #'source code' }
SingleStructField >> getterSourceNamed: aString [
	^aString , String cr , '	' , (self getterBody: aString)
]

{ #category : #printing }
SingleStructField >> printOn: aStream indent: n [
	super printOn: aStream indent: n.
	self printOffsetOn: aStream
]

{ #category : #printing }
SingleStructField >> printTextOn: rtf indent: n [
	super printTextOn: rtf indent: n.
	self printOffsetTextOn: rtf
]

{ #category : #'source code' }
SingleStructField >> setterSourceForAddressNamed: aString [
	^String streamContents: [:strm | | class arg modifier |
		class := type value.
		(class isClass and: [class inheritsFrom: String])
			ifTrue: [
				arg := 'aString'.
				modifier := class == String
					ifTrue: [' ansiz externalCopy']
					ifFalse: [' externalCopy']]
			ifFalse: [
				arg := 'anExternalMemory'.
				modifier := ' pointedMemory'].
		strm
			nextPutAll: aString;
			nextPutAll: ': ';
			nextPutAll: arg;
			crtab;
			nextPutAll: 'self addressAtOffset: ';
			nextPutAll: aString;
			nextPutAll: ' register: ';
			nextPutAll: arg;
			nextPutAll: modifier]
]

{ #category : #'source code' }
SingleStructField >> setterSourceNamed: aString [
	| keyword article arg |
	type isPointer ifTrue: [^self setterSourceForAddressNamed: aString].
	keyword := type value isClass
		ifTrue: ['bytesAtOffset:']
		ifFalse: [type keyword].
	arg := type value isClass
		ifTrue: [
			article := ('aeio' includes: type value name first asLowercase)
				ifTrue: ['an']
				ifFalse: ['a'].
			article , type value name]
		ifFalse: ['anInteger'].
	^String streamContents: [:strm | | writer |
		strm
			nextPutAll: aString;
			nextPutAll: ': ';
			nextPutAll: arg;
			crtab;
			nextPutAll: 'self ';
			nextPutAll: keyword;
			space;
			nextPutAll: aString.
		type value isClass ifTrue: [arg := arg , ' asParameter'].
		writer := type == #address ifTrue: [' register: '] ifFalse: [' put: '].
		strm nextPutAll: writer; nextPutAll: arg]
]

