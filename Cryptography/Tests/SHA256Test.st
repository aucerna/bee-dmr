"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SHA256Test,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #'CryptoapiSHA256 tests' }
SHA256Test >> testCryptoapiSHA256 [
	"
	these tests come from http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf
	"
	self
		assert: 'abc' sha256
			= #[0xBA 0x78 0x16 0xBF 0x8F 0x01 0xCF 0xEA 0x41 0x41 0x40 0xDE 0x5D 0xAE 0x22 0x23 0xB0 0x03 0x61 0xA3 0x96 0x17 0x7A 0x9C 0xB4 0x10 0xFF 0x61 0xF2 0x00 0x15 0xAD].
	self
		assert: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq' sha256
			= #[0x24 0x8D 0x6A 0x61 0xD2 0x06 0x38 0xB8 0xE5 0xC0 0x26 0x93 0x0C 0x3E 0x60 0x39 0xA3 0x3C 0xE4 0x59 0x64 0xFF 0x21 0x67 0xF6 0xEC 0xED 0xD4 0x19 0xDB 0x06 0xC1].
	self
		assert: (BcryptDLL current sha256: (String new: 1000000 withAll: $a))
			= #[0xCD 0xC7 0x6E 0x5C 0x99 0x14 0xFB 0x92 0x81 0xA1 0xC7 0xE2 0x84 0xD7 0x3E 0x67 0xF1 0x80 0x9A 0x48 0xA4 0x97 0x20 0x0E 0x04 0x6D 0x39 0xCC 0xC7 0x11 0x2C 0xD0]]

{ #category : #'CryptoapiSHA256 tests' }
SHA256Test >> testCryptoapiSHA256short [
	| digest result |
	digest := 'a' sha256.
	result := #[202 151 129 18 202 27 189 202 250 194 49 179 154 35 220 77 167 134 239 248 20 124 78 114 185 128 119 133 175 238 72 187].
	self assert: digest = result]

{ #category : #all }
SHA256Test >> testSHA256 [
	"
	these tests come from http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf
	"
	self
		assert: (SHA256 hashMessage: 'abc') asInteger
			= 16rBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD.
	self
		assert: (SHA256
			hashMessage: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq') asInteger
			= 16r248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1
	"	self assert: (SHA256 hashMessage: (String new: 1000000 withAll: $a)) asInteger = 16rCDC76E5C9914FB9281A1C7E284D73E67F1809A48A497200E046D39CCC7112CD0."]

{ #category : #all }
SHA256Test >> testSHA256short [
	| digest result |
	digest := SHA256 hashMessage: 'a'.
	result := #[202 151 129 18 202 27 189 202 250 194 49 179 154 35 220 77 167 134 239 248 20 124 78 114 185 128 119 133 175 238 72 187].
	self assert: digest = result]

