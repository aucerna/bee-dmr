"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Integer }

{ #category : '*Cryptography' }
Integer >> asByteArray [
	^self bigEndian: self sizeInBytes]

{ #category : '*Cryptography' }
Integer >> bigEndian: n [
	"
	Answer a ByteArray of n with the receiver, most-significant byte first.
	"
	| array |
	n < self sizeInBytes ifTrue: [self error: 'number too large for ByteArray'].
	array := ByteArray new: n.
	1 to: self sizeInBytes do: [:i | | byte |
		byte := self byteAt: i.
		array at: n - i + 1 put: byte].
	^array]

