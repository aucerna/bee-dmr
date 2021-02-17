"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PALETTEENTRY,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
PALETTEENTRY class >> def [
	^<def>
	typedef struct tagPALETTEENTRY {
		BYTE peRed;
		BYTE peGreen;
		BYTE peBlue;
		BYTE peFlags;
	} PALETTEENTRY;
	</def>]

{ #category : #'instance creation' }
PALETTEENTRY class >> fromColor: aColor [
	^self new fromColor: aColor]

{ #category : #'instance creation' }
PALETTEENTRY class >> fromRGBQUAD: aRGBQUAD [
	^self fromColor: aRGBQUAD]

{ #category : #accessing }
PALETTEENTRY class >> sizeInBytes [
	^sizeInBytes]

{ #category : #converting }
PALETTEENTRY >> asColor [
	^Color red: self red green: self green blue: self blue]

{ #category : #output }
PALETTEENTRY >> blue [
	^self peBlue]

{ #category : #input }
PALETTEENTRY >> blue: byte [
	self peBlue: byte]

{ #category : #input }
PALETTEENTRY >> flags [
	^self peFlags]

{ #category : #input }
PALETTEENTRY >> flags: anInteger [
	self peFlags: anInteger]

{ #category : #input }
PALETTEENTRY >> fromColor: aColor [
	self
		peRed: aColor red;
		peGreen: aColor green;
		peBlue: aColor blue]

{ #category : #output }
PALETTEENTRY >> green [
	^self peGreen]

{ #category : #input }
PALETTEENTRY >> green: byte [
	self peGreen: byte]

{ #category : #accessing }
PALETTEENTRY >> peBlue [
	^self byteAtOffset: peBlue]

{ #category : #accessing }
PALETTEENTRY >> peBlue: byte [
	self byteAtOffset: peBlue put: byte]

{ #category : #accessing }
PALETTEENTRY >> peFlags [
	^self byteAtOffset: peFlags]

{ #category : #accessing }
PALETTEENTRY >> peFlags: byte [
	self byteAtOffset: peFlags put: byte]

{ #category : #accessing }
PALETTEENTRY >> peGreen [
	^self byteAtOffset: peGreen]

{ #category : #accessing }
PALETTEENTRY >> peGreen: byte [
	self byteAtOffset: peGreen put: byte]

{ #category : #accessing }
PALETTEENTRY >> peRed [
	^self byteAtOffset: peRed]

{ #category : #accessing }
PALETTEENTRY >> peRed: byte [
	self byteAtOffset: peRed put: byte]

{ #category : #output }
PALETTEENTRY >> red [
	^self peRed]

{ #category : #input }
PALETTEENTRY >> red: byte [
	self peRed: byte]

