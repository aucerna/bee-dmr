"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ImageCodecInfo,
	#superclass : #GdiPlusStructure,
	#instVars : [
		'name',
		'dll',
		'extension',
		'description',
		'mime',
		'mask',
		'pattern'
	],
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #inspecting }
ImageCodecInfo class >> aspects [
	^super aspects
		, #(#codecName
			#dllName
			#formatDescription
			#filenameExtension
			#mimeType
			#sigPattern
			#sigMask)]

{ #category : #accessing }
ImageCodecInfo class >> def [
	^<def>
	typedef struct ImageCodecInfo {
		CLSID Clsid;
		GUID FormatID;
		WCHAR *CodecName;
		WCHAR *DllName;
		WCHAR *FormatDescription;
		WCHAR *FilenameExtension;
		WCHAR *MimeType;
		DWORD Flags;
		DWORD Version;
		DWORD SigCount;
		DWORD SigSize;
		BYTE *SigPattern;
		BYTE *SigMask;
	} ImageCodecInfo;
	</def>]

{ #category : #private }
ImageCodecInfo class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 104;
		at: 'Clsid' put: 0;
		at: 'FormatID' put: 16;
		at: 'CodecName' put: 32;
		at: 'DllName' put: 40;
		at: 'FormatDescription' put: 48;
		at: 'FilenameExtension' put: 56;
		at: 'MimeType' put: 64;
		at: 'Flags' put: 72;
		at: 'Version' put: 76;
		at: 'SigCount' put: 80;
		at: 'SigSize' put: 84;
		at: 'SigPattern' put: 88;
		at: 'SigMask' put: 96;
		yourself]

{ #category : #accessing }
ImageCodecInfo class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
ImageCodecInfo >> Clsid [
	^self structureAtOffset: Clsid ofClass: (Smalltalk at: #CLSID)]

{ #category : #accessing }
ImageCodecInfo >> Clsid: aCLSID [
	self bytesAtOffset: Clsid put: aCLSID asParameter]

{ #category : #accessing }
ImageCodecInfo >> CodecName [
	^self addressAtOffset: CodecName]

{ #category : #output }
ImageCodecInfo >> codecName [
	| memory |
	self isLocal ifTrue: [^name].
	memory := self CodecName.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
ImageCodecInfo >> CodecName: anExternalMemory [
	self addressAtOffset: CodecName register: anExternalMemory]

{ #category : #input }
ImageCodecInfo >> codecName: aString [
	self CodecName: aString externalCopy]

{ #category : #output }
ImageCodecInfo >> dllName [
	| memory |
	self isLocal ifTrue: [^dll].
	memory := self DllName.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
ImageCodecInfo >> DllName [
	^self addressAtOffset: DllName]

{ #category : #input }
ImageCodecInfo >> dllName: aString [
	| string |
	string := aString isNil
		ifTrue: [0 pointedMemory]
		ifFalse: [aString externalCopy].
	self DllName: string]

{ #category : #accessing }
ImageCodecInfo >> DllName: anExternalMemory [
	self addressAtOffset: DllName register: anExternalMemory]

{ #category : #output }
ImageCodecInfo >> filenameExtension [
	| memory |
	self isLocal ifTrue: [^extension].
	memory := self FilenameExtension.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
ImageCodecInfo >> FilenameExtension [
	^self addressAtOffset: FilenameExtension]

{ #category : #accessing }
ImageCodecInfo >> FilenameExtension: anExternalMemory [
	self addressAtOffset: FilenameExtension register: anExternalMemory]

{ #category : #input }
ImageCodecInfo >> filenameExtension: aString [
	self FilenameExtension: aString externalCopy]

{ #category : #accessing }
ImageCodecInfo >> Flags [
	^self uLongAtOffset: Flags]

{ #category : #accessing }
ImageCodecInfo >> Flags: anInteger [
	self uLongAtOffset: Flags put: anInteger]

{ #category : #accessing }
ImageCodecInfo >> FormatDescription [
	^self addressAtOffset: FormatDescription]

{ #category : #output }
ImageCodecInfo >> formatDescription [
	| memory |
	self isLocal ifTrue: [^description].
	memory := self FormatDescription.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
ImageCodecInfo >> FormatDescription: anExternalMemory [
	self addressAtOffset: FormatDescription register: anExternalMemory]

{ #category : #input }
ImageCodecInfo >> formatDescription: aString [
	self FormatDescription: aString externalCopy]

{ #category : #accessing }
ImageCodecInfo >> FormatID [
	^self structureAtOffset: FormatID ofClass: GUID]

{ #category : #accessing }
ImageCodecInfo >> FormatID: aGUID [
	self bytesAtOffset: FormatID put: aGUID asParameter]

{ #category : #testing }
ImageCodecInfo >> isLocal [
	^name notNil]

{ #category : #output }
ImageCodecInfo >> mimeType [
	| memory |
	self isLocal ifTrue: [^mime].
	memory := self MimeType.
	^memory isValid ifTrue: [WideString fromMemory: memory]]

{ #category : #accessing }
ImageCodecInfo >> MimeType [
	^self addressAtOffset: MimeType]

{ #category : #accessing }
ImageCodecInfo >> MimeType: anExternalMemory [
	self addressAtOffset: MimeType register: anExternalMemory]

{ #category : #input }
ImageCodecInfo >> mimeType: aString [
	self MimeType: aString externalCopy]

{ #category : #copying }
ImageCodecInfo >> postLocalCopy [
	dll := self dllName.
	extension := self filenameExtension.
	description := self formatDescription.
	mime := self mimeType.
	pattern := self sigPattern.
	mask := self sigMask.
	name := self codecName.
	super postLocalCopy]

{ #category : #accessing }
ImageCodecInfo >> SigCount [
	^self uLongAtOffset: SigCount]

{ #category : #accessing }
ImageCodecInfo >> SigCount: anInteger [
	self uLongAtOffset: SigCount put: anInteger]

{ #category : #output }
ImageCodecInfo >> sigMask [
	| memory n |
	self isLocal ifTrue: [^mask].
	memory := self SigMask.
	memory isValid ifFalse: [^nil].
	n := self SigSize.
	^(1 to: self SigCount)
		collect: [:i | ByteArray fromMemory: memory + (i - 1 * n) length: n]]

{ #category : #accessing }
ImageCodecInfo >> SigMask [
	^self addressAtOffset: SigMask]

{ #category : #input }
ImageCodecInfo >> sigMask: aByteArray [
	self SigMask: aByteArray externalCopy]

{ #category : #accessing }
ImageCodecInfo >> SigMask: anInteger [
	self addressAtOffset: SigMask register: anInteger]

{ #category : #accessing }
ImageCodecInfo >> SigPattern [
	^self addressAtOffset: SigPattern]

{ #category : #output }
ImageCodecInfo >> sigPattern [
	| memory n |
	self isLocal ifTrue: [^mask].
	memory := self SigPattern.
	memory isValid ifFalse: [^nil].
	n := self SigSize.
	^(1 to: self SigCount)
		collect: [:i | ByteArray fromMemory: memory + (i - 1 * n) length: n]]

{ #category : #accessing }
ImageCodecInfo >> SigPattern: anInteger [
	self addressAtOffset: SigPattern register: anInteger]

{ #category : #input }
ImageCodecInfo >> sigPattern: aByteArray [
	self SigPattern: aByteArray externalCopy]

{ #category : #accessing }
ImageCodecInfo >> SigSize [
	^self uLongAtOffset: SigSize]

{ #category : #accessing }
ImageCodecInfo >> SigSize: anInteger [
	self uLongAtOffset: SigSize put: anInteger]

{ #category : #accessing }
ImageCodecInfo >> Version [
	^self uLongAtOffset: Version]

{ #category : #accessing }
ImageCodecInfo >> Version: anInteger [
	self uLongAtOffset: Version put: anInteger]

