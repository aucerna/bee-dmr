"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HMACTest,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #all }
HMACTest >> testHMAC [
	self
		assert: (MD5 new hmac
			key: (ByteArray new: 16 withAll: 16rB);
			digestMessage: 'Hi There' asByteArray) asInteger
			= 16r9294727A3638BB1C13F48EF8158BFC9D.
	self
		assert: (MD5 new hmac
			key: 'Jefe' asByteArray;
			digestMessage: 'what do ya want for nothing?' asByteArray) asInteger
			= 16r750C783E6AB0B503EAA86E310A5DB738.
	self
		assert: (MD5 new hmac
			key: (ByteArray new: 16 withAll: 16rAA);
			digestMessage: (ByteArray new: 50 withAll: 16rDD)) asInteger
			= 16r56BE34521D144C88DBB8C733F0E8B3F6]

{ #category : #all }
HMACTest >> testHMACSHA256 [
	| key hmac |
	key := ByteArray new: 16r10 withAll: 16rB.
	hmac := SHA256 new hmac key: key; digestMessage: 'Hi There'.
	self
		assert: hmac
			= #[16r49 16r2C 16rE0 16r20 16rFE 16r25 16r34 16rA5
				16r78 16r9D 16rC3 16r84 16r88 16r6 16rC7 16r8F
				16r4F 16r67 16r11 16r39 16r7F 16r8 16rE7 16rE7
				16rA1 16r2C 16rA5 16rA4 16r48 16r3C 16r8A 16rA6]]

