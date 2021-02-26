"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SHA1Test,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #all }
SHA1Test >> testSHA1 [
	"
	these tests come from http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf
	"
	self
		assert: (SHA1 hashMessage: 'abc') asInteger
			= 16rA9993E364706816ABA3E25717850C26C9CD0D89D.
	self
		assert: (SHA1
			hashMessage: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')
			asInteger
			= 16r84983E441C3BD26EBAAE4AA1F95129E5E54670F1]

