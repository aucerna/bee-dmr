"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FONTSIGNATURE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #RTF
}

{ #category : #private }
FONTSIGNATURE class >> def [
	^<def>
	typedef struct tagFONTSIGNATURE {
		DWORD fsUsb[4];
		DWORD fsCsb[2];
	} FONTSIGNATURE, *PFONTSIGNATURE;
	</def>]

{ #category : #accessing }
FONTSIGNATURE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
FONTSIGNATURE >> fsCsb [
	^self bytesAtOffset: fsCsb count: 8]

{ #category : #accessing }
FONTSIGNATURE >> fsCsb: aByteArray [
	self bytesAtOffset: fsCsb put: aByteArray]

{ #category : #accessing }
FONTSIGNATURE >> fsUsb [
	^self bytesAtOffset: fsUsb count: 16]

{ #category : #accessing }
FONTSIGNATURE >> fsUsb: aByteArray [
	self bytesAtOffset: fsUsb put: aByteArray]

