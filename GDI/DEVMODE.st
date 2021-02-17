"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DEVMODE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
DEVMODE class >> def [
	^<def>
		typedef struct _devicemodeW {
			WCHAR dmDeviceName[CCHDEVICENAME];
			WORD dmSpecVersion;
			WORD dmDriverVersion;
			WORD dmSize;
			WORD dmDriverExtra;
			DWORD dmFields;
			union {
				struct {
					short dmOrientation;
					short dmPaperSize;
					short dmPaperLength;
					short dmPaperWidth;
					short dmScale;
					short dmCopies;
					short dmDefaultSource;
					short dmPrintQuality;
				};
				struct {
					POINTL dmPosition;
					DWORD dmDisplayOrientation;
					DWORD dmDisplayFixedOutput;
				};
			};
			short dmColor;
			short dmDuplex;
			short dmYResolution;
			short dmTTOption;
			short dmCollate;
			WCHAR dmFormName[CCHFORMNAME];
			WORD dmLogPixels;
			DWORD dmBitsPerPel;
			DWORD dmPelsWidth;
			DWORD dmPelsHeight;
			union {
				DWORD dmDisplayFlags;
				DWORD dmNup;
			};
			DWORD dmDisplayFrequency;
			DWORD dmICMMethod;
			DWORD dmICMIntent;
			DWORD dmMediaType;
			DWORD dmDitherType;
			DWORD dmReserved1;
			DWORD dmReserved2;
			DWORD dmPanningWidth;
			DWORD dmPanningHeight;
		} DEVMODEW;
	</def>]

{ #category : #'instance creation' }
DEVMODE class >> fromMemory: anExternalMemory [
	| struct size mode |
	struct := self atMemory: anExternalMemory.
	size := struct dmSize + struct dmDriverExtra.
	mode := self new initialize: size external: false.
	^mode fillFrom: anExternalMemory]

{ #category : #accessing }
DEVMODE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #inputs }
DEVMODE >> a3 [
	self dmPaperSize: DMPAPER_A3]

{ #category : #inputs }
DEVMODE >> a4 [
	self dmPaperSize: DMPAPER_A4]

{ #category : #output }
DEVMODE >> bitsPerPixel [
	^self dmBitsPerPel]

{ #category : #output }
DEVMODE >> breadth [
	^self dmPelsWidth]

{ #category : #inputs }
DEVMODE >> collate: aBoolean [
	| value |
	self supportsCollation ifFalse: [^self].
	value := aBoolean ifTrue: [DMCOLLATE_TRUE] ifFalse: [DMCOLLATE_FALSE].
	self dmCollate: value]

{ #category : #output }
DEVMODE >> copies [
	^self dmCopies]

{ #category : #output }
DEVMODE >> displayFrequency [
	^self dmDisplayFrequency]

{ #category : #accessing }
DEVMODE >> dmBitsPerPel [
	^self uLongAtOffset: dmBitsPerPel]

{ #category : #accessing }
DEVMODE >> dmBitsPerPel: anInteger [
	self
		uLongAtOffset: dmBitsPerPel put: anInteger;
		dmFields: self dmFields | DM_BITSPERPEL]

{ #category : #accessing }
DEVMODE >> dmCollate [
	^self shortAtOffset: dmCollate]

{ #category : #accessing }
DEVMODE >> dmCollate: anInteger [
	self shortAtOffset: dmCollate put: anInteger]

{ #category : #accessing }
DEVMODE >> dmColor [
	^self shortAtOffset: dmColor]

{ #category : #accessing }
DEVMODE >> dmColor: anInteger [
	self
		shortAtOffset: dmColor put: anInteger;
		dmFields: self dmFields | DM_COLOR]

{ #category : #accessing }
DEVMODE >> dmCopies [
	^self shortAtOffset: dmCopies]

{ #category : #accessing }
DEVMODE >> dmCopies: anInteger [
	self
		shortAtOffset: dmCopies put: anInteger;
		dmFields: self dmFields | DM_COPIES]

{ #category : #accessing }
DEVMODE >> dmDefaultSource [
	^self shortAtOffset: dmDefaultSource]

{ #category : #accessing }
DEVMODE >> dmDefaultSource: anInteger [
	self
		shortAtOffset: dmDefaultSource put: anInteger;
		dmFields: self dmFields | DM_DEFAULTSOURCE]

{ #category : #accessing }
DEVMODE >> dmDeviceName [
	^self stringAtOffset: dmDeviceName count: CCHDEVICENAME]

{ #category : #accessing }
DEVMODE >> dmDisplayFixedOutput [
	^self uLongAtOffset: dmDefaultSource]

{ #category : #accessing }
DEVMODE >> dmDisplayFixedOutput: anInteger [
	self
		uLongAtOffset: dmDefaultSource put: anInteger;
		dmFields: self dmFields | DM_DISPLAYFIXEDOUTPUT]

{ #category : #accessing }
DEVMODE >> dmDisplayFlags [
	^self uLongAtOffset: dmDisplayFlags]

{ #category : #accessing }
DEVMODE >> dmDisplayFlags: anInteger [
	self
		uLongAtOffset: dmDisplayFlags put: anInteger;
		dmFields: self dmFields | DM_DISPLAYFLAGS]

{ #category : #accessing }
DEVMODE >> dmDisplayFrequency [
	^self uLongAtOffset: dmDisplayFrequency]

{ #category : #accessing }
DEVMODE >> dmDisplayFrequency: anInteger [
	self
		uLongAtOffset: dmDisplayFrequency put: anInteger;
		dmFields: self dmFields | DM_DISPLAYFREQUENCY]

{ #category : #accessing }
DEVMODE >> dmDisplayOrientation [
	^self uLongAtOffset: dmScale]

{ #category : #accessing }
DEVMODE >> dmDisplayOrientation: anInteger [
	self
		uLongAtOffset: dmScale put: anInteger;
		dmFields: self dmFields | DM_DISPLAYORIENTATION]

{ #category : #accessing }
DEVMODE >> dmDitherType [
	^self uLongAtOffset: dmDitherType]

{ #category : #accessing }
DEVMODE >> dmDitherType: anInteger [
	self
		uLongAtOffset: dmDitherType put: anInteger;
		dmFields: self dmFields | DM_DITHERTYPE]

{ #category : #accessing }
DEVMODE >> dmDriverExtra [
	^self uShortAtOffset: dmDriverExtra]

{ #category : #accessing }
DEVMODE >> dmDriverVersion [
	^self uShortAtOffset: dmDriverVersion]

{ #category : #accessing }
DEVMODE >> dmDuplex [
	^self shortAtOffset: dmDuplex]

{ #category : #accessing }
DEVMODE >> dmDuplex: anInteger [
	self
		shortAtOffset: dmDuplex put: anInteger;
		dmFields: self dmFields | DM_DUPLEX]

{ #category : #accessing }
DEVMODE >> dmFields [
	^self uLongAtOffset: dmFields]

{ #category : #accessing }
DEVMODE >> dmFields: anInteger [
	self uLongAtOffset: dmFields put: anInteger]

{ #category : #accessing }
DEVMODE >> dmFormName [
	^self stringAtOffset: dmFormName count: CCHFORMNAME]

{ #category : #accessing }
DEVMODE >> dmICMIntent [
	^self uLongAtOffset: dmICMIntent]

{ #category : #accessing }
DEVMODE >> dmICMIntent: anInteger [
	self
		uLongAtOffset: dmICMIntent put: anInteger;
		dmFields: self dmFields | DM_ICMINTENT]

{ #category : #accessing }
DEVMODE >> dmICMMethod [
	^self uLongAtOffset: dmICMMethod]

{ #category : #accessing }
DEVMODE >> dmICMMethod: anInteger [
	self
		uLongAtOffset: dmICMMethod put: anInteger;
		dmFields: self dmFields | DM_ICMMETHOD]

{ #category : #accessing }
DEVMODE >> dmLogPixels [
	^self uShortAtOffset: dmLogPixels]

{ #category : #accessing }
DEVMODE >> dmLogPixels: anInteger [
	self
		uShortAtOffset: dmLogPixels put: anInteger;
		dmFields: self dmFields | DM_LOGPIXELS]

{ #category : #accessing }
DEVMODE >> dmMediaType [
	^self uLongAtOffset: dmMediaType]

{ #category : #accessing }
DEVMODE >> dmMediaType: anInteger [
	self
		uLongAtOffset: dmMediaType put: anInteger;
		dmFields: self dmFields | DM_MEDIATYPE]

{ #category : #accessing }
DEVMODE >> dmNup [
	^self uLongAtOffset: dmDisplayFlags]

{ #category : #accessing }
DEVMODE >> dmOrientation [
	^self shortAtOffset: dmOrientation]

{ #category : #accessing }
DEVMODE >> dmOrientation: anInteger [
	self shortAtOffset: dmOrientation put: anInteger.
	self dmFields: self dmFields | DM_ORIENTATION]

{ #category : #accessing }
DEVMODE >> dmPanningHeight [
	^self uLongAtOffset: dmPanningHeight]

{ #category : #accessing }
DEVMODE >> dmPanningHeight: anInteger [
	self
		uLongAtOffset: dmPanningHeight put: anInteger;
		dmFields: self dmFields | DM_PANNINGHEIGHT]

{ #category : #accessing }
DEVMODE >> dmPanningWidth [
	^self uLongAtOffset: dmPanningWidth]

{ #category : #accessing }
DEVMODE >> dmPanningWidth: anInteger [
	self
		uLongAtOffset: dmPanningWidth put: anInteger;
		dmFields: self dmFields | DM_PANNINGWIDTH]

{ #category : #accessing }
DEVMODE >> dmPaperLength [
	^self shortAtOffset: dmPaperLength]

{ #category : #accessing }
DEVMODE >> dmPaperLength: anInteger [
	self
		shortAtOffset: dmPaperLength put: anInteger;
		dmFields: self dmFields | DM_PAPERLENGTH]

{ #category : #accessing }
DEVMODE >> dmPaperSize [
	^self shortAtOffset: dmPaperSize]

{ #category : #accessing }
DEVMODE >> dmPaperSize: anInteger [
	self
		shortAtOffset: dmPaperSize put: anInteger;
		dmFields: self dmFields | DM_PAPERSIZE]

{ #category : #accessing }
DEVMODE >> dmPaperWidth [
	^self shortAtOffset: dmPaperWidth]

{ #category : #accessing }
DEVMODE >> dmPaperWidth: anInteger [
	self
		shortAtOffset: dmPaperWidth put: anInteger;
		dmFields: self dmFields | DM_PAPERWIDTH]

{ #category : #accessing }
DEVMODE >> dmPelsHeight [
	^self uLongAtOffset: dmPelsHeight]

{ #category : #accessing }
DEVMODE >> dmPelsHeight: anInteger [
	self
		uLongAtOffset: dmPelsHeight put: anInteger;
		dmFields: self dmFields | DM_PELSHEIGHT]

{ #category : #accessing }
DEVMODE >> dmPelsWidth [
	^self uLongAtOffset: dmPelsWidth]

{ #category : #accessing }
DEVMODE >> dmPelsWidth: anInteger [
	self
		uLongAtOffset: dmPelsWidth put: anInteger;
		dmFields: self dmFields | DM_PELSWIDTH]

{ #category : #accessing }
DEVMODE >> dmPosition [
	^self pointAtOffset: dmOrientation]

{ #category : #accessing }
DEVMODE >> dmPosition: aPoint [
	self
		pointAtOffset: dmOrientation put: aPoint;
		dmFields: self dmFields | DM_POSITION]

{ #category : #accessing }
DEVMODE >> dmPrintQuality [
	^self shortAtOffset: dmPrintQuality]

{ #category : #accessing }
DEVMODE >> dmPrintQuality: anInteger [
	self
		shortAtOffset: dmPrintQuality put: anInteger;
		dmFields: self dmFields | DM_PRINTQUALITY]

{ #category : #accessing }
DEVMODE >> dmReserved1 [
	^self uLongAtOffset: dmReserved1]

{ #category : #accessing }
DEVMODE >> dmReserved2 [
	^self uLongAtOffset: dmReserved2]

{ #category : #accessing }
DEVMODE >> dmScale [
	^self shortAtOffset: dmScale]

{ #category : #accessing }
DEVMODE >> dmScale: anInteger [
	self
		shortAtOffset: dmScale put: anInteger;
		dmFields: self dmFields | DM_SCALE]

{ #category : #accessing }
DEVMODE >> dmSize [
	^self uShortAtOffset: dmSize]

{ #category : #accessing }
DEVMODE >> dmSize: anInteger [
	self uShortAtOffset: dmSize put: anInteger]

{ #category : #accessing }
DEVMODE >> dmSpecVersion [
	^self uShortAtOffset: dmSpecVersion]

{ #category : #accessing }
DEVMODE >> dmSpecVersion: anInteger [
	self uShortAtOffset: dmSpecVersion put: anInteger]

{ #category : #accessing }
DEVMODE >> dmTTOption [
	^self shortAtOffset: dmTTOption]

{ #category : #accessing }
DEVMODE >> dmTTOption: anInteger [
	self
		shortAtOffset: dmTTOption put: anInteger;
		dmFields: self dmFields | DM_TTOPTION]

{ #category : #accessing }
DEVMODE >> dmYResolution [
	^self shortAtOffset: dmYResolution]

{ #category : #accessing }
DEVMODE >> dmYResolution: anInteger [
	self
		shortAtOffset: dmYResolution put: anInteger;
		dmFields: self dmFields | DM_YRESOLUTION]

{ #category : #output }
DEVMODE >> driverData [
	^self
		bytesAtOffset: dmICMMethod
		count: self dmDriverExtra]

{ #category : #initialization }
DEVMODE >> initialize: anInteger [
	super initialize: anInteger.
	self
		dmSize: anInteger;
		dmSpecVersion: DM_SPECVERSION;
		dmDefaultSource: DMBIN_AUTO]

{ #category : #testing }
DEVMODE >> isA3 [
	^self dmPaperSize = DMPAPER_A3]

{ #category : #testing }
DEVMODE >> isA4 [
	^self dmPaperSize = DMPAPER_A4]

{ #category : #testing }
DEVMODE >> isLandscape [
	^self dmOrientation = DMORIENT_LANDSCAPE]

{ #category : #testing }
DEVMODE >> isLegal [
	^self dmPaperSize = DMPAPER_LEGAL]

{ #category : #testing }
DEVMODE >> isLetter [
	^self dmPaperSize = DMPAPER_LETTER]

{ #category : #testing }
DEVMODE >> isPortrait [
	^self dmOrientation = DMORIENT_PORTRAIT]

{ #category : #inputs }
DEVMODE >> landscape [
	self dmOrientation: DMORIENT_LANDSCAPE]

{ #category : #inputs }
DEVMODE >> legal [
	self dmPaperSize: DMPAPER_LEGAL]

{ #category : #inputs }
DEVMODE >> letter [
	self dmPaperSize: DMPAPER_LETTER]

{ #category : #inputs }
DEVMODE >> paperLength: millimeters [
	self dmPaperLength: (millimeters * 10) rounded]

{ #category : #inputs }
DEVMODE >> paperWidth: millimeters [
	self dmPaperWidth: (millimeters * 10) rounded]

{ #category : #output }
DEVMODE >> pixelHeight [
	^self dmPelsHeight]

{ #category : #output }
DEVMODE >> pixelWidth [
	^self breadth]

{ #category : #inputs }
DEVMODE >> portrait [
	self dmOrientation: DMORIENT_PORTRAIT]

{ #category : #output }
DEVMODE >> position [
	^self dmPosition asPoint]

{ #category : #marshalling }
DEVMODE >> stringAtOffset: offset count: n [
	| bytes string last |
	bytes := self bytesAtOffset: offset count: n.
	string := UTF16 current decode: bytes.
	string first asInteger = 0 ifTrue: [^''].
	string := string reduced.
	last := string findLast: [:ch | ch asInteger != 0] ifAbsent: [^string].
	^string copyFrom: 1 to: last]

{ #category : #testing }
DEVMODE >> supportsCollation [
	^(self dmFields bitAnd: DM_COLLATE) = DM_COLLATE]

{ #category : #testing }
DEVMODE >> usesCollation [
	^self supportsCollation and: [self dmCollate = DMCOLLATE_TRUE]]

{ #category : #testing }
DEVMODE >> usesColor [
	^self dmColor = DMCOLOR_COLOR]

