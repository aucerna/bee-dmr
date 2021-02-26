"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EncoderParameter,
	#superclass : #GdiPlusStructure,
	#instVars : [
		'values'
	],
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #inspecting }
EncoderParameter class >> aspects [
	^super aspects , #(#values)]

{ #category : #private }
EncoderParameter class >> def [
	^<def>
	typedef struct EncoderParameter {
		GUID Guid;
		ULONG NumberOfValues;
		ULONG Type;
		VOID *Value;
	} EncoderParameter;
	</def>]

{ #category : #private }
EncoderParameter class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 32;
		at: 'Guid' put: 0;
		at: 'NumberOfValues' put: 16;
		at: 'Type' put: 20;
		at: 'Value' put: 24;
		yourself]

{ #category : #accessing }
EncoderParameter class >> sizeInBytes [
	^sizeInBytes]

{ #category : #outputs }
EncoderParameter >> bytes [
	| memory |
	memory := self Value.
	^memory isValid
		ifTrue: [ByteArray fromMemory: memory length: self NumberOfValues]]

{ #category : #input }
EncoderParameter >> bytes: aByteArray [
	self
		Type: EncoderParameterValueTypeByte;
		Value: aByteArray externalCopy;
		NumberOfValues: aByteArray size]

{ #category : #outputs }
EncoderParameter >> chars [
	| memory |
	memory := self Value.
	^memory isValid
		ifTrue: [String fromMemory: memory length: self NumberOfValues]]

{ #category : #accessing }
EncoderParameter >> Guid [
	^self structureAtOffset: Guid ofClass: GUID]

{ #category : #accessing }
EncoderParameter >> Guid: aGUID [
	self bytesAtOffset: Guid put: aGUID asParameter]

{ #category : #outputs }
EncoderParameter >> guidDescription [
	| guid |
	guid := self Guid asString.
	guid = EncoderCompression asString ifTrue: [^'Compression'].
	guid = EncoderColorDepth asString ifTrue: [^'ColorDepth'].
	guid = EncoderScanMethod asString ifTrue: [^'ScanMethod'].
	guid = EncoderVersion asString ifTrue: [^'Version'].
	guid = EncoderRenderMethod asString ifTrue: [^'RenderMethod'].
	guid = EncoderQuality asString ifTrue: [^'Quality'].
	guid = EncoderTransformation asString ifTrue: [^'Transformation'].
	guid = EncoderLuminanceTable asString ifTrue: [^'LuminanceTable'].
	guid = EncoderChrominanceTable asString ifTrue: [^'ChrominanceTable'].
	guid = EncoderSaveFlag asString ifTrue: [^'SaveFlag'].
	guid = CodecIImageBytes asString ifTrue: [^'CodecIImageBytes'].
	^guid]

{ #category : #testing }
EncoderParameter >> isLocal [
	^values notNil]

{ #category : #outputs }
EncoderParameter >> longs [
	^self readLongs: self NumberOfValues]

{ #category : #input }
EncoderParameter >> longs: aCollection [
	| buffer |
	buffer := MemoryBuffer external: aCollection size * 4.
	aCollection
		withIndexDo: [:value :i | buffer uLongAtOffset: i - 1 * 4 put: value].
	self
		Type: EncoderParameterValueTypeLong;
		Value: buffer address;
		NumberOfValues: aCollection size]

{ #category : #accessing }
EncoderParameter >> NumberOfValues [
	^self uLongAtOffset: NumberOfValues]

{ #category : #accessing }
EncoderParameter >> NumberOfValues: anInteger [
	self uLongAtOffset: NumberOfValues put: anInteger]

{ #category : #copying }
EncoderParameter >> postLocalCopy [
	values := self values.
	super postLocalCopy]

{ #category : #printing }
EncoderParameter >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: ' <';
		nextPutAll: self guidDescription;
		nextPutAll: ' = '.
	self value printOn: aStream.
	aStream nextPutAll: '>']

{ #category : #outputs }
EncoderParameter >> ranges [
	| longs ranges |
	longs := self readLongs: self NumberOfValues * 2.
	ranges := OrderedCollection new.
	longs pairsDo: [:a :b | ranges add: (a to: b)].
	^ranges]

{ #category : #input }
EncoderParameter >> ranges: aCollection [
	| longs |
	longs := OrderedCollection new.
	aCollection do: [:range | longs add: range first; add: range last].
	self
		longs: longs;
		Type: EncoderParameterValueTypeLongRange;
		NumberOfValues: aCollection size]

{ #category : #outputs }
EncoderParameter >> rationalRanges [
	| longs ranges |
	longs := self readLongs: self NumberOfValues * 4.
	ranges := OrderedCollection new.
	1 to: longs size by: 4 do: [:i | | a b c d |
		a := longs at: i.
		b := longs at: i + 1.
		c := longs at: i + 2.
		d := longs at: i + 3.
		ranges add: (a / b to: c / d)].
	^ranges]

{ #category : #input }
EncoderParameter >> rationalRanges: aCollection [
	| rationals |
	rationals := OrderedCollection new.
	aCollection do: [:range | rationals add: range first; add: range last].
	self
		rationals: rationals;
		Type: EncoderParameterValueTypeRationalRange;
		NumberOfValues: aCollection size]

{ #category : #outputs }
EncoderParameter >> rationals [
	| longs rationals |
	longs := self readLongs: self NumberOfValues * 2.
	rationals := OrderedCollection new.
	longs pairsDo: [:a :b | rationals add: a / b].
	^rationals]

{ #category : #input }
EncoderParameter >> rationals: aCollection [
	| longs |
	longs := OrderedCollection new.
	aCollection do: [:value | 
		value isFraction
			ifTrue: [longs add: value numerator; add: value denominator]
			ifFalse: [longs add: value asInteger; add: 1]].
	self
		longs: longs;
		Type: EncoderParameterValueTypeRational;
		NumberOfValues: aCollection size]

{ #category : #private }
EncoderParameter >> readLongs: count [
	| array memory |
	memory := self Value.
	memory isValid ifFalse: [^nil].
	array := BufferArray at: memory count: count type: ExternalInt32.
	^array localCopy asArray collect: #asUnsignedInteger]

{ #category : #outputs }
EncoderParameter >> shorts [
	| buffer n shorts memory |
	memory := self Value.
	memory isValid ifFalse: [^nil].
	buffer := MemoryBuffer atMemory: memory.
	n := self NumberOfValues.
	shorts := OrderedCollection new: n.
	1 to: n do: [:i | | short |
		short := buffer uShortAtOffset: i - 1 * 2.
		shorts add: short].
	^shorts]

{ #category : #input }
EncoderParameter >> shorts: aCollection [
	| buffer |
	buffer := MemoryBuffer external: aCollection size * 2.
	aCollection
		withIndexDo: [:value :i | buffer uShortAtOffset: i - 1 * 2 put: value].
	self
		Type: EncoderParameterValueTypeShort;
		Value: buffer address;
		NumberOfValues: aCollection size]

{ #category : #accessing }
EncoderParameter >> Type [
	^self uLongAtOffset: Type]

{ #category : #accessing }
EncoderParameter >> Type: anInteger [
	self uLongAtOffset: Type put: anInteger]

{ #category : #outputs }
EncoderParameter >> undefined [
	| memory |
	memory := self Value.
	^memory isValid
		ifTrue: [ByteArray fromMemory: memory length: self NumberOfValues]]

{ #category : #accessing }
EncoderParameter >> Value [
	^self addressAtOffset: Value]

{ #category : #accessing }
EncoderParameter >> Value: anExternalMemory [
	self addressAtOffset: Value register: anExternalMemory]

{ #category : #outputs }
EncoderParameter >> values [
	| type |
	self isLocal ifTrue: [^values].
	type := self Type.
	type = EncoderParameterValueTypeByte ifTrue: [^self bytes].
	type = EncoderParameterValueTypeASCII ifTrue: [^self chars].
	type = EncoderParameterValueTypeShort ifTrue: [^self shorts].
	type = EncoderParameterValueTypeLong ifTrue: [^self longs].
	type = EncoderParameterValueTypeRational ifTrue: [^self rationals].
	type = EncoderParameterValueTypeLongRange ifTrue: [^self ranges].
	type = EncoderParameterValueTypeRationalRange
		ifTrue: [^self rationalRanges].
	type = EncoderParameterValueTypeUndefined ifTrue: [^self undefined].
	self ASSERT: false]

