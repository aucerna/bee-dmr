"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MDHash,
	#superclass : #Object,
	#instVars : [
		'input',
		'stream',
		'buffer',
		'bitLength',
		'save'
	],
	#category : #Cryptography
}

{ #category : #constants }
MDHash class >> blockSize [
	^64]

{ #category : #services }
MDHash class >> hashMessage: aString [
	^self new hash: aString]

{ #category : #'instance creation' }
MDHash class >> new [
	^super new initialize]

{ #category : #private }
MDHash >> atEnd [
	^stream atEnd]

{ #category : #accessing }
MDHash >> blockSize [
	^self class blockSize]

{ #category : #computing }
MDHash >> compute [
	| start |
	start := self position.
	[self atEnd] whileFalse: [
		self loadBuffer.
		self atEnd ifTrue: [
			bitLength := self position - start * 8.
			self processFinalBuffer].
		self processBuffer]]

{ #category : #accessing }
MDHash >> digestSize [
	^self class digestSize]

{ #category : #inputs }
MDHash >> hash: aStringOrByteArray [
	self message: aStringOrByteArray.
	^self hashStream: stream]

{ #category : #inputs }
MDHash >> hashMessage: aStringOrByteArray [
	^self hash: aStringOrByteArray]

{ #category : #inputs }
MDHash >> hashStream: aStream [
	stream := aStream.
	^self reset; compute; digest]

{ #category : #converting }
MDHash >> hmac [
	^HMAC on: self]

{ #category : #initialization }
MDHash >> initialize [
	super initialize.
	self initializeSave]

{ #category : #computing }
MDHash >> loadBuffer [
	buffer := stream peek: self blockSize.
	stream skip: buffer size]

{ #category : #inputs }
MDHash >> message: aStringOrByteArray [
	input := aStringOrByteArray.
	stream := aStringOrByteArray asByteArray readStream]

{ #category : #private }
MDHash >> position [
	^stream position]

{ #category : #computing }
MDHash >> processBufferTail [
	| out n |
	out := ByteArray new: self blockSize.
	n := buffer size.
	out
		replaceFrom: 1
		to: n
		with: buffer
		startingAt: 1.
	buffer := out.
	buffer at: n + 1 put: 16r80.
	n + 8 >= self blockSize ifTrue: [
		self processBuffer.
		buffer := ByteArray new: self blockSize]]

{ #category : #computing }
MDHash >> processFinalBuffer [
	buffer size = self blockSize ifTrue: [self processFinalBuffer64].
	self processBufferTail; storeBitLength]

{ #category : #computing }
MDHash >> processFinalBuffer64 [
	self processBuffer.
	buffer := ByteArray new]

