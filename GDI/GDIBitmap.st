"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIBitmap,
	#superclass : #GDIObject,
	#instVars : [
		'info',
		'dc',
		'alpha',
		'name'
	],
	#classVars : [
		'SharedContext'
	],
	#category : #GDI
}

{ #category : #accessing }
GDIBitmap class >> cache [
	^BitmapPool currentPool]

{ #category : #accessing }
GDIBitmap class >> cacheAt: key ifAbsentPut: aBlock [
	^BitmapPool cacheAt: key ifAbsentPut: aBlock]

{ #category : #accessing }
GDIBitmap class >> cacheAt: key put: g [
	^BitmapPool cacheAt: key put: g]

{ #category : #'instance creation' }
GDIBitmap class >> copyFromHandle: handle [
	^(self fromHandle: handle) clone]

{ #category : #services }
GDIBitmap class >> createBoxOfColor: aColor [
	| box box2 p q r bmp |
	bmp := GDIBitmap extent: 16 @ 16.
	bmp drawerDo: [:drawer | 
		box := drawer boundingRectangle insetBy: 1.
		box2 := drawer boundingRectangle insetBy: (0 @ 0 corner: 1 @ 1).
		drawer
			lineColor: aColor;
			brushColor: aColor;
			drawRectangleFilled: box2;
			lineColor: Color white;
			drawRectangle: box2.
		p := box rightTop.
		q := box rightBottom.
		r := box leftBottom.
		drawer drawLines: {p. q. r} width: 1 color: (Color r: 70 g: 70 b: 70)].
	^bmp]

{ #category : #services }
GDIBitmap class >> createCircleOfColor: aColor [
	| bmp |
	bmp := GDIBitmap width: 16 height: 16 bitCount: 32.
	bmp drawerDo: [:drawer | | bc |
		bc := aColor = Color white ifTrue: [Color gray] ifFalse: [Color white].
		drawer backColor: bc; clear.
		drawer
			lineColor: aColor;
			brushColor: aColor;
			drawCircleFilled: 4 at: 8 @ 8].
	^bmp asTransparentBitmap]

{ #category : #accessing }
GDIBitmap class >> defaultBitmap [
	^self sharedContext currentObject: OBJ_BITMAP]

{ #category : #'instance creation' }
GDIBitmap class >> extent: n [
	| point |
	point := n isInteger ifTrue: [n @ n] ifFalse: [n].
	^self width: point x height: point y]

{ #category : #'instance creation' }
GDIBitmap class >> extent: aPoint bitCount: anInteger [
	^self width: aPoint x height: aPoint y bitCount: anInteger]

{ #category : #'instance creation' }
GDIBitmap class >> fileInFrom: aStream [
	^self fromStream: aStream]

{ #category : #'instance creation' }
GDIBitmap class >> fromBitmap: aBitmap [
	^self new fromBitmap: aBitmap]

{ #category : #'instance creation' }
GDIBitmap class >> fromBitmapInfo: aBITMAPINFO bits: aByteArray [
	^self new info: aBITMAPINFO; createBitmapFromBits: aByteArray]

{ #category : #'instance creation' }
GDIBitmap class >> fromFile: anExternalLibrary id: anInteger [
	^self new fromFile: anExternalLibrary id: anInteger]

{ #category : #'instance creation' }
GDIBitmap class >> fromFileNamed: aFilename [
	| stream |
	stream := aFilename asFilename asFile readStream.
	^[self fromStream: stream] ensure: [stream close]]

{ #category : #'instance creation' }
GDIBitmap class >> fromScreen: aRectangle [
	| bitmap screen |
	bitmap := self extent: aRectangle extent.
	screen := Screen fromPoint: aRectangle center.
	bitmap
		useValidDCWhile: [:dc | dc
			bitBltWith: screen deviceContext
			from: aRectangle
			at: 0 @ 0].
	^bitmap]

{ #category : #'instance creation' }
GDIBitmap class >> fromStream: aStream [
	^self new fromStream: aStream]

{ #category : #'instance creation' }
GDIBitmap class >> fromString: aString [
	| bmp |
	bmp := (Bitmap fromString: aString) asGDIBitmap.
	(aString at: 9) = $A ifTrue: [bmp useAlphaChannel].
	^bmp]

{ #category : #'instance creation' }
GDIBitmap class >> fromUser [
	"
	GDIBitmap fromUser
	"
	| rect |
	rect := VirtualScreen current trackRectangle.
	^rect extent > (1 @ 1) ifTrue: [self fromScreen: rect]]

{ #category : #accessing }
GDIBitmap class >> libraryNamed: aFilename [
	| memory pointer |
	memory := aFilename externalCopy.
	pointer := KernelDLL current LoadLibraryW: memory asParameter.
	pointer = 0 ifTrue: [^self winError].
	memory free.
	^pointer]

{ #category : #accessing }
GDIBitmap class >> maxColorTableDepth [
	^16]

{ #category : #'instance creation' }
GDIBitmap class >> new [
	^super new initialize]

{ #category : #'startup/shutdown' }
GDIBitmap class >> sessionShutdown [
	SharedContext notNil ifTrue: [SharedContext delete]]

{ #category : #accessing }
GDIBitmap class >> sharedContext [
	^SharedContext ifNil: [SharedContext := VirtualScreen current compatibleDC]]

{ #category : #'instance creation' }
GDIBitmap class >> startUp [
	SharedContext := nil]

{ #category : #accessing }
GDIBitmap class >> structClass [
	^BITMAP]

{ #category : #'instance creation' }
GDIBitmap class >> width: w height: h [
	| display |
	display := VirtualScreen current.
	^self width: w height: h bitCount: display bitsPerPixel * display planes]

{ #category : #'instance creation' }
GDIBitmap class >> width: w height: h bitCount: b [
	^self new width: w height: h bitCount: b]

{ #category : #'file in/out' }
GDIBitmap >> activate [
	self ASSERT: handle isAssociation.
	info isNil
		ifTrue: [self fromBitmap: handle value]
		ifFalse: [self createBitmapFromBits: handle value bits]]

{ #category : #services }
GDIBitmap >> addHalo [
	self apply: [:bmp | bmp addHalo]]

{ #category : #services }
GDIBitmap >> addShadow [
	self apply: [:bmp | bmp addShadow]]

{ #category : #accessing }
GDIBitmap >> alphaConstant [
	^alpha isNumber ifTrue: [alpha] ifFalse: [255]]

{ #category : #private }
GDIBitmap >> apply: aBlock [
	| bmp screen memory struct success |
	bmp := self bitmap.
	aBlock evaluateWith: bmp.
	screen := DeviceContext forScreen.
	memory := bmp bits externalCopy.
	struct := info externalCopy.
	success := GDILibrary
		SetDIBits: screen asParameter
		hbmp: self asParameter
		uStartScan: 0
		cScanLines: self height
		lpvBits: memory asParameter
		lpbmi: struct asParameter
		fuColorUse: DIB_RGB_COLORS.
	success = 0 ifTrue: [self winError].
	memory free.
	struct free.
	screen release]

{ #category : #accessing }
GDIBitmap >> applyAlphaChannel [
	self apply: [:bmp | bmp applyAlphaChannel]]

{ #category : #converting }
GDIBitmap >> as32Bitmap [
	| bitmap |
	self bitCount = 32 ifTrue: [^self].
	bitmap := GDIBitmap width: self width height: self height bitCount: 32.
	self useValidDCWhile: [:source | 
		bitmap
			useValidDCWhile: [:target | target
				bitBltWith: source
				from: self boundingRectangle
				at: 0 @ 0]].
	^bitmap]

{ #category : #converting }
GDIBitmap >> asDisabled [
	| suffix key |
	suffix := ' disabled'.
	key := name notNil
		ifTrue: [(name endsWith: suffix) ifTrue: [name] ifFalse: [name , suffix]].
	^key isNil
		ifTrue: [self clone drawDisable]
		ifFalse: [self class cacheAt: key ifAbsentPut: [self clone drawDisable]]]

{ #category : #converting }
GDIBitmap >> asGDIBitmap [
	^self]

{ #category : #converting }
GDIBitmap >> asGrayed [
	| key grayed |
	name notNil ifTrue: [
		key := 'gray' , name capitalized.
		(self class cache bitmapNamed: key) ifNotNil: [:b | ^b]].
	grayed := self clone lightGrayed.
	key notNil ifTrue: [
		grayed name: key.
		self class cacheAt: key put: grayed].
	^grayed]

{ #category : #converting }
GDIBitmap >> asParameter [
	self isAlive ifFalse: [self activate].
	^handle asParameter]

{ #category : #converting }
GDIBitmap >> asTransparentBitmap [
	self hasAlphaChannel ifTrue: [^self].
	^self transparentSample: 0 @ 0]

{ #category : #services }
GDIBitmap >> backColor: aColor [
	self drawerDo: [:drawer | drawer backColor: aColor; clear]]

{ #category : #accessing }
GDIBitmap >> beTransparent [
	alpha := true.
	self applyAlphaChannel]

{ #category : #accessing }
GDIBitmap >> bitCount [
	^info bitCount]

{ #category : #converting }
GDIBitmap >> bitmap [
	^self
		propertyAt: #bitmap
		ifAbsent: [self isAlive
			ifTrue: [Bitmap fromBitmap: self]
			ifFalse: [handle value]]]

{ #category : #accessing }
GDIBitmap >> bitmapInfo [
	^info]

{ #category : #accessing }
GDIBitmap >> boundingRectangle [
	^0 @ 0 extent: self extent]

{ #category : #converting }
GDIBitmap >> cacheBitmap [
	^self propertyAt: #bitmap put: self bitmap]

{ #category : #copying }
GDIBitmap >> clone [
	| bits |
	bits := self getDIBits: true.
	^self copy createBitmapFromBits: bits]

{ #category : #accessing }
GDIBitmap >> colorAt: aPoint [
	| color |
	self useValidDCWhile: [:context | color := context getPixelAt: aPoint].
	^RGBColor fromInteger: color]

{ #category : #accessing }
GDIBitmap >> colors [
	^self bitmap colors]

{ #category : #accessing }
GDIBitmap >> colorsIn: aRectangle [
	^self bitmap colorsIn: aRectangle]

{ #category : #enumerating }
GDIBitmap >> colorsReplace: aBlock [
	self apply: [:bmp | bmp colorsReplace: aBlock]]

{ #category : #services }
GDIBitmap >> copyImage [
	| pointer |
	pointer := UserDLL current
		CopyImage: self asParameter
		uType: IMAGE_BITMAP
		cxDesired: 0
		cyDesired: 0
		fuFlags: LR_CREATEDIBSECTION.
	pointer = 0 ifTrue: [self winError].
	^self class fromHandle: pointer]

{ #category : #services }
GDIBitmap >> copyRectangle: aRectangle [
	| clip |
	clip := self class
		width: aRectangle width
		height: aRectangle height
		bitCount: self bitCount.
	self hasAlphaChannel ifTrue: [clip useAlphaChannel].
	clip
		useValidDCWhile: [:context | context
			copyBitmap: self
			from: aRectangle
			at: 0 @ 0].
	^clip]

{ #category : #services }
GDIBitmap >> copyToClipboard [
	Clipboard clear; putBitmap: self]

{ #category : #private }
GDIBitmap >> createBitmap [
	self createBitmapFromBits: nil]

{ #category : #private }
GDIBitmap >> createBitmapFromBits: aByteArray [
	| class header bits struct init pointer |
	class := BITMAPINFOHEADER classForSize: info size.
	header := class external fromInfo: info.
	bits := aByteArray externalCopy.
	struct := info externalCopy.
	init := aByteArray isNil ifTrue: [0] ifFalse: [CBM_INIT].
	pointer := GDILibrary
		CreateDIBitmap: VirtualScreen current deviceContext asParameter
		lpbmih: header asParameter
		fdwInit: init
		lpbInit: bits asParameter
		lpbmi: struct asParameter
		fuUsage: DIB_RGB_COLORS.
	pointer = 0 ifTrue: [^self winError].
	header free.
	bits free.
	struct free.
	handle := pointer.
	self requireFinalization]

{ #category : #converting }
GDIBitmap >> darkGrayed [
	self apply: [:bmp | 
		bmp colorsReplace: [:color | | c |
			c := color red min: color blue min: color green.
			Color red: c green: c blue: c]]]

{ #category : #actions }
GDIBitmap >> deselect [
	dc isNil ifFalse: [dc deselectBitmap]]

{ #category : #accessing }
GDIBitmap >> deviceContext [
	^dc]

{ #category : #accessing }
GDIBitmap >> deviceContext: aDeviceContext [
	dc := aDeviceContext]

{ #category : #displaying }
GDIBitmap >> drawAt: aPoint on: aBitmap [
	aBitmap useValidDCWhile: [:context | self drawAt: aPoint using: context]]

{ #category : #displaying }
GDIBitmap >> drawAt: aPoint using: aDrawer [
	aDrawer notNil ifTrue: [aDrawer drawBitmap: self at: aPoint]]

{ #category : #converting }
GDIBitmap >> drawDisable [
	self apply: [:bmp | 
		self hasAlphaChannel
			ifTrue: [bmp applyTransparency: 85]
			ifFalse: [bmp colorsReplace: [:color | color blendWithButtonFace]]]]

{ #category : #accessing }
GDIBitmap >> drawer [
	dc isNil ifTrue: [dc := VirtualScreen current compatibleDC].
	dc selectBitmap: self.
	^GDIDrawer onBitmap: self]

{ #category : #services }
GDIBitmap >> drawerDo: aBlock [
	| new drawer |
	new := dc isNil orNot: [dc isAlive].
	new ifTrue: [dc := VirtualScreen current compatibleDC] ifFalse: [dc save].
	[
		dc selectBitmap: self.
		drawer := GDIDrawer onBitmap: self.
		aBlock evaluateWith: drawer]
		ensure: [
			new
				ifTrue: [
					dc delete.
					dc := nil]
				ifFalse: [dc restore].
			drawer invalidateDC]]

{ #category : #displaying }
GDIBitmap >> drawIn: aRectangle using: aDrawer [
	aDrawer notNil ifTrue: [aDrawer drawBitmap: self in: aRectangle]]

{ #category : #services }
GDIBitmap >> dumpOn: aStream [
	| bits header offset |
	bits := self getDIBits: true.
	bits isNil ifTrue: [^self].
	header := BITMAPFILEHEADER new.
	offset := header size + info contents size.
	header := header
		bfSize: offset + bits size;
		offBits: offset.
	aStream
		nextPutAll: header contents;
		putBytesFrom: info contents;
		putBytesFrom: bits]

{ #category : #accessing }
GDIBitmap >> extent [
	^info extent]

{ #category : #services }
GDIBitmap >> finalizationRegistry [
	^Smalltalk resourceRegistry]

{ #category : #services }
GDIBitmap >> finalize [
	self release]

{ #category : #testing }
GDIBitmap >> fitsIn: aRectangle [
	^self width <= aRectangle width and: [self height <= aRectangle height]]

{ #category : #services }
GDIBitmap >> flipHorizontally [
	self useValidDCWhile: [:context | context flipHorizontally: true]]

{ #category : #services }
GDIBitmap >> flipVertically [
	self useValidDCWhile: [:context | context flipHorizontally: false]]

{ #category : #accessing }
GDIBitmap >> forToolbar [
	^self asTransparentBitmap]

{ #category : #private }
GDIBitmap >> fromBitmap: aBitmap [
	info := BITMAPINFO
		width: aBitmap width
		height: aBitmap height
		bitCount: aBitmap bitCount.
	self createBitmapFromBits: aBitmap bits.
	self bitCount = 32 ifTrue: [self useAlphaChannel]]

{ #category : #private }
GDIBitmap >> fromFile: aString id: token [
	| library id success |
	aString notNil ifTrue: [
		library := self class libraryNamed: aString.
		library isNil ifTrue: [
			self winError.
			^nil]].
	id := token isString
		ifTrue: [token externalCopy]
		ifFalse: [token & 16rFFFF].
	handle := UserDLL current
		LoadBitmap: library asParameter
		lpBitmapName: id asParameter.
	handle = 0 ifTrue: [
		self winError.
		^nil].
	id == token ifFalse: [id free].
	success := KernelDLL current FreeLibrary: library.
	success ifFalse: [self winError].
	self requireFinalization; fromHandle: handle]

{ #category : #private }
GDIBitmap >> fromStream: aStream [
	| bits header |
	aStream size > BITMAPFILEHEADER sizeInBytes ifFalse: [
		self error: 'invalid bitmap format'.
		^nil].
	header := BITMAPFILEHEADER fromStream: aStream.
	header type = 'BM' ifFalse: [
		self error: 'Invalid bitmap type'.
		^nil].
	info := BITMAPINFO fromStream: aStream.
	bits := ByteArray new: self sizeInBytes.
	aStream getBytesFor: bits.
	self bitCount = 32 ifTrue: [self useAlphaChannel].
	self createBitmapFromBits: bits]

{ #category : #private }
GDIBitmap >> fromStruct: aBITMAP [
	info := BITMAPINFO
		width: aBITMAP width
		height: aBITMAP height
		bitCount: aBITMAP bitCount]

{ #category : #private }
GDIBitmap >> getDIBits [
	^self getDIBits: true]

{ #category : #private }
GDIBitmap >> getDIBits: bottomUp [
	| bits screen success struct |
	screen := DeviceContext forScreen.
	success := GDILibrary RealizePalette: screen asParameter.
	success = GDI_ERROR ifTrue: [
		self winError.
		^nil].
	struct := info externalCopy.
	success := GDILibrary
		GetDIBits: screen asParameter
		hbmp: self asParameter
		uStartScan: 0
		cScanLines: self height
		lpvBits: 0
		lpbi: struct asParameter
		uUsage: DIB_RGB_COLORS.
	success = 0 ifTrue: [
		self winError.
		^nil].
	bottomUp ifFalse: [struct height: struct height negated].
	bits := self sizeInBytes externalBytes.
	success := GDILibrary
		GetDIBits: screen asParameter
		hbmp: handle asParameter
		uStartScan: 0
		cScanLines: self height
		lpvBits: bits asParameter
		lpbi: struct asParameter
		uUsage: DIB_RGB_COLORS.
	success = 0 ifTrue: [
		self winError.
		^nil].
	struct free.
	screen release.
	^bits makeBytes]

{ #category : #testing }
GDIBitmap >> hasAlphaChannel [
	^alpha isNumber or: [alpha]]

{ #category : #accessing }
GDIBitmap >> height [
	^info height]

{ #category : #'file in/out' }
GDIBitmap >> imageSaved [
	handle isAssociation ifTrue: [handle := handle key]]

{ #category : #accessing }
GDIBitmap >> info: aBITMAPINFO [
	info := aBITMAPINFO.
	self bitCount = 32 ifTrue: [self useAlphaChannel]]

{ #category : #initialization }
GDIBitmap >> initialize [
	super initialize.
	alpha := false]

{ #category : #testing }
GDIBitmap >> isBitmap [
	^true]

{ #category : #testing }
GDIBitmap >> isImage [
	^true]

{ #category : #testing }
GDIBitmap >> isTransparentAt: aPoint [
	^self bitmap isTransparentAt: aPoint]

{ #category : #accessing }
GDIBitmap >> leftTopColor [
	^self colorAt: 0 @ 0]

{ #category : #converting }
GDIBitmap >> lightGrayed [
	self apply: [:bmp | 
		bmp colorsReplace: [:color | | c |
			c := (color red max: color blue) max: color green.
			Color red: c green: c blue: c]]]

{ #category : #accessing }
GDIBitmap >> luminanceAt: aPoint [
	| color |
	color := self colorAt: aPoint.
	^color luminance]

{ #category : #displaying }
GDIBitmap >> mergeWith: aBitmap [
	| bitmap |
	bitmap := aBitmap isString
		ifTrue: [Bitmap transparentNamed: aBitmap]
		ifFalse: [aBitmap].
	bitmap drawAt: 0 @ 0 on: self]

{ #category : #accessing }
GDIBitmap >> name [
	^name]

{ #category : #accessing }
GDIBitmap >> name: aString [
	name := aString]

{ #category : #copying }
GDIBitmap >> notForImageList [
	| n prefix |
	self ASSERT: VirtualScreen current bitsPerPixel = 32.
	n := self name.
	prefix := 'ImageList: '.
	(n beginsWith: prefix) ifTrue: [n := n copyFrom: prefix size + 1].
	^self class cacheAt: n ifAbsentPut: [self clone]]

{ #category : #accessing }
GDIBitmap >> opacity: aNumber [
	self apply: [:bmp | bmp opacity: aNumber].
	alpha := true]

{ #category : #copying }
GDIBitmap >> postCopy [
	handle := dc := nil.
	info := info copy]

{ #category : #printing }
GDIBitmap >> printOn: aStream [
	aStream nextPutAll: self class name.
	self name notNil ifTrue: [aStream space; nextPutAll: self name storeString].
	aStream
		space;
		nextPutAll: self width printString;
		nextPutAll: ' x ';
		nextPutAll: self height printString]

{ #category : #services }
GDIBitmap >> release [
	self isAlive ifFalse: [^self].
	dc notNil ifTrue: [dc deselectBitmap].
	(GDILibrary DeleteObject: handle) ifFalse: [self winNotification].
	self ignoreFinalization; releaseHandle]

{ #category : #finalization }
GDIBitmap >> releaseHandle [
	handle := dc := nil]

{ #category : #services }
GDIBitmap >> replaceColor: aColor with: anotherColor [
	self apply: [:bmp | 
		bmp
			colorsReplace: [:color | color = aColor
				ifTrue: [anotherColor]
				ifFalse: [color]]]]

{ #category : #services }
GDIBitmap >> resizedTo: extent [
	| clone |
	self extent = extent ifTrue: [^self].
	clone := self clone.
	self
		release;
		width: extent x height: extent y bitCount: self bitCount.
	self useValidDCWhile: [:context | 
		context
			copyBitmap: clone
			from: clone boundingRectangle
			to: self boundingRectangle].
	clone release]

{ #category : #services }
GDIBitmap >> saveAs: filename [
	| file |
	file := filename asFilename newFile beBinary.
	[self dumpOn: file] ensure: [file close]]

{ #category : #'startup/shutdown' }
GDIBitmap >> sessionShutdown [
	self release]

{ #category : #accessing }
GDIBitmap >> sizeInBytes [
	| size |
	size := info sizeImage.
	^size = 0 ifTrue: [info calculatedImageSize] ifFalse: [size]]

{ #category : #printing }
GDIBitmap >> storeOn: aStream [
	self bitmap storeOn: aStream alpha: self hasAlphaChannel]

{ #category : #'file in/out' }
GDIBitmap >> stub [
	^ObjectStub for: self bitmap selector: #asGDIBitmap]

{ #category : #accessing }
GDIBitmap >> transparentColor: aColor [
	self apply: [:bmp | bmp transparentColor: aColor].
	alpha := true]

{ #category : #accessing }
GDIBitmap >> transparentSample: aPoint [
	| color bmp |
	color := self colorAt: aPoint.
	self bitCount = 32 ifTrue: [
		self transparentColor: color.
		^self].
	bmp := GDIBitmap width: self width height: self height bitCount: 32.
	self useValidDCWhile: [:source | 
		bmp
			useValidDCWhile: [:target | target
				bitBltWith: source
				from: self boundingRectangle
				at: 0 @ 0]].
	bmp transparentColor: color; name: name.
	^bmp]

{ #category : #accessing }
GDIBitmap >> useAlphaChannel [
	alpha := true]

{ #category : #services }
GDIBitmap >> useDCCompatibleWith: aDeviceContext while: aBlock [
	| prev |
	prev := dc.
	prev notNil ifTrue: [self deselect].
	dc := aDeviceContext compatibleDC.
	dc selectBitmap: self.
	[aBlock evaluateWith: dc] ensure: [
		dc delete.
		dc := prev.
		prev notNil ifTrue: [prev selectBitmap: self]]]

{ #category : #accessing }
GDIBitmap >> usePrivateDC [
	dc := VirtualScreen current compatibleDC.
	dc selectBitmap: self]

{ #category : #testing }
GDIBitmap >> usesMemoryContext [
	^false]

{ #category : #services }
GDIBitmap >> useValidDCWhile: aBlock [
	| new prev |
	new := dc isNil orNot: [dc isAlive].
	new ifTrue: [dc := VirtualScreen current compatibleDC].
	prev := dc selectBitmap: self.
	self ASSERT: new | (prev = handle).
	^[aBlock evaluateWith: dc] ensure: [
		new ifTrue: [
			dc delete.
			dc := nil]]]

{ #category : #accessing }
GDIBitmap >> width [
	^info width]

{ #category : #accessing }
GDIBitmap >> width: w height: h bitCount: bits [
	info := BITMAPINFO width: w height: h bitCount: bits.
	self createBitmap]

{ #category : #enumerating }
GDIBitmap >> xyDo: aBlock [
	0
		to: self height - 1
		do: [:y | 0 to: self width - 1 do: [:x | aBlock value: x value: y]]]

