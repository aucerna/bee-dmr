Class {
	#name : #ArrayStructField,
	#superclass : #CStructField,
	#instVars : [
		'lengthDef',
		'lengthExpr',
		'lengthValue'
	],
	#category : #C
}

{ #category : #testing }
ArrayStructField class >> accepts: aString [
	^aString includes: $[
]

{ #category : #'source code' }
ArrayStructField >> bytesGetterOn: aStream named: aString [
	| n typename |
	typename := type refersToStruct ifTrue: [type name asString] ifFalse: [
		n := type sizeInBytes.
		n = 1
			ifTrue: ['BYTE']
			ifFalse: [n = 2 ifTrue: ['SHORT'] ifFalse: ['ExternalInt32']]].
	aStream
		nextPutAll: '| count data |';
		crtab;
		nextPutAll: 'count := ';
		nextPutAll: lengthExpr;
		nextPut: $.;
		crtab;
		nextPutAll: 'data := self bytesAtOffset: ';
		nextPutAll: aString;
		nextPutAll: ' count: ';
		nextPutAll: type sizeExpression;
		nextPutAll: ' * count.';
		crtab;
		nextPutAll: '^BufferArray new';
		crtab: 2;
		nextPutAll: 'type: ';
		nextPutAll: typename;
		nextPut: $;;
		crtab: 2;
		nextPutAll: 'count: count;';
		crtab: 2;
		nextPutAll: 'contents: data'
]

{ #category : #'source code' }
ArrayStructField >> getterSourceNamed: aString [
	^String streamContents: [:strm | 
		strm nextPutAll: aString; crtab.
		type baseType == #wchar
			ifTrue: [strm nextPutAll: (self wideStringGetterNamed: aString)]
			ifFalse: [self bytesGetterOn: strm named: aString]]
]

{ #category : #accessing }
ArrayStructField >> lengthDef: anAssociation [
	lengthDef := anAssociation
]

{ #category : #private }
ArrayStructField >> lengthGetterExprIn: aCStruct [
	| entry |
	entry := name endsWith: 'Entry'.
	aCStruct fields do: [:f | | getter |
		getter := f name.
		(#('cDims' 'Count') anySatisfy: [:varname | getter endsWith: varname])
			ifTrue: [^'self ' , getter].
		(entry and: [getter endsWith: 'Entries']) ifTrue: [^'self ' , getter].
		(getter first = $c
			and: [getter allButFirst asLowercase = name asLowercase])
			ifTrue: [^'self ' , getter]].
	self ASSERT: (#('bmiColors' 'tdData') includes: name).
	^lengthDef key
]

{ #category : #accessing }
ArrayStructField >> loadIn: aCStruct [
	| key value compiler |
	super loadIn: aCStruct.
	compiler := Compiler forClass: aCStruct classBinding.
	key := compiler evaluate: lengthDef key for: nil ifFail: [
		self ASSERT: false.
		0].
	value := lengthDef value.
	value isString ifTrue: [value := compiler evaluate: value].
	lengthValue := key + value.
	lengthExpr := lengthValue = 1
		ifTrue: [self lengthGetterExprIn: aCStruct]
		ifFalse: [lengthValue printString]
]

{ #category : #printing }
ArrayStructField >> printOn: aStream indent: n [
	super printOn: aStream indent: n.
	aStream nextPut: $[; nextPutAll: lengthDef key.
	lengthDef value != '0'
		ifTrue: [aStream nextPut: $+; nextPutAll: lengthDef value asString].
	aStream nextPutAll: ']'.
	self printOffsetOn: aStream
]

{ #category : #printing }
ArrayStructField >> printTextOn: rtf indent: n [
	super printTextOn: rtf indent: n.
	rtf nextPut: $[; nextPutAll: lengthDef key.
	lengthDef value != '0'
		ifTrue: [rtf nextPut: $+; nextPutAll: lengthDef value asString].
	rtf nextPutAll: ']'.
	self printOffsetTextOn: rtf
]

{ #category : #'source code' }
ArrayStructField >> setterSourceNamed: aString [
	| keyword article arg |
	type baseType == #wchar ifTrue: [^self stringSetterSourceNamed: aString].
	keyword := type value isClass
		ifTrue: ['bytesAtOffset:']
		ifFalse: [type keyword].
	arg := type classBinding isClass
		ifTrue: [
			article := ('aeio' includes: type value name first asLowercase)
				ifTrue: ['an']
				ifFalse: ['a'].
			article , type name]
		ifFalse: ['anInteger'].
	arg := arg , 'Collection'.
	^String streamContents: [:s | 
		s
			nextPutAll: aString;
			nextPutAll: ': ';
			nextPutAll: arg;
			crtab;
			nextPutAll: '| offset delta |';
			crtab;
			nextPutAll: 'offset := ';
			nextPutAll: aString;
			nextPut: $.;
			crtab;
			nextPutAll: 'delta := ';
			nextPutAll: type sizeExpression;
			nextPut: $.;
			crtab;
			nextPutAll: '1 to: ';
			nextPutAll: lengthDef key;
			nextPutAll: ' do: [:i | | elem |';
			crtab: 2;
			nextPutAll: 'elem := ';
			nextPutAll: arg;
			nextPutAll: ' at: i.';
			crtab: 2;
			nextPutAll: 'self ';
			nextPutAll: keyword;
			nextPutAll: ' offset put: elem asParameter.';
			crtab: 2;
			nextPutAll: 'offset := offset + delta]']
]

{ #category : #accessing }
ArrayStructField >> sizeInBytes [
	^type sizeInBytes * lengthValue
]

{ #category : #'source code' }
ArrayStructField >> stringSetterSourceNamed: aString [
	^String streamContents: [:s | 
		s
			nextPutAll: aString;
			nextPutAll: ': aString';
			crtab;
			nextPutAll: 'self byteAtOffset: ';
			nextPutAll: aString;
			nextPutAll: ' put: aString utf16']
]

{ #category : #'source code' }
ArrayStructField >> wideStringGetterNamed: aString [
	^'^self stringAtOffset: ' , aString , ' count: ' , lengthExpr , ' * 2'
]

