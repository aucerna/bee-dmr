"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HMAC,
	#superclass : #Object,
	#instVars : [
		'hash',
		'key',
		'ipad',
		'epad'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
HMAC class >> on: hashFunction [
	^self new hash: hashFunction]

{ #category : #services }
HMAC >> destroy [
	key atAllPut: 0]

{ #category : #services }
HMAC >> digestMessage: aByteArray [
	| ikey h ekey |
	ikey := key bitXor: ipad.
	h := hash hashMessage: ikey , aByteArray.
	ekey := key bitXor: epad.
	^hash hashMessage: ekey , h]

{ #category : #accessing }
HMAC >> digestSize [
	^hash digestSize]

{ #category : #accessing }
HMAC >> hash: hashFunction [
	hash := hashFunction.
	ipad := ByteArray new: hash blockSize withAll: 16r36.
	epad := ByteArray new: hash blockSize withAll: 16r5C]

{ #category : #accessing }
HMAC >> key: aByteArray [
	key := aByteArray.
	key size > hash blockSize ifTrue: [key := hash hashMessage: key].
	key size < hash blockSize ifTrue: [| pad |
		pad := ByteArray new: hash blockSize - key size.
		key := key , pad]]

{ #category : #printing }
HMAC >> printOn: aStream [
	aStream nextPutAll: 'HMAC-'; print: hash]

