"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SHA256,
	#superclass : #SHA,
	#instVars : [
		'totalF',
		'totalG',
		'totalH'
	],
	#category : #Cryptography
}

{ #category : #constants }
SHA256 class >> digestSize [
	^32]

{ #category : #constants }
SHA256 class >> h0 [
	^h07 first]

{ #category : #constants }
SHA256 class >> h1 [
	^h07 second]

{ #category : #constants }
SHA256 class >> h2 [
	^h07 third]

{ #category : #constants }
SHA256 class >> h3 [
	^h07 fourth]

{ #category : #constants }
SHA256 class >> h4 [
	^h07 fifth]

{ #category : #constants }
SHA256 class >> h5 [
	^h07 sixth]

{ #category : #constants }
SHA256 class >> h6 [
	^h07 seventh]

{ #category : #constants }
SHA256 class >> h7 [
	^h07 eighth]

{ #category : #initialization }
SHA256 class >> initialize [
	"
	SHA256 initialize
	"
	super initialize.
	self initializeH07]

{ #category : #initialization }
SHA256 class >> initializeH07 [
	"
	(2 raisedTo: 32) times the square root of the first 8 primes 2..19
	SHA256 initializeH07
	"
	h07 := #(2 3 5 7 11 13 17 19)
		collect: [:x | (x sqrt * (2.0 raisedTo: 32)) truncated bitAnd: 16rFFFFFFFF]]

{ #category : #constants }
SHA256 class >> roundConstants [
	"
	(2 raisedTo: 32) times the cube root of the first 64 primes 2..311

	(Integer primesUpTo: 311) collect: [:x | ((x raisedTo: 1/3) * (2.0 raisedTo: 32)) truncated hex]
	\\ 32 bits
	"
	^#(16r428A2F98 16r71374491 16rB5C0FBCF 16rE9B5DBA5
		16r3956C25B 16r59F111F1 16r923F82A4 16rAB1C5ED5
		16rD807AA98 16r12835B01 16r243185BE 16r550C7DC3
		16r72BE5D74 16r80DEB1FE 16r9BDC06A7 16rC19BF174
		16rE49B69C1 16rEFBE4786 16r0FC19DC6 16r240CA1CC
		16r2DE92C6F 16r4A7484AA 16r5CB0A9DC 16r76F988DA
		16r983E5152 16rA831C66D 16rB00327C8 16rBF597FC7
		16rC6E00BF3 16rD5A79147 16r06CA6351 16r14292967
		16r27B70A85 16r2E1B2138 16r4D2C6DFC 16r53380D13
		16r650A7354 16r766A0ABB 16r81C2C92E 16r92722C85
		16rA2BFE8A1 16rA81A664B 16rC24B8B70 16rC76C51A3
		16rD192E819 16rD6990624 16rF40E3585 16r106AA070
		16r19A4C116 16r1E376C08 16r2748774C 16r34B0BCB5
		16r391C0CB3 16r4ED8AA4A 16r5B9CCA4F 16r682E6FF3
		16r748F82EE 16r78A5636F 16r84C87814 16r8CC70208
		16r90BEFFFA 16rA4506CEB 16rBEF9A3F7 16rC67178F2)]

{ #category : #outputs }
SHA256 >> digest [
	"
	Concatenate the final totals to build the 160-bit integer result.
	"
	^(totalA asInteger bitShift: 16rE0) + (totalB asInteger bitShift: 16rC0)
		+ (totalC asInteger bitShift: 16rA0)
		+ (totalD asInteger bitShift: 16r80)
		+ (totalE asInteger bitShift: 16r60)
		+ (totalF asInteger bitShift: 16r40)
		+ (totalG asInteger bitShift: 16r20)
		+ totalH asInteger
		bigEndian: self digestSize]

{ #category : #computing }
SHA256 >> expandedBlock [
	| out offset |
	out := Array new: self blockSize.
	offset := 1.
	1 to: 16 do: [:i | | r |
		r := ThirtyTwoBitRegister fromByteArray: buffer at: offset.
		out at: i put: r.
		offset := offset + 4].
	17 to: self blockSize do: [:i | | wi15 wi2 s0 s1 |
		wi15 := out at: i - 15.
		wi2 := out at: i - 2.
		s0 := wi15 copy.
		s0
			rotateLeft32: -7;
			bitXor: (wi15 rotatedLeft32: -18);
			bitXor: (wi15 copy bitShift: -3).
		s1 := wi2 copy.
		s1
			rotateLeft32: -17;
			bitXor: (wi2 rotatedLeft32: -19);
			bitXor: (wi2 copy bitShift: -10).
		s0 + (out at: i - 16); + (out at: i - 7); + s1.
		out at: i put: s0].
	^out]

{ #category : #initialization }
SHA256 >> initializeSave [
	save := Array new: 8]

{ #category : #initialization }
SHA256 >> initializeTotals [
	totalA := ThirtyTwoBitRegister fromInteger: self class h0.
	totalB := ThirtyTwoBitRegister fromInteger: self class h1.
	totalC := ThirtyTwoBitRegister fromInteger: self class h2.
	totalD := ThirtyTwoBitRegister fromInteger: self class h3.
	totalE := ThirtyTwoBitRegister fromInteger: self class h4.
	totalF := ThirtyTwoBitRegister fromInteger: self class h5.
	totalG := ThirtyTwoBitRegister fromInteger: self class h6.
	totalH := ThirtyTwoBitRegister fromInteger: self class h7]

{ #category : #computing }
SHA256 >> processBuffer [
	| w constants |
	self saveRegisters.
	w := self expandedBlock.
	constants := self class roundConstants.
	1 to: self blockSize do: [:i | | s0 maj s1 ch t1 |
		s0 := totalA rotatedLeft32: -2.
		s0
			bitXor: (totalA rotatedLeft32: -13);
			bitXor: (totalA rotatedLeft32: -22).
		maj := totalA copy.
		maj
			bitAnd: totalB;
			bitOr: (totalB copy bitAnd: totalC);
			bitOr: (totalC copy bitAnd: totalA).
		s1 := totalE rotatedLeft32: -6.
		s1
			bitXor: (totalE rotatedLeft32: -11);
			bitXor: (totalE rotatedLeft32: -25).
		ch := totalE copy bitAnd: totalF.
		ch bitOr: (totalE copy bitInvert bitAnd: totalG).
		t1 := totalH copy.
		t1
			+ s1;
			+ ch;
			+ (constants at: i);
			+ (w at: i).
		totalH := totalG.
		totalG := totalF.
		totalF := totalE.
		totalE := totalD + t1.
		totalD := totalC.
		totalC := totalB.
		totalB := totalA.
		totalA := s0 + maj + t1].
	self updateRegisters]

{ #category : #computing }
SHA256 >> saveRegisters [
	super saveRegisters.
	save
		at: 6 put: totalF copy;
		at: 7 put: totalG copy;
		at: 8 put: totalH copy]

{ #category : #computing }
SHA256 >> storeBitLength [
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
SHA256 >> updateRegisters [
	super updateRegisters.
	totalF + (save at: 6).
	totalG + (save at: 7).
	totalH + (save at: 8)]

