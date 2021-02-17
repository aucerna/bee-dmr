"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIFont,
	#superclass : #GDIObject,
	#instVars : [
		'size',
		'logical',
		'metrics',
		'dc'
	],
	#classVars : [
		'ButtonFont',
		'Cache',
		'PointSize',
		'StatusFont',
		'TextFont'
	],
	#category : #GDI
}

{ #category : #'instance accessing' }
GDIFont class >> buttonFont: aGDIFont [
	ButtonFont := aGDIFont]

{ #category : #services }
GDIFont class >> cleanUp [
	self allExistingInstances do: [:f | f clearHandle].
	Cache
		do: [:h | (GDILibrary DeleteObject: h) ifFalse: [self winNotification]].
	Cache := Dictionary new]

{ #category : #services }
GDIFont class >> decreasePointSize: n [
	n > 80 ifTrue: [^n - 10].
	n > 72 ifTrue: [^72].
	n > 48 ifTrue: [^48].
	n > 36 ifTrue: [^36].
	n > 28 ifTrue: [^28].
	n > 12 ifTrue: [^n - 2].
	^n - 1]

{ #category : #'instance accessing' }
GDIFont class >> defaulListFont [
	^TextFont]

{ #category : #'instance creation' }
GDIFont class >> default [
	^self stockObject: SYSTEM_FONT]

{ #category : #'instance accessing' }
GDIFont class >> defaultButtonFont [
	^ButtonFont]

{ #category : #'instance accessing' }
GDIFont class >> defaultFont: aGDIFont [
	TextFont := aGDIFont.
	self saveFont: aGDIFont as: 'defaultFont']

{ #category : #'instance accessing' }
GDIFont class >> defaultFonts [
	^Set with: TextFont with: ButtonFont]

{ #category : #accessing }
GDIFont class >> defaultPointSize [
	^PointSize]

{ #category : #'instance accessing' }
GDIFont class >> defaultTextFont [
	^TextFont]

{ #category : #services }
GDIFont class >> deviceContextDeleted: aDeviceContext from: device [
	| dc |
	dc := device deviceContext.
	self allInstances
		do: [:font | font deviceContext == aDeviceContext
			ifTrue: [font print deviceContext: dc]]]

{ #category : #'instance creation' }
GDIFont class >> face: aString height: hPixels [
	^self face: aString height: hPixels dc: VirtualScreen current deviceContext]

{ #category : #'instance creation' }
GDIFont class >> face: aString height: hPixels dc: aDeviceContext [
	| p |
	p := (aDeviceContext dpToLp: 0 @ hPixels) - (aDeviceContext dpToLp: 0 @ 0).
	^self new
		face: aString;
		fixedWidth: false;
		charset: ANSI_CHARSET;
		deviceContext: aDeviceContext;
		charSize: p y]

{ #category : #'instance creation' }
GDIFont class >> face: aString size: anInteger [
	^self face: aString size: anInteger fixedWidth: false]

{ #category : #'instance creation' }
GDIFont class >> face: aString size: anInteger fixedWidth: aBoolean [
	^self
		face: aString
		size: anInteger
		fixedWidth: aBoolean
		screen: VirtualScreen current]

{ #category : #'instance creation' }
GDIFont class >> face: aString
size: fontSize
fixedWidth: aBoolean
screen: aScreen [
	^self new
		face: aString;
		fixedWidth: aBoolean;
		charset: DEFAULT_CHARSET;
		deviceContext: aScreen deviceContext;
		pointSize: fontSize]

{ #category : #'instance creation' }
GDIFont class >> fromLogicalFont: aLOGFONT [
	^self
		fromLogicalFont: aLOGFONT
		deviceContext: VirtualScreen current deviceContext]

{ #category : #'instance creation' }
GDIFont class >> fromLogicalFont: aLOGFONT deviceContext: aDeviceContext [
	^self new logicalFont: aLOGFONT; deviceContext: aDeviceContext]

{ #category : #'startup/shutdown' }
GDIFont class >> getFontAt: aString [
	| spec size |
	spec := SmalltalkSession current getIniInfo: 'Fonts' key: aString.
	spec isNil ifTrue: [^nil].
	spec := $, split: spec.
	size := spec size > 1 ifTrue: [spec second asNumber] ifFalse: [9].
	^self face: spec first size: size]

{ #category : #services }
GDIFont class >> increasePointSize: n [
	n < 11 ifTrue: [^n + 1].
	n < 28 ifTrue: [^n + 2].
	n < 36 ifTrue: [^36].
	n < 48 ifTrue: [^48].
	n < 72 ifTrue: [^72].
	n < 80 ifTrue: [^80].
	n <= 1638 ifTrue: [^n + 10].
	^n]

{ #category : #'instance creation' }
GDIFont class >> logicalFont: aLOGFONT handle: anExternalHandle [
	| font handle |
	font := self basicNew.
	font logicalFont: aLOGFONT.
	handle := Cache
		at: aLOGFONT contents
		ifAbsentPut: [anExternalHandle].
	^font handle: handle]

{ #category : #'instance creation' }
GDIFont class >> new [
	^super new initialize]

{ #category : #services }
GDIFont class >> saveFont: aGDIFont as: aString [
	| f |
	f := aGDIFont notNil
		ifTrue: [aGDIFont face , ',' , aGDIFont pointSize asString].
	SmalltalkSession current setIniInfo: 'Fonts' key: aString value: f]

{ #category : #'startup/shutdown' }
GDIFont class >> sessionShutdown [
	self cleanUp]

{ #category : #'startup/shutdown' }
GDIFont class >> startUp [
	Cache := Dictionary new.
	PointSize := (self stockObject: SYSTEM_FONT) pointSize.
	TextFont isNil ifTrue: [
		TextFont := (self getFontAt: 'textFont')
			ifNil: [(self getFontAt: 'defaultFont')
				ifNil: [VirtualScreen current messageFont]]].
	ButtonFont isNil
		ifTrue: [ButtonFont := (self getFontAt: 'buttonFont')
			ifNil: [self statusFont]].
	self allInstances do: [:font | font updateHandle]]

{ #category : #'instance accessing' }
GDIFont class >> statusFont [
	"
	Font statusFont
	"
	StatusFont isNil ifTrue: [StatusFont := VirtualScreen current statusFont].
	^StatusFont]

{ #category : #'instance accessing' }
GDIFont class >> stockObject: anInteger [
	| handle font |
	handle := GDILibrary GetStockObject: anInteger.
	font := self fromHandle: handle.
	Cache at: font logicalFont contents copy put: handle.
	^font]

{ #category : #accessing }
GDIFont class >> structClass [
	^LOGFONT]

{ #category : #private }
GDIFont class >> update [
	self cleanUp.
	StatusFont := nil.
	self allInstances do: [:f | f clearHandle; pointSize: f pointSize]]

{ #category : #accessing }
GDIFont >> ascent [
	^self metrics ascent]

{ #category : #converting }
GDIFont >> asParameter [
	handle isNil ifTrue: [self realize].
	^handle]

{ #category : #accessing }
GDIFont >> basePoint [
	^0 @ self metrics ascent]

{ #category : #accessing }
GDIFont >> basicStringWidth: aString [
	^self widthOfString: aString]

{ #category : #accessing }
GDIFont >> beBold [
	self bold: true]

{ #category : #accessing }
GDIFont >> beItalic [
	self italic: true]

{ #category : #accessing }
GDIFont >> beStrikenout [
	self strikeout: true]

{ #category : #accessing }
GDIFont >> beUnderlined [
	self underline: true]

{ #category : #testing }
GDIFont >> bold [
	^logical weight = FW_BOLD]

{ #category : #accessing }
GDIFont >> bold: aBoolean [
	| weight |
	weight := aBoolean ifTrue: [FW_BOLD] ifFalse: [FW_NORMAL].
	logical weight: weight]

{ #category : #accessing }
GDIFont >> boldCopy [
	^self copy bold: true]

{ #category : #accessing }
GDIFont >> charset [
	^metrics isNil ifTrue: [logical charset] ifFalse: [metrics charset]]

{ #category : #accessing }
GDIFont >> charset: charset [
	self
		ASSERT: (#[ANSI_CHARSET DEFAULT_CHARSET OEM_CHARSET SYMBOL_CHARSET]
			includes: charset).
	charset notNil ifTrue: [logical charset: charset]]

{ #category : #accessing }
GDIFont >> charSize [
	^self metrics charAverageWidth @ self metrics height]

{ #category : #accessing }
GDIFont >> charSize: anInteger [
	logical width: 0; height: anInteger]

{ #category : #accessing }
GDIFont >> charWidth [
	^self metrics charAverageWidth]

{ #category : #private }
GDIFont >> clearHandle [
	handle := nil.
	self deviceContext: VirtualScreen current deviceContext]

{ #category : #private }
GDIFont >> createFont [
	| copy success h |
	copy := logical externalCopy.
	handle := GDILibrary CreateFontIndirectW: copy asParameter.
	handle = 0 ifTrue: [^self winError].
	copy free.
	self update.
	h := Cache at: logical contents ifAbsent: [
		Cache at: logical contents copy put: handle.
		^self].
	success := GDILibrary DeleteObject: handle.
	success ifFalse: [self winError].
	handle := h]

{ #category : #scaling }
GDIFont >> decreased [
	| n |
	n := self class decreasePointSize: self pointSize.
	^self resizedTo: n]

{ #category : #accessing }
GDIFont >> descender [
	^self height - self ascent]

{ #category : #accessing }
GDIFont >> descent [
	^self metrics descent]

{ #category : #accessing }
GDIFont >> deviceContext [
	^dc]

{ #category : #accessing }
GDIFont >> deviceContext: aDeviceContext [
	dc := aDeviceContext.
	metrics := nil]

{ #category : #comparing }
GDIFont >> equals: aFont [
	self == aFont ifTrue: [^true].
	self face = aFont face ifFalse: [^false].
	size = aFont pointSize ifFalse: [^false].
	self isFixedWidth = aFont isFixedWidth ifFalse: [^false].
	self italic = aFont italic ifFalse: [^false].
	self strikeout = aFont strikeout ifFalse: [^false].
	self underline = aFont underline ifFalse: [^false].
	self logicalWeight = aFont logicalWeight ifFalse: [^false].
	^true]

{ #category : #accessing }
GDIFont >> face [
	^logical lfFaceName]

{ #category : #accessing }
GDIFont >> face: aString [
	logical lfFaceName: aString]

{ #category : #accessing }
GDIFont >> fixedWidth: aBoolean [
	| pitch |
	pitch := aBoolean ifTrue: [FIXED_PITCH] ifFalse: [VARIABLE_PITCH].
	logical pitch: pitch]

{ #category : #private }
GDIFont >> fromStruct: aLOGFONT [
	logical := aLOGFONT.
	self metrics: self textMetric]

{ #category : #accessing }
GDIFont >> handle: aHandle [
	handle := aHandle]

{ #category : #accessing }
GDIFont >> height [
	^self metrics height]

{ #category : #styles }
GDIFont >> horizontal [
	self angle: 0]

{ #category : #inquiries }
GDIFont >> includesUnicodeGlyph: aCharacter [
	| integer |
	integer := aCharacter codePoint.
	^self unicodeRanges anySatisfy: [:r | r includes: integer]]

{ #category : #scaling }
GDIFont >> increased [
	| n |
	n := self class increasePointSize: self pointSize.
	^self resizedTo: n]

{ #category : #private }
GDIFont >> indexOf: address
at: width
between: index1
and: index2
dc: hdc [
	| wp mid i j |
	index1 = index2 ifTrue: [^index1].
	wp := POINT external.
	mid := index1 + index2 // 2.
	GDILibrary
		GetTextExtentPoint32W: hdc
		lpString: address asParameter
		c: mid
		lpSize: wp asParameter.
	width <= (wp makeLocal x - self overhang)
		ifTrue: [
			mid = index1 ifTrue: [^index1].
			i := index1.
			j := mid]
		ifFalse: [
			mid = index1 ifTrue: [^index2].
			i := mid.
			j := index2].
	^self
		indexOf: address
		at: width
		between: i
		and: j
		dc: hdc]

{ #category : #inquiries }
GDIFont >> indexOf: aString at: width dc: hdc [
	| memory index |
	aString size = 0 ifTrue: [^0].
	memory := aString externalCopy.
	GDIDLL current selectObject: self into: hdc while: [
		index := self
			indexOf: memory
			at: width
			between: 1
			and: memory length - 2 // 2
			dc: hdc asParameter].
	memory free.
	^index]

{ #category : #initialization }
GDIFont >> initialize [
	super initialize.
	logical := LOGFONT new quality: PROOF_QUALITY.
	dc := VirtualScreen current deviceContext]

{ #category : #testing }
GDIFont >> isFixedWidth [
	^logical pitch isOnBit: FIXED_PITCH]

{ #category : #testing }
GDIFont >> isTrueType [
	^self metrics isTrueType]

{ #category : #testing }
GDIFont >> isVertical [
	^logical escapement = 900 and: [logical orientation = 900]]

{ #category : #testing }
GDIFont >> italic [
	^logical italic]

{ #category : #accessing }
GDIFont >> italic: aBoolean [
	logical italic: aBoolean]

{ #category : #accessing }
GDIFont >> lineSpacing [
	^self metrics lineSpacing]

{ #category : #private }
GDIFont >> logFont [
	| struct return |
	struct := LOGFONT external.
	return := GDILibrary
		GetObjectW: self asParameter
		cbBuffer: struct sizeInBytes
		lpvObject: struct asParameter.
	return = 0 ifTrue: [self winError].
	^struct makeLocal]

{ #category : #accessing }
GDIFont >> logicalFont [
	^logical]

{ #category : #accessing }
GDIFont >> logicalFont: aLOGFONT [
	logical := aLOGFONT]

{ #category : #accessing }
GDIFont >> logicalWeight [
	^logical weight]

{ #category : #private }
GDIFont >> metrics [
	handle isNil ifTrue: [self realize].
	metrics isNil ifTrue: [self update].
	^metrics]

{ #category : #accessing }
GDIFont >> metrics: aTEXTMETRIC [
	metrics := aTEXTMETRIC.
	size isNil
		ifTrue: [size := dc
			pointFromPixel: metrics height - metrics internalLeading]]

{ #category : #inquiries }
GDIFont >> otherWidthOfCharacter: aCharacter deviceContext: aDeviceContext [
	| buffer success |
	buffer := BufferArray externalNew: 1 of: ExternalInt32.
	success := GDILibrary
		getCharWidth32: aDeviceContext asParameter
		iFirstChar: aCharacter asParameter
		iLastChar: aCharacter asParameter
		lpBuffer: buffer asParameter.
	success ifFalse: [^self winNotification].
	^buffer makeLocal asArray first asInteger]

{ #category : #accessing }
GDIFont >> overhang [
	^self metrics overhang]

{ #category : #accessing }
GDIFont >> pointSize [
	size isNil ifTrue: [self realize].
	^size]

{ #category : #accessing }
GDIFont >> pointSize: anInteger [
	self pointSize: anInteger dc: dc]

{ #category : #accessing }
GDIFont >> pointSize: anInteger dc: aDeviceContext [
	| point |
	aDeviceContext notNil ifTrue: [
		point := aDeviceContext logicalFromPoint: anInteger.
		logical
			width: 0;
			height: 0 - point y abs].
	dc := aDeviceContext.
	size := anInteger]

{ #category : #printing }
GDIFont >> printOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' face: ';
		nextPutAll: self face reduced storeString;
		nextPutAll: ' size: ';
		nextPutAll: size printString;
		nextPut: $).
	self bold ifTrue: [aStream nextPutAll: ' beBold'].
	self italic ifTrue: [aStream nextPutAll: ' beItalic'].
	aStream nextPutAll: ' realize']

{ #category : #actions }
GDIFont >> realize [
	handle := Cache at: logical contents ifAbsent: [
		self createFont.
		^self].
	self update]

{ #category : #scaling }
GDIFont >> resizedTo: aNumber [
	aNumber = size ifTrue: [^self].
	^self copy pointSize: aNumber]

{ #category : #scaling }
GDIFont >> scaleBy: aNumber [
	^self resizedTo: (size * aNumber) rounded]

{ #category : #inquiries }
GDIFont >> spaceWidth [
	^self widthOfCharacter: $ ]

{ #category : #printing }
GDIFont >> storeOn: aStream [
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' face: ';
		nextPutAll: self face storeString;
		nextPutAll: ' size: ';
		nextPutAll: size printString;
		nextPut: $).
	self bold ifTrue: [aStream nextPutAll: ' beBold'].
	self italic ifTrue: [aStream nextPutAll: ' beItalic'].
	self underline ifTrue: [aStream nextPutAll: ' beUnderline'].
	self strikeout ifTrue: [aStream nextPutAll: ' beStrikenout']]

{ #category : #testing }
GDIFont >> strikeout [
	^logical strikeout]

{ #category : #accessing }
GDIFont >> strikeout: aBoolean [
	logical strikeout: aBoolean]

{ #category : #services }
GDIFont >> stringExtent: aString [
	^(self widthOfString: aString) @ self lineSpacing]

{ #category : #private }
GDIFont >> textMetric [
	^dc textMetric]

{ #category : #inquiries }
GDIFont >> trueTypeWidthOfCharacter: aCharacter deviceContext: aDeviceContext [
	"
	TextFont trueTypeCharWidth: $i deviceContext: TextFont deviceContext
	"
	| buffer success |
	buffer := BufferArray externalNew: 1 of: ABC.
	success := GDILibrary
		GetCharABCWidths: aDeviceContext asParameter
		uFirstChar: aCharacter asParameter
		uLastChar: aCharacter asParameter
		lpabc: buffer asParameter.
	success ifFalse: [self winNotification].
	^buffer makeLocal asArray first total]

{ #category : #testing }
GDIFont >> underline [
	^logical underline]

{ #category : #accessing }
GDIFont >> underline: aBoolean [
	logical underline: aBoolean]

{ #category : #inquiries }
GDIFont >> unicodeRanges [
	"
	TextFont unicodeRanges
	"
	| bytes structure ulong |
	bytes := GDIDLL current GetFontUnicodeRanges: dc asParameter lpgs: 0.
	structure := GLYPHSET external: bytes.
	ulong := GDIDLL current
		GetFontUnicodeRanges: dc asParameter
		lpgs: structure asParameter.
	self ASSERT: ulong = bytes.
	^structure makeLocal ranges asArray collect: #asInterval]

{ #category : #private }
GDIFont >> update [
	| return |
	handle isNil ifTrue: [^self].
	return := GDILibrary SelectObject: dc asParameter hgdiobj: self asParameter.
	return = 0 ifTrue: [self winError].
	logical := self logFont.
	self metrics: self textMetric]

{ #category : #private }
GDIFont >> updateHandle [
	self clearHandle.
	(size notNil
		and: [VirtualScreen current originalExtent != VirtualScreen current extent])
		ifTrue: [self pointSize: size].
	self realize]

{ #category : #accessing }
GDIFont >> weight [
	^metrics isNil
		ifTrue: [logical weight]
		ifFalse: [metrics weight]]

{ #category : #accessing }
GDIFont >> width [
	^self metrics charAverageWidth]

{ #category : #accessing }
GDIFont >> widthOfCharacter: aCharacter [
	^GDILibrary
		selectObject: self
		into: dc
		while: [self widthOfCharacter: aCharacter deviceContext: dc]]

{ #category : #inquiries }
GDIFont >> widthOfCharacter: aCharacter deviceContext: aDeviceContext [
	| width |
	width := self isTrueType
		ifTrue: [self
			trueTypeWidthOfCharacter: aCharacter
			deviceContext: aDeviceContext]
		ifFalse: [self
			otherWidthOfCharacter: aCharacter
			deviceContext: aDeviceContext].
	^width - self overhang]

{ #category : #inquiries }
GDIFont >> widthOfString: aString [
	^self widthOfString: aString deviceContext: dc]

{ #category : #inquiries }
GDIFont >> widthOfString: aString deviceContext: aDeviceContext [
	| w |
	aString size = 0 ifTrue: [^0].
	self ASSERT: aDeviceContext mapMode = MM_TEXT.
	GDILibrary
		selectObject: self asParameter
		into: aDeviceContext
		while: [w := aDeviceContext widthOfString: aString].
	^w - self overhang]

