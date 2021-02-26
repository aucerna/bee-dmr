"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SHA,
	#superclass : #MDHash,
	#instVars : [
		'totalA',
		'totalB',
		'totalC',
		'totalD',
		'totalE'
	],
	#category : #Cryptography
}

{ #category : #initialization }
SHA >> reset [
	self initializeTotals]

{ #category : #computing }
SHA >> saveRegisters [
	save
		at: 1 put: totalA copy;
		at: 2 put: totalB copy;
		at: 3 put: totalC copy;
		at: 4 put: totalD copy;
		at: 5 put: totalE copy]

{ #category : #computing }
SHA >> storeBitLength [
	"
	Fill in the final 8 bytes of the buffer with a 64-bit big-endian representation
	of the original message length in bits.
	"
	| quo i |
	quo := bitLength.
	i := buffer size.
	[quo > 0] whileTrue: [| rem |
		rem := quo bitAnd: 16rFF.
		buffer at: i put: rem.
		quo := quo bitShift: -8.
		i := i - 1]]

{ #category : #computing }
SHA >> updateRegisters [
	totalA + (save at: 1).
	totalB + (save at: 2).
	totalC + (save at: 3).
	totalD + (save at: 4).
	totalE + (save at: 5)]

