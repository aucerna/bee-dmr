"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MD5Test,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #'CryptoapiMD5 tests' }
MD5Test >> testCryptoapiMD5FromFile [
	| file md5 |
	#testTP30018.
	file := (Directory scratchDir \ 'TP30018.md5') newFile.
	[file nextPutAll: 'a'] ensure: [file close].
	md5 := BcryptDLL current md5: file file.
	self
		assert: (md5 asInteger hex asString
			beginsWith: 16rCC175B9C0F1B6A831C399E269772661 hex asString)]

{ #category : #'CryptoapiMD5 tests' }
MD5Test >> testCryptoapiMD5FromFilePosition [
	| file reader md5 |
	#testTP30018.
	file := (Directory scratchDir \ 'TP30018.md5') newFile.
	[file nextPutAll: 'ba'] ensure: [file close].
	reader := file file binaryReadStream.
	[
		reader skip: 1.
		md5 := BcryptDLL current md5: reader]
		ensure: [reader close].
	self
		assert: (md5
			beginsWith: #[0x0C 0xC1 0x75 0xB9 0xC0 0xF1 0xB6 0xA8 0x31 0xC3 0x99 0xE2 0x69 0x77 0x26 0x61])]

{ #category : #'CryptoapiMD5 tests' }
MD5Test >> testCryptoapiMD5FromString [
	| md5 |
	#testTP30018.
	md5 := BcryptDLL current md5: 'a'.
	self
		assert: (md5
			beginsWith: #[0x0C 0xC1 0x75 0xB9 0xC0 0xF1 0xB6 0xA8 0x31 0xC3 0x99 0xE2 0x69 0x77 0x26 0x61])]

{ #category : #'CryptoapiMD5 tests' }
MD5Test >> testCryptoapiMD5SqueakTests [
	self
		assert: (BcryptDLL current md5: 'a')
			= #[0x0C 0xC1 0x75 0xB9 0xC0 0xF1 0xB6 0xA8 0x31 0xC3 0x99 0xE2 0x69 0x77 0x26 0x61].
	self
		assert: (BcryptDLL current md5: 'abc')
			= #[0x90 0x01 0x50 0x98 0x3C 0xD2 0x4F 0xB0 0xD6 0x96 0x3F 0x7D 0x28 0xE1 0x7F 0x72].
	self
		assert: (BcryptDLL current md5: 'message digest')
			= #[0xF9 0x6B 0x69 0x7D 0x7C 0xB7 0x93 0x8D 0x52 0x5A 0x2F 0x31 0xAA 0xF1 0x61 0xD0].
	self
		assert: (BcryptDLL current md5: 'abcdefghijklmnopqrstuvwxyz')
			= #[0xC3 0xFC 0xD3 0xD7 0x61 0x92 0xE4 0x00 0x7D 0xFB 0x49 0x6C 0xCA 0x67 0xE1 0x3B].
	self
		assert: (BcryptDLL current
			md5: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789')
			= #[0xD1 0x74 0xAB 0x98 0xD2 0x77 0xD9 0xF5 0xA5 0x61 0x1C 0x2C 0x9F 0x41 0x9D 0x9F].
	self
		assert: (BcryptDLL current
			md5: '12345678901234567890123456789012345678901234567890123456789012345678901234567890')
			= #[0x57 0xED 0xF4 0xA2 0x2B 0xE3 0xC9 0x55 0xAC 0x49 0xDA 0x2E 0x21 0x07 0xB6 0x7A]]

{ #category : #all }
MD5Test >> testEmptyMD5 [
	| result md5 digest |
	result := #[1 35 69 103 137 171 205 239 254 220 186 152 118 84 50 16].
	md5 := MD5 new.
	digest := md5 hash: ''.
	self assert: result = digest]

{ #category : #all }
MD5Test >> testFequalsIfXthenYelseZ [
	| md5 x y z f |
	md5 := MD5 new.
	1000 timesRepeat: [
		x := 16rFFFFFFFF atRandom: self random.
		y := 16rFFFFFFFF atRandom: self random.
		z := 16rFFFFFFFF atRandom: self random.
		md5 registerB load: x.
		md5 registerC load: y.
		md5 registerD load: z.
		f := md5 f asInteger.
		1 to: 16 do: [:i | 
			self
				assert: (f bitAt: i)
					= ((x bitAt: i) = 1 ifTrue: [y bitAt: i] ifFalse: [z bitAt: i])]]]

{ #category : #all }
MD5Test >> testMD5FromFile [
	| file md5 |
	file := (Directory scratchDir \ 'TP27401.md5') newFile.
	[file nextPutAll: 'a'] ensure: [file close].
	md5 := BcryptDLL current md5: file file.
	self
		assert: (md5
			beginsWith: #[0x0C 0xC1 0x75 0xB9 0xC0 0xF1 0xB6 0xA8 0x31 0xC3 0x99 0xE2 0x69 0x77 0x26 0x61])]

{ #category : #all }
MD5Test >> testMD5SqueakTests [
	self
		assert: (MD5 hashMessage: 'a') asInteger
			= 16rCC175B9C0F1B6A831C399E269772661.
	self
		assert: (MD5 hashMessage: 'abc') asInteger
			= 16r900150983CD24FB0D6963F7D28E17F72.
	self
		assert: (MD5 hashMessage: 'message digest') asInteger
			= 16rF96B697D7CB7938D525A2F31AAF161D0.
	self
		assert: (MD5 hashMessage: 'abcdefghijklmnopqrstuvwxyz') asInteger
			= 16rC3FCD3D76192E4007DFB496CCA67E13B.
	self
		assert: (MD5
			hashMessage: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') asInteger = 16rD174AB98D277D9F5A5611C2C9F419D9F.
	self
		assert: (MD5
			hashMessage: '12345678901234567890123456789012345678901234567890123456789012345678901234567890') asInteger = 16r57EDF4A22BE3C955AC49DA2E2107B67A]

{ #category : #all }
MD5Test >> testNonEmptyMD5 [
	| result md5 digest |
	result := #[12 193 117 185 192 241 182 168 49 195 153 226 105 119 38 97].
	md5 := MD5 new.
	digest := md5 hash: 'a'.
	self assert: digest = result]

{ #category : #all }
MD5Test >> testPhrase64 [
	| result md5 digest ten sixty sixtyFour |
	result := #[235 108 65 121 192 167 200 44 194 130 140 30 99 56 225 101].
	md5 := MD5 new.
	ten := '1234567890'.
	sixty := String
		streamContents: [:strm | 6 timesRepeat: [strm nextPutAll: ten]].
	sixtyFour := sixty , '1234'.
	self precondition: sixtyFour size = 64.
	digest := md5 hash: sixtyFour.
	self assert: digest = result]

{ #category : #all }
MD5Test >> testPhrase65 [
	| result md5 digest ten sixty sixtyFive |
	result := #[130 60 200 137 252 115 24 221 51 221 224 101 74 128 183 10].
	md5 := MD5 new.
	ten := '1234567890'.
	sixty := String
		streamContents: [:strm | 6 timesRepeat: [strm nextPutAll: ten]].
	sixtyFive := sixty , '12345'.
	self precondition: sixtyFive size = 65.
	digest := md5 hash: sixtyFive.
	self assert: digest = result]

{ #category : #all }
MD5Test >> testRegisterInitialization [
	| md5 a b c d |
	md5 := MD5 new.
	a := ByteArray
		streamContents: [:strm | 1
			to: 4
			do: [:i | strm nextPut: (md5 registerA at: i)]].
	self assert: a = #[16r01 16r23 16r45 16r67].
	b := ByteArray
		streamContents: [:strm | 1
			to: 4
			do: [:i | strm nextPut: (md5 registerB at: i)]].
	self assert: b = #[16r89 16rAB 16rCD 16rEF].
	c := ByteArray
		streamContents: [:strm | 1
			to: 4
			do: [:i | strm nextPut: (md5 registerC at: i)]].
	self assert: c = #[16rFE 16rDC 16rBA 16r98].
	d := ByteArray
		streamContents: [:strm | 1
			to: 4
			do: [:i | strm nextPut: (md5 registerD at: i)]].
	self assert: d = #[16r76 16r54 16r32 16r10]]

{ #category : #all }
MD5Test >> testShortPhrase [
	| result md5 digest |
	result := #[42 114 5 189 1 205 1 213 122 19 175 65 200 207 26 98].
	md5 := MD5 new.
	digest := md5 hash: 'Valeria, I love you'.
	self assert: digest = result]

{ #category : #all }
MD5Test >> testSinTable [
	| visualWorks md5 |
	visualWorks := #(
		16rD76AA478
		16rE8C7B756
		16r242070DB
		16rC1BDCEEE
		16rF57C0FAF
		16r4787C62A
		16rA8304613
		16rFD469501
		16r698098D8
		16r8B44F7AF
		16rFFFF5BB1
		16r895CD7BE
		16r6B901122
		16rFD987193
		16rA679438E
		16r49B40821
		16rF61E2562
		16rC040B340
		16r265E5A51
		16rE9B6C7AA
		16rD62F105D
		16r2441453
		16rD8A1E681
		16rE7D3FBC8
		16r21E1CDE6
		16rC33707D6
		16rF4D50D87
		16r455A14ED
		16rA9E3E905
		16rFCEFA3F8
		16r676F02D9
		16r8D2A4C8A
		16rFFFA3942
		16r8771F681
		16r6D9D6122
		16rFDE5380C
		16rA4BEEA44
		16r4BDECFA9
		16rF6BB4B60
		16rBEBFBC70
		16r289B7EC6
		16rEAA127FA
		16rD4EF3085
		16r4881D05
		16rD9D4D039
		16rE6DB99E5
		16r1FA27CF8
		16rC4AC5665
		16rF4292244
		16r432AFF97
		16rAB9423A7
		16rFC93A039
		16r655B59C3
		16r8F0CCC92
		16rFFEFF47D
		16r85845DD1
		16r6FA87E4F
		16rFE2CE6E0
		16rA3014314
		16r4E0811A1
		16rF7537E82
		16rBD3AF235
		16r2AD7D2BB
		16rEB86D391).
	md5 := MD5 new.
	self assert: md5 sinTable = visualWorks]

