"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Ansi,
	#superclass : #Unicode,
	#category : #Kernel
}

{ #category : #services }
Ansi class >> ansiTable [
	^#(8364 0 8218 402 8222 8230 8224 8225
		710 8240 352 8249 338 0 381 0 0 8216
		8217 8220 8221 8226 8211 8212 732
		8482 353 8250 339 0 382 376)
]

{ #category : #services }
Ansi class >> isAnsi: anInteger [
	anInteger < 128 ifTrue: [^true].
	255 < anInteger ifTrue: [^false].
	^159 < anInteger
]

{ #category : #private }
Ansi class >> sortedAnsiTable [
	^#(338 339 352 353 376 381 382
		402
		710 732
		8211 8212 8216 8217 8218 8220 8221 8222 8224 8225 8226 8230 8240 8249 8250
		8364
		8482)
]

{ #category : #'encoding / decoding' }
Ansi >> decodeFrom: aStream [
	^self decodeInteger: aStream nextByte
]

{ #category : #'encoding / decoding' }
Ansi >> decodeInteger: anInteger [
	| code |
	anInteger < 128 ifTrue: [^anInteger].
	159 < anInteger ifTrue: [^anInteger].
	code := self class ansiTable at: anInteger - 127.
	^code = 0 ifTrue: [anInteger] ifFalse: [code]
]

{ #category : #'encoding / decoding' }
Ansi >> encode: aCharacter on: aStream [
	| value index |
	value := aCharacter asInteger.
	((value between: 128 and: 159) or: [255 < value]) ifTrue: [
		index := self class ansiTable indexOf: value.
		value := index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]].
	aStream nextPut: value
]

{ #category : #'encoding / decoding' }
Ansi >> encodeInteger: anInteger [
	| index |
	anInteger < 256 ifTrue: [^anInteger].
	index := self class ansiTable indexOf: anInteger.
	^index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]
]

{ #category : #services }
Ansi >> parameterFrom: aString [
	| n param |
	n := aString size.
	param := ByteArray new: n + 1.
	1 to: n do: [:i | | cp byte |
		cp := aString codeAt: i.
		byte := self encodeInteger: cp.
		param at: i put: byte].
	param at: n + 1 put: 0.
	^param
]

{ #category : #private }
Ansi >> reduce: aString [
	| bytes |
	bytes := self encode: aString.
	^String fromBytes: bytes
]

{ #category : #services }
Ansi >> sizeOfCharacter: aCharacter [
	^1
]

