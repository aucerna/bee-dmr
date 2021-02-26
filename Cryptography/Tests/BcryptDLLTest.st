"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BcryptDLLTest,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #private }
BcryptDLLTest >> testAES [
	self
		assert: (BcryptDLL current aesEncrypt: 'Cloudfork' key: 'foobarfoobarfoob')
			= #[0x8E 0x88 0xE9 0x28 0x61 0xA1 0x0B 0xD6 0x3D 0x7B 0xD5 0x46 0x1F 0x07 0x86 0x01];
		assert: ((BcryptDLL current
			aesDecrypt: #[0x8E 0x88 0xE9 0x28 0x61 0xA1 0x0B 0xD6 0x3D 0x7B 0xD5 0x46 0x1F 0x07 0x86 0x01]
			key: 'foobarfoobarfoob') asString upTo: Character null)
			= 'Cloudfork']

{ #category : #all }
BcryptDLLTest >> testMD5 [
	self
		assert: (BcryptDLL current md5: 'Cloudfork')
			= #[16rDF 16r45 16r7E 16r59 16r9C 16r52 16r09 16rC6 16r06 16rB4 16r10 16r78 16r41 16r0E 16r31 16r6F]]

{ #category : #private }
BcryptDLLTest >> testSha256 [
	| digest result |
	self
		assert: (BcryptDLL current sha256: 'Cloudfork')
			= #[0xe1 0xf1 0x72 0x48 0x61 0x5d 0x68 0x2b 0xb6 0x26 0xf8 0xc9 0xfd 0x92 0xd5 0x03 0x29 0x92 0xbf 0x67 0x8a 0x13 0xa3 0xfc 0x99 0x42 0x43 0x0f 0x4a 0x8e 0xac 0x6e].
	self
		assert: (BcryptDLL current sha256: 'abc') asInteger
			= 16rBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD.
	self
		assert: (BcryptDLL current
			sha256: 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')
			asInteger
			= 16r248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1.
	self
		assert: (BcryptDLL current sha256: (String new: 1000000 withAll: $a)) asInteger
			= 16rCDC76E5C9914FB9281A1C7E284D73E67F1809A48A497200E046D39CCC7112CD0.
	digest := BcryptDLL current sha256: 'a'.
	result := #[202 151 129 18 202 27 189 202 250 194 49 179 154 35 220 77 167 134 239 248 20 124 78 114 185 128 119 133 175 238 72 187].
	self assert: digest = result]

