"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CIEXYZTRIPLE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
CIEXYZTRIPLE class >> def [
	^<def>
	typedef struct CIEXYZTRIPLE {
		CIEXYZ ciexyzRed;
		CIEXYZ ciexyzGreen;
		CIEXYZ ciexyzBlue;
	} CIEXYZTRIPLE;
	</def>]

{ #category : #'instance creation' }
CIEXYZTRIPLE class >> fromStream: aStream [
	^self new fromStream: aStream]

{ #category : #accessing }
CIEXYZTRIPLE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzBlue [
	| data |
	data := self bytesAtOffset: ciexyzBlue count: CIEXYZ sizeInBytes.
	^CIEXYZ usingBytes: data]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzBlue: aCIEXYZ [
	self bytesAtOffset: ciexyzBlue put: aCIEXYZ contents]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzGreen [
	| data |
	data := self bytesAtOffset: ciexyzGreen count: CIEXYZ sizeInBytes.
	^CIEXYZ usingBytes: data]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzGreen: aCIEXYZ [
	self bytesAtOffset: ciexyzGreen put: aCIEXYZ contents]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzRed [
	| data |
	data := self bytesAtOffset: ciexyzRed count: CIEXYZ sizeInBytes.
	^CIEXYZ usingBytes: data]

{ #category : #accessing }
CIEXYZTRIPLE >> ciexyzRed: aCIEXYZ [
	self bytesAtOffset: ciexyzRed put: aCIEXYZ contents]

{ #category : #private }
CIEXYZTRIPLE >> fromStream: aStream [
	| r g b |
	r := CIEXYZ fromStream: aStream.
	g := CIEXYZ fromStream: aStream.
	b := CIEXYZ fromStream: aStream.
	self
		ciexyzRed: r;
		ciexyzGreen: g;
		ciexyzBlue: b]

