"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ThirtyTwoBitRegister,
	#superclass : #Object,
	#instVars : [
		'low',
		'hi'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
ThirtyTwoBitRegister class >> fromByteArray: aByteArray at: index [
	^self new loadFrom: aByteArray at: index]

{ #category : #'instance creation' }
ThirtyTwoBitRegister class >> fromInteger: anInteger [
	^self new load: anInteger]

{ #category : #'instance creation' }
ThirtyTwoBitRegister class >> new [
	^super new initialize]

{ #category : #accessing }
ThirtyTwoBitRegister >> + aThirtyTwoBitRegister [
	| integer l carry h |
	integer := aThirtyTwoBitRegister asInteger.
	l := integer bitAnd: 16rFFFF.
	low := low + l.
	carry := low bitShift: -16.
	low := low bitAnd: 16rFFFF.
	h := integer bitShift: -16.
	h := h bitAnd: 16rFFFF.
	hi := hi + carry + h bitAnd: 16rFFFF]

{ #category : #comparing }
ThirtyTwoBitRegister >> = aThirtyTwoBitRegister [
	^aThirtyTwoBitRegister class == self class
		and: [low = aThirtyTwoBitRegister low and: [hi = aThirtyTwoBitRegister hi]]]

{ #category : #converting }
ThirtyTwoBitRegister >> asInteger [
	^(hi bitShift: 16) + low]

{ #category : #accessing }
ThirtyTwoBitRegister >> at: i [
	i = 1 ifTrue: [^low at: 1].
	i = 2 ifTrue: [^low at: 2].
	i = 3 ifTrue: [^hi at: 1].
	i = 4 ifTrue: [^hi at: 2].
	^0]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> bitAnd: aThirtyTwoBitRegister [
	low := low bitAnd: aThirtyTwoBitRegister low.
	hi := hi bitAnd: aThirtyTwoBitRegister hi]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> bitInvert [
	low := low bitXor: 16rFFFF.
	hi := hi bitXor: 16rFFFF]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> bitOr: aThirtyTwoBitRegister [
	low := low bitOr: aThirtyTwoBitRegister low.
	hi := hi bitOr: aThirtyTwoBitRegister hi]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> bitShift: s [
	| integer |
	integer := self asInteger bitShift: s.
	low := integer bitAnd: 16rFFFF.
	hi := integer bitShift: -16.
	hi := hi bitAnd: 16rFFFF]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> bitXor: aThirtyTwoBitRegister [
	low := low bitXor: aThirtyTwoBitRegister low.
	hi := hi bitXor: aThirtyTwoBitRegister hi]

{ #category : #accessing }
ThirtyTwoBitRegister >> byte1 [
	^hi bitShift: -8]

{ #category : #accessing }
ThirtyTwoBitRegister >> byte2 [
	^hi bitAnd: 16rFF]

{ #category : #accessing }
ThirtyTwoBitRegister >> byte3 [
	^low bitShift: -8]

{ #category : #accessing }
ThirtyTwoBitRegister >> byte4 [
	^low bitAnd: 16rFF]

{ #category : #comparing }
ThirtyTwoBitRegister >> hash [
	^self asInteger hash]

{ #category : #accessing }
ThirtyTwoBitRegister >> hi [
	^hi]

{ #category : #accessing }
ThirtyTwoBitRegister >> hi: anInteger [
	hi := anInteger]

{ #category : #initialization }
ThirtyTwoBitRegister >> initialize [
	super initialize.
	low := hi := 0]

{ #category : #'load / store' }
ThirtyTwoBitRegister >> load: anInteger [
	low := anInteger bitAnd: 16rFFFF.
	hi := anInteger bitShift: -16.
	hi := hi bitAnd: 16rFFFF]

{ #category : #'load / store' }
ThirtyTwoBitRegister >> loadFrom: aByteArray at: index [
	| byte1 byte2 byte3 byte4 |
	byte1 := aByteArray at: index.
	byte2 := aByteArray at: index + 1.
	byte3 := aByteArray at: index + 2.
	byte4 := aByteArray at: index + 3.
	low := (byte3 bitShift: 8) + byte4.
	hi := (byte1 bitShift: 8) + byte2]

{ #category : #accessing }
ThirtyTwoBitRegister >> low [
	^low]

{ #category : #accessing }
ThirtyTwoBitRegister >> low: anInteger [
	low := anInteger]

{ #category : #printing }
ThirtyTwoBitRegister >> printOn: aStream [
	self asInteger printOn: aStream base: 16]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> rotatedLeft32: s [
	^self copy rotateLeft32: s]

{ #category : #'bit operations' }
ThirtyTwoBitRegister >> rotateLeft32: s [
	| integer |
	integer := self asInteger rotateLeft32: s.
	low := integer bitAnd: 16rFFFF.
	hi := integer bitShift: -16]

{ #category : #'load / store' }
ThirtyTwoBitRegister >> storeTo: aByteArray at: index [
	aByteArray
		at: index put: self byte4;
		at: index + 1 put: self byte3;
		at: index + 2 put: self byte2;
		at: index + 3 put: self byte1]

