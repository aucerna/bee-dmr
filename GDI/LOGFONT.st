"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LOGFONT,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
LOGFONT class >> def [
	^<def>
		typedef struct tagLOGFONT {
			LONG lfHeight; // 0
			LONG lfWidth; // 4
			LONG lfEscapement; // 8
			LONG lfOrientation; // 12
			LONG lfWeight; // 16
			BYTE lfItalic; // 20
			BYTE lfUnderline; // 21
			BYTE lfStrikeOut; // 22
			BYTE lfCharSet; // 23
			BYTE lfOutPrecision; // 24
			BYTE lfClipPrecision; // 25
			BYTE lfQuality; // 26
			BYTE lfPitchAndFamily; // 27
			WCHAR lfFaceName[LF_FACESIZE]; // 28
		} LOGFONT, *PLOGFONT; // sizeInBytes = 92
	</def>]

{ #category : #'instance creation' }
LOGFONT class >> fromAnsiStruct: aLOGFONTA [
	| bytes struct |
	bytes := aLOGFONTA ansiFaceName asWideString asByteArray.
	struct := self new.
	struct contents
		replaceFrom: 1 to: 27 with: aLOGFONTA contents startingAt: 1;
		replaceFrom: 29 to: bytes size + 29 - 1 with: bytes startingAt: 1.
	^struct]

{ #category : #accessing }
LOGFONT class >> sizeInBytes [
	^sizeInBytes]

{ #category : #comparing }
LOGFONT >> = aLOGFONT [
	^self class == aLOGFONT class and: [contents = aLOGFONT contents]]

{ #category : #services }
LOGFONT >> ansiFaceName [
	| string |
	string := String new: LF_FACESIZE.
	1
		to: string size
		do: [:i | string at: i put: (self byteAtOffset: i + 27) asCharacter].
	^string trimNullEnd]

{ #category : #converting }
LOGFONT >> asFont [
	^GDIFont fromLogicalFont: self]

{ #category : #output }
LOGFONT >> charset [
	^self lfCharSet]

{ #category : #input }
LOGFONT >> charset: byte [
	self lfCharSet: byte]

{ #category : #output }
LOGFONT >> escapement [
	^self lfEscapement]

{ #category : #input }
LOGFONT >> escapement: anInteger [
	self lfEscapement: anInteger asInteger]

{ #category : #output }
LOGFONT >> face [
	^self lfFaceName]

{ #category : #input }
LOGFONT >> height: anInteger [
	self lfHeight: anInteger]

{ #category : #testing }
LOGFONT >> isDefaultPitch [
	^self pitch = DEFAULT_PITCH]

{ #category : #testing }
LOGFONT >> isFixedWidth [
	^self pitch = FIXED_PITCH]

{ #category : #testing }
LOGFONT >> isVariableWidth [
	^self pitch = VARIABLE_PITCH]

{ #category : #output }
LOGFONT >> italic [
	^self lfItalic asBoolean]

{ #category : #input }
LOGFONT >> italic: aBoolean [
	self lfItalic: aBoolean asParameter]

{ #category : #accessing }
LOGFONT >> lfCharSet [
	^self byteAtOffset: lfCharSet]

{ #category : #accessing }
LOGFONT >> lfCharSet: byte [
	self byteAtOffset: lfCharSet put: byte]

{ #category : #accessing }
LOGFONT >> lfClipPrecision [
	^self byteAtOffset: lfClipPrecision]

{ #category : #accessing }
LOGFONT >> lfClipPrecision: byte [
	self byteAtOffset: lfClipPrecision put: byte]

{ #category : #accessing }
LOGFONT >> lfEscapement [
	^self longAtOffset: lfEscapement]

{ #category : #accessing }
LOGFONT >> lfEscapement: anInteger [
	self longAtOffset: lfEscapement put: anInteger]

{ #category : #accessing }
LOGFONT >> lfFaceName [
	| bytes face |
	bytes := self bytesAtOffset: lfFaceName count: LF_FACESIZE * 2.
	face := UTF16 current decode: bytes.
	^face reduced]

{ #category : #accessing }
LOGFONT >> lfFaceName: aString [
	| bytes tail |
	self ASSERT: aString size <= LF_FACESIZE.
	bytes := aString utf16.
	tail := ByteArray new: LF_FACESIZE - aString size * 2.
	self
		bytesAtOffset: lfFaceName put: bytes;
		bytesAtOffset: lfFaceName + bytes size put: tail]

{ #category : #accessing }
LOGFONT >> lfHeight [
	^self longAtOffset: lfHeight]

{ #category : #accessing }
LOGFONT >> lfHeight: anInteger [
	self longAtOffset: lfHeight put: anInteger]

{ #category : #accessing }
LOGFONT >> lfItalic [
	^self byteAtOffset: lfItalic]

{ #category : #accessing }
LOGFONT >> lfItalic: byte [
	self byteAtOffset: lfItalic put: byte]

{ #category : #accessing }
LOGFONT >> lfOrientation [
	^self longAtOffset: lfOrientation]

{ #category : #accessing }
LOGFONT >> lfOrientation: anInteger [
	self longAtOffset: lfOrientation put: anInteger]

{ #category : #accessing }
LOGFONT >> lfOutPrecision [
	^self byteAtOffset: lfOutPrecision]

{ #category : #accessing }
LOGFONT >> lfOutPrecision: byte [
	self byteAtOffset: lfOutPrecision put: byte]

{ #category : #accessing }
LOGFONT >> lfPitchAndFamily [
	^self byteAtOffset: lfPitchAndFamily]

{ #category : #accessing }
LOGFONT >> lfPitchAndFamily: byte [
	self byteAtOffset: lfPitchAndFamily put: byte]

{ #category : #accessing }
LOGFONT >> lfQuality [
	^self byteAtOffset: lfQuality]

{ #category : #accessing }
LOGFONT >> lfQuality: byte [
	self byteAtOffset: lfQuality put: byte]

{ #category : #accessing }
LOGFONT >> lfStrikeOut [
	^self byteAtOffset: lfStrikeOut]

{ #category : #accessing }
LOGFONT >> lfStrikeOut: byte [
	self byteAtOffset: lfStrikeOut put: byte]

{ #category : #accessing }
LOGFONT >> lfUnderline [
	^self byteAtOffset: lfUnderline]

{ #category : #accessing }
LOGFONT >> lfUnderline: byte [
	self byteAtOffset: lfUnderline put: byte]

{ #category : #accessing }
LOGFONT >> lfWeight [
	^self longAtOffset: lfWeight]

{ #category : #accessing }
LOGFONT >> lfWeight: anInteger [
	self longAtOffset: lfWeight put: anInteger]

{ #category : #accessing }
LOGFONT >> lfWidth [
	^self longAtOffset: lfWidth]

{ #category : #accessing }
LOGFONT >> lfWidth: anInteger [
	self longAtOffset: lfWidth put: anInteger]

{ #category : #output }
LOGFONT >> orientation [
	^self lfOrientation]

{ #category : #input }
LOGFONT >> orientation: anInteger [
	self lfOrientation: anInteger asInteger]

{ #category : #output }
LOGFONT >> pitch [
	^self lfPitchAndFamily bitAnd: 2r11]

{ #category : #input }
LOGFONT >> pitch: anInteger [
	| byte |
	self ASSERT: anInteger <= 3.
	byte := self lfPitchAndFamily.
	self lfPitchAndFamily: byte & 16rFC | anInteger]

{ #category : #input }
LOGFONT >> quality: byte [
	self lfQuality: byte]

{ #category : #output }
LOGFONT >> strikeout [
	^self lfStrikeOut asBoolean]

{ #category : #input }
LOGFONT >> strikeout: aBoolean [
	self lfStrikeOut: aBoolean asParameter]

{ #category : #output }
LOGFONT >> underline [
	^self lfUnderline asBoolean]

{ #category : #input }
LOGFONT >> underline: aBoolean [
	self lfUnderline: aBoolean asParameter]

{ #category : #input }
LOGFONT >> weight [
	^self lfWeight]

{ #category : #input }
LOGFONT >> weight: anInteger [
	self lfWeight: anInteger]

{ #category : #input }
LOGFONT >> width: anInteger [
	self lfWidth: anInteger]

