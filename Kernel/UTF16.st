Class {
	#name : #UTF16,
	#superclass : #Unicode,
	#category : #Kernel
}

{ #category : #services }
UTF16 class >> decodeFromAddress: externalAddress length: anInteger [
	| stream |	stream := externalAddress readStream readLimit: anInteger * 2.	^self current decodeStringFrom: stream length: anInteger
]

{ #category : #accessing }
UTF16 class >> prefix [
	^#[16rFE 16rFF]
]

{ #category : #services }
UTF16 >> characterIndexesOf: aString from: start to: end [
	"	UTF16 current characterIndexesOf: '𝑎𝑎𝑎x' from: 3 to: 5	"	| i e s max n |	aString isWideString ifFalse: [^start thru: end].	s := i := self characterIndexOf: aString at: start.	n := aString size.	max := end * 2.	e := start * 2.	[i < n and: [e <= max]] whileTrue: [| ch len |		i := i + 1.		ch := aString at: i.		len := self sizeOfCharacter: ch.		e := e + len].	^s thru: i - 1
]

{ #category : #services }
UTF16 >> characterIndexOf: aString at: anInteger [
	(self isDBS: aString upTo: anInteger - 1) ifTrue: [^anInteger].	^super characterIndexOf: aString at: anInteger * 2
]

{ #category : #private }
UTF16 >> compareStringiW: aString1 with: aString2 [
	| string1 string2 result |	string1 := self externalCopyOf: aString1.	string2 := self externalCopyOf: aString2.	result := KernelDLL current		lstrcmpiW: string1 asParameter		lpString2: string2 asParameter.	string1 free.	string2 free.	^result
]

{ #category : #services }
UTF16 >> compose: aString [
	| source chars utf destination composed |	source := self externalCopyOf: aString.	chars := KernelLibrary		FoldString: MAP_PRECOMPOSED		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: 0		cchDest: 0.	chars = 0 ifTrue: [^self winError].	utf := WideString new: chars.	destination := self externalCopyOf: utf.	chars := KernelLibrary		FoldString: MAP_PRECOMPOSED		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: destination asParameter		cchDest: utf size.	chars = 0 ifTrue: [^self winError].	composed := WideString fromMemory: destination.	source free.	destination free.	^composed
]

{ #category : #'encoding / decoding' }
UTF16 >> decodeFrom: aStream [
	| b1 b2 hi b3 b4 lo |	b1 := aStream nextByte.	b2 := aStream nextByte.	hi := b1 + (b2 bitShift: 8).	b2 < 16rD8 ifTrue: [^hi].	hi := hi - 16rD800.	hi < 16r400 ifFalse: [^b2 * 256 + b1].	hi := (hi bitShift: 10) + 16r10000.	b3 := aStream nextByte.	b4 := aStream nextByte.	lo := (b4 bitShift: 8) - 16rDC00 + b3.	^hi + lo
]

{ #category : #services }
UTF16 >> decompose: aString [
	| source chars utf destination decomposed |	source := self externalCopyOf: aString.	chars := KernelLibrary		FoldString: MAP_COMPOSITE		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: 0		cchDest: 0.	chars = 0 ifTrue: [^self winError].	utf := WideString new: chars.	destination := utf externalCopy.	KernelLibrary		FoldString: MAP_COMPOSITE		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: destination asParameter		cchDest: utf size.	chars = 0 ifTrue: [^self winError].	decomposed := WideString fromMemory: destination.	source free.	destination free.	^decomposed
]

{ #category : #'encoding / decoding' }
UTF16 >> encode: aCharacter on: aStream [
	| code c20 hi lo |	code := aCharacter codePoint.	code < 128 ifTrue: [		aStream nextPut: code; nextPut: 0.		^self].	code < 16rD800 ifTrue: [		aStream			nextPut: (code bitAnd: 16rFF);			nextPut: (code bitShift: -8).		^self].	code < 16rE000 ifTrue: [self error: 'invalid code point'].	code < 16r10000 ifTrue: [		aStream			nextPut: (code bitAnd: 16rFF);			nextPut: (code bitShift: -8).		^self].	code < 16r110000 ifTrue: [		c20 := code - 16r10000.		hi := (c20 bitShift: -10) + 16rD800.		lo := (c20 bitAnd: 16r3FF) + 16rDC00.		aStream			nextPut: (hi bitAnd: 16rFF);			nextPut: (hi bitShift: -8);			nextPut: (lo bitAnd: 16rFF);			nextPut: (lo bitShift: -8).		^self].	self error: 'invalid code point'
]

{ #category : #services }
UTF16 >> foldDigitsOf: aString [
	"	(Character value: 1632) asString foldDigits  = '0'	"	| source characters utf destination fold |	source := self externalCopyOf: aString.	characters := KernelLibrary		FoldString: MAP_FOLDDIGITS		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: 0		cchDest: 0.	characters = 0 ifTrue: [^self winError].	utf := WideString new: characters.	destination := utf externalCopy.	characters := KernelLibrary		FoldString: MAP_FOLDDIGITS		lpSrcStr: source asParameter		cchSrc: -1		lpDestStr: destination asParameter		cchDest: utf size.	characters = 0 ifTrue: [^self winError].	fold := WideString fromMemory: destination.	source free.	destination free.	^fold reduced
]

{ #category : #services }
UTF16 >> indexesOf: aString from: start to: end [
	| e stretch delta |	e := start - 1 max: end - 1.	(self isDBS: aString upTo: e) ifTrue: [		delta := end > 0			ifTrue: [self sizeOfCharacter: (aString at: end)]			ifFalse: [0].		^start thru: end - 1 + (delta // 2)].	stretch := super indexesOf: aString from: start to: end.	^stretch + 1 // 2
]

{ #category : #services }
UTF16 >> is: aString normalized: form [
	| memory normalized |	memory := self externalCopyOf: aString.	normalized := NormalizDLL current		IsNormalizedString: form		lpString: memory asParameter		cwLength: aString size.	memory free.	^normalized
]

{ #category : #services }
UTF16 >> isCNormal: aString [
	^self is: aString normalized: CNORMALIZATION
]

{ #category : #services }
UTF16 >> isDBS: aString [
	^self isDBS: aString upTo: aString size
]

{ #category : #services }
UTF16 >> isDBS: aString upTo: anInteger [
	aString isUnicode ifFalse: [^true].	2		to: anInteger * 4		by: 4		do: [:i | (aString uShortAtOffset: i) = 0 ifFalse: [^false]].	^true
]

{ #category : #services }
UTF16 >> isDNormal: aString [
	^self is: aString normalized: DNORMALIZATION
]

{ #category : #services }
UTF16 >> isKCNormal: aString [
	^self is: aString normalized: KCNORMALIZATION
]

{ #category : #services }
UTF16 >> isKDNormal: aString [
	^self is: aString normalized: KDNORMALIZATION
]

{ #category : #services }
UTF16 >> lengthOf: aString [
	^(self encode: aString) size // 2
]

{ #category : #services }
UTF16 >> lowercaseOf: aString [
	| buffer lowercase |	buffer := self externalCopyOf: aString.	UserDLL current CharLowerW: buffer asParameter.	lowercase := WideString fromMemory: buffer.	buffer free.	^lowercase
]

{ #category : #private }
UTF16 >> minBytesPerChar [
	^2
]

{ #category : #services }
UTF16 >> normalize: aString to: normalization [
	| string dll chars memory uc |	string := self externalCopyOf: aString.	dll := NormalizDLL current.	chars := dll		Normalize: normalization		source: string asParameter		chars: aString size		dest: 0		chars: 0.	(chars <= 0 and: [self lastWinError != 0]) ifTrue: [^self].	memory := chars externalCharacters.	chars := dll		Normalize: normalization		source: string asParameter		chars: aString size		dest: memory asParameter		chars: chars.	(chars <= 0 and: [self lastWinError != 0]) ifTrue: [^self].	uc := WideString fromMemory: memory length: chars.	string free.	memory free.	^uc
]

{ #category : #services }
UTF16 >> normalizeToC: aString [
	"	Canonical composition. Transforms each decomposed grouping, consisting of a base	character plus combining characters into the canonical precomposed equivalent	"	^self normalize: aString to: CNORMALIZATION
]

{ #category : #services }
UTF16 >> normalizeToD: aString [
	^self normalize: aString to: DNORMALIZATION
]

{ #category : #services }
UTF16 >> normalizeToKC: aString [
	^self normalize: aString to: KCNORMALIZATION
]

{ #category : #services }
UTF16 >> normalizeToKD: aString [
	^self normalize: aString to: KDNORMALIZATION
]

{ #category : #services }
UTF16 >> parameterFrom: aString [
	| strm |	strm := (ByteArray new: aString size + 1 * 2) writeStream.	aString isCharacter		ifTrue: [self encode: aString on: strm]		ifFalse: [aString do: [:char | self encode: char on: strm]].	strm nextPut: 0; nextPut: 0.	^strm contents
]

{ #category : #services }
UTF16 >> sizeInBytesOf: aString [
	aString isWideString ifFalse: [^aString size + 1 * 2].	^super sizeInBytesOf: aString
]

{ #category : #'encoding / decoding' }
UTF16 >> sizeOfCharacter: aCharacter [
	^aCharacter codePoint < 16r10000 ifTrue: [2] ifFalse: [4]
]

{ #category : #services }
UTF16 >> uppercaseOf: aString [
	| buffer uppercase |	buffer := self externalCopyOf: aString.	UserLibrary CharUpperW: buffer asParameter.	uppercase := WideString fromMemory: buffer.	buffer free.	^uppercase
]

