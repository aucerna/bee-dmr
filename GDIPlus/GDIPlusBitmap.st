"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusBitmap,
	#superclass : #GDIPlusImage,
	#category : #GDIPlus
}

{ #category : #private }
GDIPlusBitmap class >> basicCreateBitmapWidth: width
height: height
pixelFormat: pixelFormat
stride: stride
scan: scan [
	| pointer status bytes |
	pointer := ExternalPointer external.
	bytes := scan notNil ifTrue: [scan asByteArray externalCopy].
	status := self dll
		GdipCreateBitmapFromScan0: width
		height: height
		stride: stride
		format: pixelFormat
		scan0: scan asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	bytes notNil ifTrue: [bytes free].
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusBitmap class >> cache [
	cache isNil ifTrue: [cache := Dictionary new].
	^cache]

{ #category : #accessing }
GDIPlusBitmap class >> cacheAt: key ifAbsentPut: aBlock [
	| bitmap |
	key isNil ifTrue: [^aBlock value].
	bitmap := self cache at: key ifAbsent: nil.
	bitmap notNil ifTrue: [^bitmap].
	self cache size > 1000 ifTrue: [self invalidateCache].
	^self cache at: key put: aBlock value]

{ #category : #'instance creation' }
GDIPlusBitmap class >> createBitmapWidth: width height: height pixelFormat: pixelFormat [
	^self
		createBitmapWidth: width
		height: height
		pixelFormat: pixelFormat
		stride: 0
		scan: nil]

{ #category : #'instance creation' }
GDIPlusBitmap class >> createBitmapWidth: width
height: height
pixelFormat: pixelFormat
stride: stride
scan: scan [
	| bitmap |
	bitmap := [
		self
			basicCreateBitmapWidth: width
			height: height
			pixelFormat: pixelFormat
			stride: stride
			scan: scan]
		on: Error
		do: [
			Smalltalk collectGarbage.
			nil].
	^bitmap ifNil: [
		self
			basicCreateBitmapWidth: width
			height: height
			pixelFormat: pixelFormat
			stride: stride
			scan: scan]]

{ #category : #'instance creation' }
GDIPlusBitmap class >> extent: aPoint [
	^self width: (aPoint x max: 1) height: (aPoint y max: 1)]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromAlphaBitmap: aBitmap [
	| source destination |
	source := self fromHBitmap: aBitmap asParameter.
	[| read |
		read := source readBuffer.
		[| write |
			read hasAlphaInformation ifFalse: [^nil].
			destination := self
				createBitmapWidth: read width
				height: read height
				pixelFormat: PixelFormat32bppARGB.
			write := destination writeBuffer.
			[write copyFrom: read] ensure: [destination unlockBits: write]]
			ensure: [source unlockBits: read]]
		ensure: [source release].
	^destination]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromDirectDrawSurface: anIDirectDrawSurface7 [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateBitmapFromDirectDrawSurface: anIDirectDrawSurface7 asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromFile: filename useICM: aBoolean [
	| file pointer status |
	file := filename externalCopy.
	pointer := ExternalPointer external.
	status := aBoolean
		ifTrue: [
			self dll
				GdipCreateBitmapFromFileICM: file asParameter
				bitmap: pointer asParameter]
		ifFalse: [
			self dll
				GdipCreateBitmapFromFile: file asParameter
				bitmap: pointer asParameter].
	self checkStatus: status.
	file free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromGdiDib: aBITMAPINFO gdiBitmapData: aByteArray [
	| pointer info data status |
	pointer := ExternalPointer external.
	info := aBITMAPINFO externalCopy.
	data := aByteArray externalCopy.
	status := self dll
		GdipCreateBitmapFromGdiDib: info asParameter
		gdiBitmapData: data asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	info == aBITMAPINFO ifFalse: [info free].
	data == aByteArray ifFalse: [data free].
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromGraphics: aGDIPlusGraphics width: width height: height [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateBitmapFromGraphics: width
		height: height
		target: aGDIPlusGraphics asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromHBitmap: hbm [
	^self fromHBitmap: hbm hPalette: nil]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromHBitmap: hBitmap hPalette: hPalette [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateBitmapFromHBITMAP: hBitmap asParameter
		hpal: hPalette asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromHIcon: hIcon [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateBitmapFromHICON: hIcon asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromIcon: anIcon [
	| source destination |
	anIcon bitsPerPixel = 32 ifFalse: [^self fromHIcon: anIcon asParameter].
	source := self fromHBitmap: anIcon struct hbmColor.
	[| read |
		read := source readBuffer.
		[| write |
			read hasAlphaInformation ifFalse: [^self fromHIcon: anIcon asParameter].
			destination := self
				createBitmapWidth: read width
				height: read height
				pixelFormat: PixelFormat32bppARGB.
			write := destination writeBuffer.
			[write copyFrom: read] ensure: [destination unlockBits: write]]
			ensure: [source unlockBits: read]]
		ensure: [source release].
	destination isNil ifTrue: [^self fromHIcon: anIcon asParameter].
	^destination]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromIStream: anIStream useICM: aBoolean [
	| pointer status |
	pointer := ExternalPointer external.
	status := aBoolean
		ifTrue: [
			self dll
				GdipCreateBitmapFromStreamICM: anIStream asParameter
				bitmap: pointer asParameter]
		ifFalse: [
			self dll
				GdipCreateBitmapFromStream: anIStream asParameter
				bitmap: pointer asParameter].
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusBitmap class >> fromResource: hInstance bitmapName: aString [
	| pointer string status |
	pointer := ExternalPointer external.
	string := aString externalCopy.
	status := self dll
		GdipCreateBitmapFromResource: hInstance asParameter
		lpBitmapName: string asParameter
		bitmap: pointer asParameter.
	self checkStatus: status.
	string free.
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusBitmap class >> invalidateCache [
	cache := nil]

{ #category : #accessing }
GDIPlusBitmap class >> named: aString [
	^self cache at: aString ifAbsent: nil]

{ #category : #accessing }
GDIPlusBitmap class >> named: aString ifAbsent: aBlock [
	^self cacheAt: aString ifAbsentPut: aBlock]

{ #category : #'instance creation' }
GDIPlusBitmap class >> new [
	^self width: 600 height: 400]

{ #category : #'instance creation' }
GDIPlusBitmap class >> width: width height: height [
	^self createBitmapWidth: width height: height pixelFormat: PixelFormat32bppARGB]

{ #category : #converting }
GDIPlusBitmap >> asBitmap [
	^self asGDIBitmap]

{ #category : #converting }
GDIPlusBitmap >> asCachedBitmap [
	^GDIPlusCachedBitmap fromBitmap: self graphics: self graphics]

{ #category : #converting }
GDIPlusBitmap >> asGDIBitmap [
	| token |
	token := self getHBitmap: Color white.
	^(GDIBitmap fromHandle: token) requireFinalization]

{ #category : #converting }
GDIPlusBitmap >> asGDIPlusBitmap [
	^self]

{ #category : #converting }
GDIPlusBitmap >> asPrecalculatedBitmap [
	^self clone: self boundingBox pixelFormat: PixelFormat32bppPARGB]

{ #category : #converting }
GDIPlusBitmap >> asTransparentBitmap [
	^self asBitmap asTransparentBitmap]

{ #category : #copying }
GDIPlusBitmap >> clone: rect pixelFormat: pixelFormat [
	^self
		clone: rect left
		y: rect top
		width: rect width
		height: rect height
		pixelFormat: pixelFormat]

{ #category : #copying }
GDIPlusBitmap >> clone: x
y: y
width: w
height: h
pixelFormat: pixelFormat [
	| pointer xr yr wr hr |
	pointer := ExternalPointer external.
	status := (x isInteger
		and: [y isInteger]
		and: [w isInteger]
		and: [h isInteger])
		ifTrue: [
			self dll
				GdipCloneBitmapAreaI: x
				y: y
				width: w
				height: h
				format: pixelFormat
				srcBitmap: self asParameter
				dstBitmap: pointer asParameter]
		ifFalse: [
			xr := ExternalFloat from: x.
			yr := ExternalFloat from: y.
			wr := ExternalFloat from: w.
			hr := ExternalFloat from: h.
			self dll
				GdipCloneBitmapArea: xr asParameter
				y: yr asParameter
				width: wr asParameter
				height: hr asParameter
				format: pixelFormat
				srcBitmap: self asParameter
				dstBitmap: pointer asParameter].
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusBitmap >> drawAt: aPoint using: aDrawer [
	self asBitmap drawAt: aPoint using: aDrawer]

{ #category : #accessing }
GDIPlusBitmap >> drawer [
	^GDIPlusDrawer new on: self]

{ #category : #private }
GDIPlusBitmap >> getHBitmap: colorBackground [
	| pointer argb |
	pointer := ExternalPointer external.
	argb := ARGB from: colorBackground.
	status := self dll
		GdipCreateHBITMAPFromBitmap: self asParameter
		hbmReturn: pointer asParameter
		background: argb asParameter.
	self checkStatus.
	^pointer makeLocal asUnsignedInteger]

{ #category : #private }
GDIPlusBitmap >> getHIcon [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateHICONFromBitmap: self asParameter
		hbmReturn: pointer asParameter.
	self checkStatus.
	^pointer makeLocal asUnsignedInteger]

{ #category : #testing }
GDIPlusBitmap >> isBitmap [
	^true]

{ #category : #testing }
GDIPlusBitmap >> isImage [
	^true]

{ #category : #private }
GDIPlusBitmap >> lockBits: rectangle flags: flags pixelFormat: pixelFormat [
	| data rect |
	data := BitmapData external.
	rect := RECT external from: rectangle.
	status := self dll
		GdipBitmapLockBits: self asParameter
		rect: rect asParameter
		flags: flags
		format: pixelFormat
		lockedBitmapData: data asParameter.
	self checkStatus.
	rect free.
	^data makeLocal]

{ #category : #accessing }
GDIPlusBitmap >> pixelAt: aPoint [
	| color |
	color := ARGB external.
	status := self dll
		GdipBitmapGetPixel: self asParameter
		x: aPoint x asInteger
		y: aPoint y asInteger
		color: color asParameter.
	self checkStatus.
	^color makeLocal asColor]

{ #category : #printing }
GDIPlusBitmap >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: self width printString;
		nextPutAll: ' x ';
		nextPutAll: self height printString]

{ #category : #private }
GDIPlusBitmap >> rawData [
	| buffer bytes |
	buffer := self readBuffer.
	[bytes := buffer getBytes] ensure: [self unlockBits: buffer].
	^bytes]

{ #category : #services }
GDIPlusBitmap >> readBuffer [
	| box |
	box := 0 @ 0 extent: self extent.
	^self lockBits: box flags: ImageLockModeRead pixelFormat: self pixelFormat]

{ #category : #accessing }
GDIPlusBitmap >> setPixel: aPoint color: color [
	| argb |
	argb := ARGB from: color.
	status := self dll
		GdipBitmapSetPixel: self asParameter
		x: aPoint x asInteger
		y: aPoint y asInteger
		color: argb asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusBitmap >> setResolution: x y: y [
	| xdpi ydpi |
	xdpi := ExternalFloat from: x.
	ydpi := ExternalFloat from: y.
	status := self dll
		GdipBitmapSetResolution: self asParameter
		xdpi: xdpi asParameter
		ydpi: ydpi asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusBitmap >> unlockBits: aBitmapData [
	| data |
	data := aBitmapData externalCopy.
	status := self dll
		GdipBitmapUnlockBits: self asParameter
		lockedBitmapData: data asParameter.
	self checkStatus.
	data free]

{ #category : #services }
GDIPlusBitmap >> writeBuffer [
	| box |
	box := 0 @ 0 extent: self extent.
	^self lockBits: box flags: ImageLockModeWrite pixelFormat: self pixelFormat]

