"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SHA1,
	#superclass : #SHA,
	#category : #Cryptography
}

{ #category : #constants }
SHA1 class >> digestSize [
	^20]

{ #category : #initialization }
SHA1 class >> initialize [
	"
	SHA1 initialize
	"
	super initialize.
	self initializeConstants]

{ #category : #initialization }
SHA1 class >> initializeConstants [
	"
	SHA1 initializeConstants
	"
	K := #(2 3 5 10) collect: [:x | 
		ThirtyTwoBitRegister
			fromInteger: (x sqrt / 4.0 * (2.0 raisedTo: 32)) truncated]]

{ #category : #constants }
SHA1 class >> innerBlockSize [
	^80]

{ #category : #accessing }
SHA1 class >> k [
	^K]

{ #category : #private }
SHA1 >> constantForStep: i [
	"
	Answer the constant for the i-th step of the block hash loop. We number oursteps
	1-80, versus the 0-79 of the standard.
	"
	| k |
	k := self class k.
	i <= 20 ifTrue: [^k first].
	i <= 40 ifTrue: [^k second].
	i <= 60 ifTrue: [^k third].
	^k fourth]

{ #category : #outputs }
SHA1 >> digest [
	^(totalA asInteger bitShift: 16r80) + (totalB asInteger bitShift: 16r60)
		+ (totalC asInteger bitShift: 16r40)
		+ (totalD asInteger bitShift: 16r20)
		+ totalE asInteger
		bigEndian: self class digestSize]

{ #category : #computing }
SHA1 >> expandedBlock [
	| out offset |
	out := Array new: self innerBlockSize.
	offset := 1.
	1 to: 16 do: [:i | | r |
		r := ThirtyTwoBitRegister fromByteArray: buffer at: offset.
		out at: i put: r.
		offset := offset + 4].
	17 to: self innerBlockSize do: [:i | | r |
		r := (out at: i - 3) copy.
		r
			bitXor: (out at: i - 8);
			bitXor: (out at: i - 14);
			bitXor: (out at: i - 16);
			rotateLeft32: 1.
		out at: i put: r].
	^out]

{ #category : #private }
SHA1 >> hashSegment: i [
	i <= 20 ifTrue: [
		^totalB copy
			bitAnd: totalC;
			bitOr: (totalB copy bitInvert; bitAnd: totalD)].
	(i between: 41 and: 60) ifTrue: [
		^totalB copy
			bitAnd: totalC;
			bitOr: (totalB copy bitAnd: totalD);
			bitOr: (totalC copy bitAnd: totalD)].
	^totalB copy bitXor: totalC; bitXor: totalD]

{ #category : #initialization }
SHA1 >> initializeSave [
	save := Array new: 5]

{ #category : #initialization }
SHA1 >> initializeTotals [
	"
	Initialize totalA through totalE to their seed values. total registers for use
	when primitives are absent
	"
	totalA := ThirtyTwoBitRegister new load: 16r67452301.
	totalB := ThirtyTwoBitRegister new load: 16rEFCDAB89.
	totalC := ThirtyTwoBitRegister new load: 16r98BADCFE.
	totalD := ThirtyTwoBitRegister new load: 16r10325476.
	totalE := ThirtyTwoBitRegister new load: 16rC3D2E1F0]

{ #category : #accessing }
SHA1 >> innerBlockSize [
	^self class innerBlockSize]

{ #category : #computing }
SHA1 >> processBuffer [
	| w |
	self saveRegisters.
	w := self expandedBlock.
	1 to: self innerBlockSize do: [:i | | r |
		r := (totalA rotatedLeft32: 5)
			+ (self hashSegment: i);
			+ totalE;
			+ (w at: i);
			+ (self constantForStep: i).
		totalE := totalD.
		totalD := totalC.
		totalC := totalB rotatedLeft32: 30.
		totalB := totalA.
		totalA := r].
	self updateRegisters]

