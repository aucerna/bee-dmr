"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MD5,
	#superclass : #MDHash,
	#instVars : [
		'registerA',
		'registerB',
		'registerC',
		'registerD',
		'table',
		'x'
	],
	#category : #Cryptography
}

{ #category : #constants }
MD5 class >> digestSize [
	^16]

{ #category : #computing }
MD5 >> computeX [
	x := Array
		streamContents: [:strm | 1
			to: self digestSize
			do: [:j | strm nextPut: (self m: j - 1 * 4 + 1)]]]

{ #category : #output }
MD5 >> digest [
	| digest |
	digest := ByteArray new: 16.
	registerA storeTo: digest at: 1.
	registerB storeTo: digest at: 5.
	registerC storeTo: digest at: 9.
	registerD storeTo: digest at: 13.
	^digest]

{ #category : #computing }
MD5 >> f [
	| rb b |
	rb := registerB copy.
	rb bitInvert; bitAnd: registerD.
	b := registerB copy.
	^b bitAnd: registerC; bitOr: rb]

{ #category : #computing }
MD5 >> g [
	| rd rb |
	rd := registerD copy.
	rd bitInvert; bitAnd: registerC.
	rb := registerB copy.
	^rb bitAnd: registerD; bitOr: rd]

{ #category : #computing }
MD5 >> h [
	| rb |
	rb := registerB copy.
	^rb bitXor: registerC; bitXor: registerD]

{ #category : #computing }
MD5 >> i [
	| rd |
	rd := registerD copy.
	^rd bitInvert; bitOr: registerB; bitXor: registerC]

{ #category : #initialization }
MD5 >> initialize [
	super initialize.
	self initializeTable; initializeRegisters]

{ #category : #initialization }
MD5 >> initializeRegisters [
	registerA := ThirtyTwoBitRegister fromInteger: 16r67452301.
	registerB := ThirtyTwoBitRegister fromInteger: 16rEFCDAB89.
	registerC := ThirtyTwoBitRegister fromInteger: 16r98BADCFE.
	registerD := ThirtyTwoBitRegister fromInteger: 16r10325476]

{ #category : #initialization }
MD5 >> initializeSave [
	save := Array new: 4]

{ #category : #initialization }
MD5 >> initializeTable [
	table := Array
		streamContents: [:strm | 1
			to: self blockSize
			do: [:i | strm nextPut: 16r100000000 * i sin abs // 1]]]

{ #category : #computing }
MD5 >> m: i [
	| m byte |
	m := 0.
	i + 3 to: i by: -1 do: [:j | 
		byte := buffer at: j.
		m := (m bitShift: 8) bitOr: byte].
	^m]

{ #category : #computing }
MD5 >> processBuffer [
	self
		computeX;
		saveRegisters;
		round1;
		round2;
		round3;
		round4;
		updateRegisters]

{ #category : #private }
MD5 >> registerA [
	^registerA]

{ #category : #private }
MD5 >> registerB [
	^registerB]

{ #category : #private }
MD5 >> registerC [
	^registerC]

{ #category : #private }
MD5 >> registerD [
	^registerD]

{ #category : #initialization }
MD5 >> reset [
	self initializeRegisters]

{ #category : #computing }
MD5 >> rotateRegisters [
	| a |
	a := registerA.
	registerA := registerD.
	registerD := registerC.
	registerC := registerB.
	registerB := a]

{ #category : #computing }
MD5 >> round: result
k: k
s: s
i: i [
	| xk ti |
	xk := x at: k + 1.
	ti := table at: i.
	registerA
		+ result;
		+ xk;
		+ ti;
		rotateLeft32: s;
		+ registerB]

{ #category : #computing }
MD5 >> round1 [
	0 to: 15 do: [:k | 
		self
			round: self f
			k: k
			s: k \\ 4 * 5 + 7
			i: k + 1;
			rotateRegisters]]

{ #category : #computing }
MD5 >> round2 [
	0 to: 15 do: [:k | | r |
		r := k \\ 4.
		self
			round: self g
			k: r * 4 + k + 1 \\ 16
			s: r + 1 * r // 2 + (r * 3) + 5
			i: k + 17;
			rotateRegisters]]

{ #category : #computing }
MD5 >> round3 [
	0 to: 15 do: [:k | | s |
		s := #(4 11 16 23) at: k \\ 4 + 1.
		self
			round: self h
			k: k * 3 + 5 \\ 16
			s: s
			i: k + 33;
			rotateRegisters]]

{ #category : #computing }
MD5 >> round4 [
	0 to: 15 do: [:k | | r |
		r := k \\ 4.
		self
			round: self i
			k: k * 7 \\ 16
			s: r - 1 * r // 2 + (r * 4) + 6
			i: k + 49;
			rotateRegisters]]

{ #category : #computing }
MD5 >> saveRegisters [
	save
		at: 1 put: registerA copy;
		at: 2 put: registerB copy;
		at: 3 put: registerC copy;
		at: 4 put: registerD copy]

{ #category : #private }
MD5 >> sinTable [
	^table]

{ #category : #computing }
MD5 >> storeBitLength [
	"
	Fill in the final 8 bytes of the given ByteArray with a 64-bit little-endian
	representation of the original message length in bits.
	"
	| base |
	base := buffer size - 8.
	1 to: 8 do: [:i | | byte |
		byte := bitLength at: i.
		buffer at: base + i put: byte]]

{ #category : #computing }
MD5 >> updateRegisters [
	registerA + save first.
	registerB + save second.
	registerC + save third.
	registerD + save fourth]

