"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TEXTMETRIC,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
TEXTMETRIC class >> def [
	^<def>
	typedef struct tagTEXTMETRIC {
		LONG  tmHeight;
		LONG  tmAscent;
		LONG  tmDescent;
		LONG  tmInternalLeading;
		LONG  tmExternalLeading;
		LONG  tmAveCharWidth;
		LONG  tmMaxCharWidth;
		LONG  tmWeight;
		LONG  tmOverhang;
		LONG  tmDigitizedAspectX;
		LONG  tmDigitizedAspectY;
		TCHAR tmFirstChar;
		TCHAR tmLastChar;
		TCHAR tmDefaultChar;
		TCHAR tmBreakChar;
		BYTE  tmItalic;
		BYTE  tmUnderlined;
		BYTE  tmStruckOut;
		BYTE  tmPitchAndFamily;
		BYTE  tmCharSet;
	} TEXTMETRIC, *PTEXTMETRIC;
	</def>]

{ #category : #accessing }
TEXTMETRIC class >> sizeInBytes [
	^sizeInBytes]

{ #category : #output }
TEXTMETRIC >> ascent [
	^self tmAscent]

{ #category : #marshalling }
TEXTMETRIC >> charAtOffset: offset [
	| code |
	code := self uShortAtOffset: offset.
	^Character value: code]

{ #category : #output }
TEXTMETRIC >> charAverageWidth [
	^self tmAveCharWidth]

{ #category : #output }
TEXTMETRIC >> charset [
	^self tmCharSet]

{ #category : #output }
TEXTMETRIC >> descent [
	^self tmDescent]

{ #category : #output }
TEXTMETRIC >> externalLeading [
	^self tmExternalLeading]

{ #category : #private }
TEXTMETRIC >> fontFamily [
	^self tmPitchAndFamily bitAnd: 16rF0]

{ #category : #output }
TEXTMETRIC >> height [
	^self tmHeight]

{ #category : #output }
TEXTMETRIC >> internalLeading [
	^self tmInternalLeading]

{ #category : #testing }
TEXTMETRIC >> isDecorative [
	^self fontFamily = FF_DECORATIVE]

{ #category : #testing }
TEXTMETRIC >> isDefault [
	^self fontFamily = FF_DONTCARE]

{ #category : #testing }
TEXTMETRIC >> isDeviceFont [
	^(self tmPitchAndFamily bitAnd: TMPF_DEVICE) = TMPF_DEVICE]

{ #category : #testing }
TEXTMETRIC >> isFixedWidth [
	^(self tmPitchAndFamily bitAnd: TMPF_FIXED_PITCH) ~= TMPF_FIXED_PITCH]

{ #category : #testing }
TEXTMETRIC >> isModern [
	^self fontFamily = FF_MODERN]

{ #category : #testing }
TEXTMETRIC >> isRoman [
	^self fontFamily = FF_ROMAN]

{ #category : #testing }
TEXTMETRIC >> isScript [
	^self fontFamily = FF_SCRIPT]

{ #category : #testing }
TEXTMETRIC >> isSwiss [
	^self fontFamily = FF_SWISS]

{ #category : #testing }
TEXTMETRIC >> isTrueType [
	^(self tmPitchAndFamily bitAnd: TMPF_TRUETYPE) = TMPF_TRUETYPE]

{ #category : #testing }
TEXTMETRIC >> isVariableWidth [
	^self isFixedWidth not]

{ #category : #testing }
TEXTMETRIC >> isVectorial [
	^(self tmPitchAndFamily bitAnd: TMPF_VECTOR) = TMPF_VECTOR]

{ #category : #accessing }
TEXTMETRIC >> lineSpacing [
	^self ascent + self descent + self internalLeading + self externalLeading]

{ #category : #output }
TEXTMETRIC >> overhang [
	^self tmOverhang]

{ #category : #accessing }
TEXTMETRIC >> tmAscent [
	^self longAtOffset: tmAscent]

{ #category : #accessing }
TEXTMETRIC >> tmAveCharWidth [
	^self longAtOffset: tmAveCharWidth]

{ #category : #accessing }
TEXTMETRIC >> tmBreakChar [
	^self charAtOffset: tmBreakChar]

{ #category : #accessing }
TEXTMETRIC >> tmCharSet [
	^self byteAtOffset: tmCharSet]

{ #category : #accessing }
TEXTMETRIC >> tmDefaultChar [
	^self charAtOffset: tmDefaultChar]

{ #category : #accessing }
TEXTMETRIC >> tmDescent [
	^self longAtOffset: tmDescent]

{ #category : #accessing }
TEXTMETRIC >> tmDigitizedAspectX [
	^self longAtOffset: tmDigitizedAspectX]

{ #category : #accessing }
TEXTMETRIC >> tmDigitizedAspectY [
	^self longAtOffset: tmDigitizedAspectY]

{ #category : #accessing }
TEXTMETRIC >> tmExternalLeading [
	^self longAtOffset: tmExternalLeading]

{ #category : #accessing }
TEXTMETRIC >> tmFirstChar [
	^self charAtOffset: tmFirstChar]

{ #category : #accessing }
TEXTMETRIC >> tmHeight [
	^self longAtOffset: tmHeight]

{ #category : #accessing }
TEXTMETRIC >> tmInternalLeading [
	^self longAtOffset: tmInternalLeading]

{ #category : #accessing }
TEXTMETRIC >> tmItalic [
	| byte |
	byte := self byteAtOffset: tmItalic.
	^byte != 0]

{ #category : #accessing }
TEXTMETRIC >> tmLastChar [
	^self charAtOffset: tmLastChar]

{ #category : #accessing }
TEXTMETRIC >> tmMaxCharWidth [
	^self longAtOffset: tmMaxCharWidth]

{ #category : #accessing }
TEXTMETRIC >> tmOverhang [
	^self longAtOffset: tmOverhang]

{ #category : #accessing }
TEXTMETRIC >> tmPitchAndFamily [
	^self byteAtOffset: tmPitchAndFamily]

{ #category : #accessing }
TEXTMETRIC >> tmStruckOut [
	| byte |
	byte := self byteAtOffset: tmStruckOut.
	^byte != 0]

{ #category : #accessing }
TEXTMETRIC >> tmUnderlined [
	| byte |
	byte := self byteAtOffset: tmUnderlined.
	^byte != 0]

{ #category : #accessing }
TEXTMETRIC >> tmWeight [
	^self longAtOffset: tmWeight]

{ #category : #output }
TEXTMETRIC >> weight [
	^self tmWeight]

