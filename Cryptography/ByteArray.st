"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #ByteArray }

{ #category : '*Cryptography' }
ByteArray >> asInteger [
	^self inject: 0 into: [:sum :byte | (sum bitShift: 8) + byte]]

{ #category : '*Cryptography' }
ByteArray >> bitXor: aByteArray [
	| answer n |
	answer := self copy.
	n := self size min: aByteArray size.
	1 to: n do: [:i | | a b xor |
		a := self at: i.
		b := aByteArray at: i.
		xor := a bitXor: b.
		answer at: i put: xor].
	^answer]

{ #category : '*Cryptography' }
ByteArray >> sha256 [
	^BcryptDLL current sha256: self]

