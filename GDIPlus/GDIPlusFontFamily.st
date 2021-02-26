"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusFontFamily,
	#superclass : #GDIPlusObject,
	#classVars : [
		'GenericMonospaceFontFamily',
		'GenericSansSerifFontFamily',
		'GenericSerifFontFamily'
	],
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusFontFamily class >> fromName: fontName [
	^self fromName: fontName fontCollection: nil]

{ #category : #'instance creation' }
GDIPlusFontFamily class >> fromName: aString fontCollection: aGDIPlusFontCollection [
	| pointer face status |
	pointer := ExternalPointer external.
	face := aString externalCopy.
	status := self dll
		GdipCreateFontFamilyFromName: face asParameter
		fontCollection: aGDIPlusFontCollection asParameter
		fontFamily: pointer asParameter.
	self checkStatus: status.
	face free.
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusFontFamily class >> genericMonospace [
	GenericMonospaceFontFamily isNil ifTrue: [self initializeGenericMonospace].
	^GenericMonospaceFontFamily]

{ #category : #accessing }
GDIPlusFontFamily class >> genericSansSerif [
	GenericSansSerifFontFamily isNil ifTrue: [self initializeGenericSansSerif].
	^GenericSansSerifFontFamily]

{ #category : #accessing }
GDIPlusFontFamily class >> genericSerif [
	GenericSerifFontFamily isNil ifTrue: [self initializeGenericSerif].
	^GenericSerifFontFamily]

{ #category : #initialization }
GDIPlusFontFamily class >> initializeConstants [
	GDIPlusConstants at: 'LANG_NEUTRAL' put: 0]

{ #category : #initialization }
GDIPlusFontFamily class >> initializeGenericMonospace [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll GdipGetGenericFontFamilyMonospace: pointer asParameter.
	self checkStatus: status.
	GenericMonospaceFontFamily := self fromHandle: pointer makeLocal]

{ #category : #initialization }
GDIPlusFontFamily class >> initializeGenericSansSerif [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll GdipGetGenericFontFamilySansSerif: pointer asParameter.
	self checkStatus: status.
	GenericSansSerifFontFamily := self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusFontFamily class >> initializeGenericSerif [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll GdipGetGenericFontFamilySerif: pointer asParameter.
	self checkStatus: status.
	GenericSerifFontFamily := self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusFontFamily >> basicRelease [
	status := self dll GdipDeleteFontFamily: self asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusFontFamily >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneFontFamily: self asParameter
		clonedFontFamily: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusFontFamily >> getCellAscent: style [
	| ascent |
	ascent := ExternalInt32 external.
	status := self dll
		GdipGetCellAscent: self asParameter
		style: style asParameter
		CellAscent: ascent asParameter.
	self checkStatus.
	^ascent makeLocal uShortAtOffset: 0]

{ #category : #private }
GDIPlusFontFamily >> getCellDescent: style [
	| descent |
	descent := ExternalInt32 external.
	status := self dll
		GdipGetCellDescent: self asParameter
		style: style asParameter
		CellDescent: descent asParameter.
	self checkStatus.
	^descent makeLocal uShortAtOffset: 0]

{ #category : #private }
GDIPlusFontFamily >> getEmHeight: style [
	| height |
	height := ExternalInt32 external.
	status := self dll
		GdipGetEmHeight: self asParameter
		style: style asParameter
		emHeight: height asParameter.
	self checkStatus.
	^height makeLocal uShortAtOffset: 0]

{ #category : #private }
GDIPlusFontFamily >> getFamilyName: language [
	| utf memory |
	utf := WideString new: LF_FACESIZE.
	memory := utf externalCopy.
	status := self dll
		GdipGetFamilyName: self asParameter
		name: memory asParameter
		language: language asParameter.
	self checkStatus.
	utf := WideString fromMemory: memory.
	memory free.
	^utf asString]

{ #category : #private }
GDIPlusFontFamily >> getLineSpacing: style [
	| spacing |
	spacing := ExternalInt32 external.
	status := self dll
		GdipGetLineSpacing: self asParameter
		style: style asParameter
		lineSpacing: spacing asParameter.
	self checkStatus.
	^spacing makeLocal uShortAtOffset: 0]

{ #category : #testing }
GDIPlusFontFamily >> isStyleAvailable: style [
	| boolean |
	boolean := ExternalInt32 external.
	status := self dll
		GdipIsStyleAvailable: self asParameter
		style: style asParameter
		isStyleAvailable: boolean asParameter.
	self checkStatus.
	^boolean makeLocal asBoolean]

{ #category : #accessing }
GDIPlusFontFamily >> name [
	^self getFamilyName: LANG_NEUTRAL]

