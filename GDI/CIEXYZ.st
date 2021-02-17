"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CIEXYZ,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
CIEXYZ class >> def [
	"
	[...] FXPT2DOT30 [...] which means that they are interpreted as fixed-point values with a 2-bit integer part and a 30-bit fractional part.'
	"
	^<def>
	typedef struct CIEXYZ {
		FXPT2DOT30 ciexyzX;
		FXPT2DOT30 ciexyzY;
		FXPT2DOT30 ciexyzZ;
	} CIEXYZ;
	</def>]

{ #category : #'instance creation' }
CIEXYZ class >> fromStream: aStream [
	^self new fromStream: aStream]

{ #category : #accessing }
CIEXYZ class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
CIEXYZ class >> typedefTable [
	^UserDLL typedefTable]

{ #category : #accessing }
CIEXYZ >> ciexyzX [
	^self uLongAtOffset: ciexyzX]

{ #category : #accessing }
CIEXYZ >> ciexyzX: anInteger [
	self uLongAtOffset: ciexyzX put: anInteger]

{ #category : #accessing }
CIEXYZ >> ciexyzY [
	^self uLongAtOffset: ciexyzY]

{ #category : #accessing }
CIEXYZ >> ciexyzY: anInteger [
	self uLongAtOffset: ciexyzY put: anInteger]

{ #category : #accessing }
CIEXYZ >> ciexyzZ [
	^self uLongAtOffset: ciexyzZ]

{ #category : #accessing }
CIEXYZ >> ciexyzZ: anInteger [
	self uLongAtOffset: ciexyzZ put: anInteger]

{ #category : #'instance creation' }
CIEXYZ >> fromStream: aStream [
	self
		ciexyzX: aStream nextLong;
		ciexyzY: aStream nextLong;
		ciexyzZ: aStream nextLong]

