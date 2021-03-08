"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CHARSETINFO,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #RTF
}

{ #category : #private }
CHARSETINFO class >> def [
	^<def>
	typedef struct tagCHARSETINFO {
		UINT          ciCharset;
		UINT          ciACP;
		FONTSIGNATURE fs;
	} CHARSETINFO, *PCHARSETINFO;
	</def>]

{ #category : #initialization }
CHARSETINFO class >> initializeConstants [
	self initializeFlags]

{ #category : #initialization }
CHARSETINFO class >> initializeFlags [
	WinConstants
		at: 'TCI_SRCCHARSET' put: 1;
		at: 'TCI_SRCCODEPAGE' put: 2;
		at: 'TCI_SRCFONTSIG' put: 3;
		at: 'TCI_SRCLOCALE' put: 4096]

{ #category : #accessing }
CHARSETINFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
CHARSETINFO >> ciACP [
	^self uLongAtOffset: ciACP]

{ #category : #accessing }
CHARSETINFO >> ciACP: anInteger [
	self uLongAtOffset: ciACP put: anInteger]

{ #category : #accessing }
CHARSETINFO >> ciCharset [
	^self uLongAtOffset: ciCharset]

{ #category : #accessing }
CHARSETINFO >> ciCharset: anInteger [
	self uLongAtOffset: ciCharset put: anInteger]

{ #category : #accessing }
CHARSETINFO >> codePage [
	^self ciACP]

{ #category : #accessing }
CHARSETINFO >> fs [
	^self structureAtOffset: fs ofClass: FONTSIGNATURE]

{ #category : #accessing }
CHARSETINFO >> fs: aFONTSIGNATURE [
	self bytesAtOffset: fs put: aFONTSIGNATURE asParameter]

