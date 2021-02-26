"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Password,
	#superclass : #Object,
	#instVars : [
		'cipher'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
Password class >> at: anExternalAddress length: anInteger [
	^self new at: anExternalAddress length: anInteger]

{ #category : #'instance creation' }
Password class >> on: aString [
	aString class == self ifTrue: [^aString].
	^self new cleartext: aString]

{ #category : #private }
Password >> at: anExternalMemory length: anInteger [
	| blob |
	blob := CRYPTOAPI_BLOB external
		pbData: anExternalMemory;
		cbData: anInteger.
	cipher := Crypt32DLL current protectBlob: blob.
	self disableCode: [blob free]]

{ #category : #converting }
Password >> base64Encoding [
	^self base64EncodingFor: nil]

{ #category : #converting }
Password >> base64EncodingAFor: username [
	| memory utf8 array n base64 |
	memory := self utf8.
	utf8 := username isNil
		ifTrue: [#[]]
		ifFalse: [username utf8 copyWith: 0x3a].
	array := (utf8 size + memory length) externalBytes.
	array replaceFrom: 1 to: utf8 size with: utf8 startingAt: 1.
	n := utf8 size.
	1 to: memory length do: [:i | array at: n + i put: (memory at: i)].
	memory clear: memory length; free.
	base64 := Crypt32DLL current encodedMemoryBase64A: array.
	array clear: array length; free.
	^base64]

{ #category : #converting }
Password >> base64EncodingFor: username [
	| prefix external base64 |
	prefix := username isNil ifTrue: [''] ifFalse: [username , ':'].
	external := self withPrefix: prefix.
	base64 := Crypt32DLL current encodedMemoryBase64: external.
	external clear: external length; free.
	^base64]

{ #category : #private }
Password >> characters [
	| reader decoder array |
	reader := self externalCopy readStream.
	decoder := UTF16 current.
	array := Array streamContents: [:strm | | cp |
		[
			cp := decoder decodeFrom: reader.
			cp > 0]
			whileTrue: [strm nextPut: cp asCharacter]].
	reader collection clear: reader size; free.
	^array]

{ #category : #private }
Password >> clear [
	cipher isNil ifTrue: [^self].
	cipher atAllPut: 0.
	cipher := nil]

{ #category : #private }
Password >> cleartext [
	| memory string |
	memory := self externalCopy.
	string := WideString fromMemory: memory.
	memory clear: memory length; free.
	^string]

{ #category : #private }
Password >> cleartext: aString [
	| memory |
	memory := aString isExternalMemory
		ifTrue: [aString]
		ifFalse: [self encode: aString].
	self at: memory length: memory length]

{ #category : #private }
Password >> encode: aString [
	| array encoder n memory writer |
	array := Array withAll: aString.
	aString atAllPut: 0 asCharacter.
	encoder := UTF16 current.
	n := 0.
	1 to: array size do: [:i | | ch s |
		ch := array at: i.
		s := encoder sizeOfCharacter: ch.
		n := n + s].
	memory := n externalBytes.
	writer := memory writeStream.
	array withIndexDo: [:ch :i | 
		array at: i put: 0.
		encoder encode: ch on: writer].
	^memory]

{ #category : #comparing }
Password >> equals: aPassword [
	| p1 p2 |
	p1 := self characters.
	p2 := aPassword characters.
	^[p1 = p2] ensure: [
		p1 atAllPut: 0.
		p2 atAllPut: 0]]

{ #category : #accessing }
Password >> externalCopy [
	^Crypt32DLL current unprotect: cipher]

{ #category : #testing }
Password >> isEmpty [
	^self size = 0]

{ #category : #accessing }
Password >> size [
	| memory n |
	memory := self externalCopy.
	n := memory length.
	memory clear: n; free.
	^n // 2 - 1]

{ #category : #converting }
Password >> utf8 [
	| memory encoder n utf8 cp |
	memory := self externalCopy readStream.
	memory readLimit: memory size - 2.
	encoder := UTF8 current.
	n := 0.
	[
		memory atEnd or: [
			cp := memory nextUShort.
			cp = 0]]
		whileFalse: [| s |
			s := encoder sizeOfEncoding: cp.
			n := n + s].
	utf8 := n externalBytes writeStream.
	memory reset.
	n timesRepeat: [encoder encode: memory nextUShort asCharacter on: utf8].
	^utf8 collection]

{ #category : #private }
Password >> utf8Bytes [
	| memory bytes |
	memory := self utf8.
	bytes := memory bytes.
	memory clear: memory length; free.
	^bytes]

{ #category : #services }
Password >> withPrefix: aString [
	^self withPrefix: aString suffix: '']

{ #category : #services }
Password >> withPrefix: aString suffix: anotherString [
	| memory prefix suffix n data |
	memory := self utf8.
	prefix := aString utf8.
	suffix := anotherString utf8.
	n := prefix size + memory length + suffix size.
	data := n externalBytes
		replaceFrom: 1 to: prefix size with: prefix startingAt: 1;
		replaceFrom: prefix size + 1
		to: prefix size + memory length
		with: memory
		startingAt: 1;
		replaceFrom: prefix size + memory length + 1
		to: n
		with: suffix
		startingAt: 1.
	memory clear: memory length; free.
	^data]

