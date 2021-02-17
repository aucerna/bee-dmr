"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RGBQUAD,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
RGBQUAD class >> def [
	^<def>
	typedef struct tagRGBQUAD {
		BYTE rgbBlue;
		BYTE rgbGreen;
		BYTE rgbRed;
		BYTE rgbReserved;
	} RGBQUAD;
	</def>]

{ #category : #accessing }
RGBQUAD class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
RGBQUAD >> blue [
	^self rgbBlue]

{ #category : #output }
RGBQUAD >> green [
	^self rgbGreen]

{ #category : #output }
RGBQUAD >> red [
	^self rgbRed]

{ #category : #accessing }
RGBQUAD >> rgbBlue [
	^self byteAtOffset: rgbBlue]

{ #category : #accessing }
RGBQUAD >> rgbBlue: byte [
	self byteAtOffset: rgbBlue put: byte]

{ #category : #accessing }
RGBQUAD >> rgbGreen [
	^self byteAtOffset: rgbGreen]

{ #category : #accessing }
RGBQUAD >> rgbGreen: byte [
	self byteAtOffset: rgbGreen put: byte]

{ #category : #accessing }
RGBQUAD >> rgbRed [
	^self byteAtOffset: rgbRed]

{ #category : #accessing }
RGBQUAD >> rgbRed: byte [
	self byteAtOffset: rgbRed put: byte]

{ #category : #accessing }
RGBQUAD >> rgbReserved [
	^self byteAtOffset: rgbReserved]

