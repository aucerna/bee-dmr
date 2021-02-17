"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DeviceContext,
	#superclass : #GDIObject,
	#instVars : [
		'pen',
		'brush',
		'bitmap',
		'font',
		'regions'
	],
	#category : #GDI
}

{ #category : #'instance creation' }
DeviceContext class >> createDC: aString device: anotherString [
	| driver device hdc |
	driver := aString externalCopy.
	device := anotherString externalCopy.
	hdc := GDILibrary
		createDCW: driver asParameter
		deviceName: device asParameter.
	hdc = 0 ifTrue: [
		self winError.
		^nil].
	driver free.
	device free.
	^self fromInteger: hdc]

{ #category : #services }
DeviceContext class >> displayDevices [
	"
	DeviceContext displayDevices
	"
	| devices struct i |
	devices := OrderedCollection new.
	struct := DISPLAY_DEVICE external.
	i := 0.
	[
		UserDLL current
			EnumDisplayDevicesW: 0
			iDevNum: i
			lpDisplayDevice: struct asParameter
			dwFlags: 0]
		whileTrue: [
			devices add: struct localCopy.
			i := i + 1].
	struct free.
	^devices]

{ #category : #'instance creation' }
DeviceContext class >> forDisplay [
	"
	DeviceContext forDisplay
	"
	^self createDC: 'DISPLAY' device: nil]

{ #category : #'instance creation' }
DeviceContext class >> forInformationOn: aDEVNAMES [
	^self new forInformationOn: aDEVNAMES]

{ #category : #'instance creation' }
DeviceContext class >> forPrinterNamed: aString [
	^self createDC: nil device: aString]

{ #category : #'instance creation' }
DeviceContext class >> forScreen [
	"
	DeviceContext forScreen
	"
	| pointer |
	pointer := UserDLL current GetDC: 0.
	pointer = 0 ifTrue: [
		self winError.
		^nil].
	^CommonDeviceContext fromInteger: pointer]

{ #category : #private }
DeviceContext class >> forWindow: anExternalHandle [
	^self new forWindow: anExternalHandle]

{ #category : #services }
DeviceContext class >> primaryDisplayName [
	"
	DeviceContext primaryDisplayName
	"
	| primary |
	primary := self displayDevices detect: [:dev | dev isPrimary].
	^primary deviceName]

{ #category : #services }
DeviceContext class >> primaryDisplaySettings [
	"
	DeviceContext primaryDisplaySettings
	"
	| s |
	s := self primaryDisplayName externalCopy.
	^[| devmode success |
		devmode := DEVMODE external.
		success := UserDLL current
			EnumDisplaySettingsW: s asParameter
			iModeNum: ENUM_CURRENT_SETTINGS
			lpDevMode: devmode asParameter.
		success ifFalse: [^self winError].
		devmode makeLocal]
		ensure: [s free]]

{ #category : #private }
DeviceContext >> addRegion: aClipRegion [
	regions isNil ifTrue: [regions := OrderedCollection new].
	(regions isEmpty or: [regions last != aClipRegion])
		ifTrue: [regions add: aClipRegion]]

{ #category : #bitmaps }
DeviceContext >> alphaBlendBitmap: aGDIBitmap at: aPoint alpha: alpha [
	| rect |
	rect := aPoint extent: aGDIBitmap extent.
	self alphaBlendBitmap: aGDIBitmap in: rect alpha: alpha]

{ #category : #images }
DeviceContext >> alphaBlendBitmap: aGDIBitmap
from: sRectangle
to: dRectangle
alpha: alpha [
	| alphaFormat blendFlags rect |
	alphaFormat := AC_SRC_ALPHA.
	blendFlags := 0.
	rect := sRectangle intersect: aGDIBitmap boundingRectangle.
	aGDIBitmap useDCCompatibleWith: self while: [:context | | success |
		success := GDILibrary
			GdiAlphaBlend: handle asParameter
			xoriginDest: dRectangle left
			yoriginDest: dRectangle top
			wDest: dRectangle width
			hDest: dRectangle height
			hdcSrc: context asParameter
			xoriginSrc: rect left
			yoriginSrc: rect top
			wSrc: rect width
			hSrc: rect height
			ftn: alphaFormat * 256 + alpha * 256 + blendFlags * 256 + AC_SRC_OVER.
		success ifFalse: [self winError]]]

{ #category : #bitmaps }
DeviceContext >> alphaBlendBitmap: aGDIBitmap in: aRectangle alpha: alpha [
	self
		alphaBlendBitmap: aGDIBitmap
		from: (0 @ 0 extent: aGDIBitmap extent)
		to: aRectangle
		alpha: alpha]

{ #category : #accessing }
DeviceContext >> backColor: aColor [
	| previous |
	previous := GDILibrary SetBkColor: handle crColor: aColor asParameter.
	previous = CLR_INVALID ifTrue: [self winError]]

{ #category : #bitmaps }
DeviceContext >> bitBltAt: aPoint
width: srcWidth
height: srcHeight
from: srcDC
at: sourcePoint
rop: rop [
	| success |
	success := GDILibrary
		BitBlt: handle
		nXDest: aPoint x
		nYDest: aPoint y
		nWidth: srcWidth
		nHeight: srcHeight
		hdcSrc: srcDC asParameter
		nXSrc: sourcePoint x
		nYSrc: sourcePoint y
		dwRop: rop.
	success ifFalse: [^self winError]]

{ #category : #bitmaps }
DeviceContext >> bitBltWith: srcDC from: aRectangle at: aPoint [
	self
		bitBltWith: srcDC
		from: aRectangle
		at: aPoint
		rop: SRCCOPY]

{ #category : #bitmaps }
DeviceContext >> bitBltWith: srcDC
from: aRectangle
at: aPoint
rop: rop [
	self
		bitBltAt: aPoint
		width: aRectangle width
		height: aRectangle height
		from: srcDC
		at: aRectangle origin
		rop: rop]

{ #category : #dimensions }
DeviceContext >> bitsPerPixel [
	^GDILibrary GetDeviceCaps: handle index: BITSPIXEL]

{ #category : #accessing }
DeviceContext >> boundingRectangle [
	| struct success extent |
	struct := BITMAP external.
	success := GDILibrary
		GetObjectW: self currentBitmap asParameter
		cbBuffer: struct sizeInBytes
		lpvObject: struct asParameter.
	success = 0 ifTrue: [self winError].
	extent := struct width @ struct height.
	struct free.
	^0 @ 0 extent: extent]

{ #category : #callbacks }
DeviceContext >> brush: anExternalMemory lpData: long [
	| structure |
	structure := LOGBRUSH atMemory: anExternalMemory]

{ #category : #accessing }
DeviceContext >> brushColor [
	brush notNil ifTrue: [^brush color].
	^self currentBrush color]

{ #category : #accessing }
DeviceContext >> brushColor: aColor [
	| b |
	self brushColor asInteger = aColor asInteger ifTrue: [^self].
	b := GDIBrush withStyle: nil color: aColor hatch: nil.
	self selectBrush: b]

{ #category : #'clip regions' }
DeviceContext >> clipPreviousRegion [
	regions removeLast.
	regions isEmptyOrNil ifTrue: [^self].
	self clipRegion: regions last]

{ #category : #'clip regions' }
DeviceContext >> clipRegion: region [
	| success |
	success := GDILibrary SelectClipRgn: handle hrgn: region asParameter.
	success = 0 ifTrue: [self winNotification].
	region isNil
		ifTrue: [self clipPreviousRegion]
		ifFalse: [self addRegion: region]]

{ #category : #'clip regions' }
DeviceContext >> combineRegion: region1 with: region2 mode: fnCombineMode [
	| t |
	t := GDILibrary
		CombineRgn: region2 asParameter
		hrgnSrc1: region1 asParameter
		hrgnSrc2: region2 asParameter
		fnCombineMode: fnCombineMode.
	t = 0 ifTrue: [^self winError].
	^region2]

{ #category : #private }
DeviceContext >> compatibleDC [
	| pointer |
	pointer := GDILibrary CreateCompatibleDC: self asParameter.
	pointer = 0 ifTrue: [^self winError].
	^(DeviceContext fromInteger: pointer) requireFinalization; yourself]

{ #category : #bitmaps }
DeviceContext >> copyBitmap: aBitmap from: aRectangle at: aPoint [
	^self
		copyBitmap: aBitmap
		from: aRectangle
		at: aPoint
		rule: SRCCOPY]

{ #category : #bitmaps }
DeviceContext >> copyBitmap: aBitmap
from: aRectangle
at: aPoint
rule: rop [
	aBitmap useValidDCWhile: [:dc | 
		self
			bitBltAt: aPoint
			width: aRectangle width
			height: aRectangle height
			from: dc asParameter
			at: aRectangle origin
			rop: rop]]

{ #category : #pen }
DeviceContext >> copyBitmap: aBitmap from: aRectangle to: anotherRectangle [
	^self
		copyBitmap: aBitmap
		from: aRectangle
		to: anotherRectangle
		rule: SRCCOPY]

{ #category : #bitmaps }
DeviceContext >> copyBitmap: aBitmap
from: sourceRectangle
to: targetRectangle
rule: rop [
	aBitmap
		useValidDCWhile: [:dc | self
			stretchBltWith: dc
			from: sourceRectangle
			to: targetRectangle
			rule: rop]]

{ #category : #bitmaps }
DeviceContext >> createCompatibleBitmapExtent: aPoint [
	| bmp |
	bmp := GDILibrary
		CreateCompatibleBitmap: self asParameter
		nWidth: aPoint x
		nHeight: aPoint y.
	^GDIBitmap fromHandle: bmp]

{ #category : #services }
DeviceContext >> createCompatibleDCWhile: aBlock [
	| ulong compatible |
	ulong := GDIDLL current CreateCompatibleDC: self asParameter.
	ulong = 0 ifTrue: [^self winError].
	compatible := self class fromInteger: ulong.
	^[aBlock evaluateWith: compatible] ensure: [| return |
		return := GDIDLL current DeleteDC: ulong.
		return = 0 ifTrue: [self winError]]]

{ #category : #'clip regions' }
DeviceContext >> createEllipticRegion: aRectangle [
	| region |
	region := GDILibrary
		CreateEllipticRgn: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom.
	region = 0 ifTrue: [^self winError].
	^region]

{ #category : #'clip regions' }
DeviceContext >> createIntersectionRegion: aRectangle [
	| type |
	type := GDILibrary
		IntersectClipRect: handle
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom.
	type = 0 ifTrue: [^self winError].
	^type]

{ #category : #'clip regions' }
DeviceContext >> createPolygonRegion: points [
	| n buffer region |
	n := points size.
	buffer := BufferArray externalOn: points type: POINT.
	region := GDILibrary
		CreatePolygonRgn: buffer asParameter
		cPoints: n
		mode: WINDING.
	region = 0 ifTrue: [^self winError].
	buffer free.
	^region]

{ #category : #'clip regions' }
DeviceContext >> createRegion: aRectangle [
	| pointer |
	pointer := GDILibrary
		CreateRectRgn: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom.
	pointer = 0 ifTrue: [^self winError].
	^pointer]

{ #category : #private }
DeviceContext >> currentBitmap [
	| token |
	token := self currentObject: OBJ_BITMAP.
	(bitmap notNil and: [bitmap handle = token]) ifTrue: [^bitmap].
	^bitmap := GDIBitmap fromHandle: token]

{ #category : #private }
DeviceContext >> currentBrush [
	| pointer |
	pointer := self currentObject: OBJ_BRUSH.
	(brush isNil or: [brush handle != pointer])
		ifTrue: [
			brush := pointer isNil
				ifTrue: [GDIBrush default]
				ifFalse: [GDIBrush fromHandle: pointer]]
		ifFalse: [brush fromHandle: pointer].
	^brush]

{ #category : #accessing }
DeviceContext >> currentClipBox [
	| clipbox success |
	clipbox := RECT external.
	success := GDILibrary GetClipBox: handle lprc: clipbox asParameter.
	success = 0 ifTrue: [^self winError].
	success = 1 ifTrue: [^nil].
	^clipbox makeLocal asRectangle]

{ #category : #accessing }
DeviceContext >> currentClipRegion [
	| region success |
	region := self createRegion: (0 @ 0 extent: 1).
	success := GDILibrary GetClipRgn: handle hrgn: region asParameter.
	success = -1 ifTrue: [^self winNotification].
	success = 0 ifTrue: [^nil].
	^region]

{ #category : #accessing }
DeviceContext >> currentClipRegionBox [
	| clipbox success |
	clipbox := RECT external.
	success := GDILibrary
		GetRgnBox: self currentClipRegion asParameter
		lprc: clipbox asParameter.
	success = 0 ifTrue: [^self winError].
	^clipbox makeLocal asRectangle]

{ #category : #private }
DeviceContext >> currentColorSpace [
	^self currentObject: OBJ_COLORSPACE]

{ #category : #private }
DeviceContext >> currentFont [
	| metrics y n |
	metrics := self textMetric.
	y := GDILibrary GetDeviceCaps: handle index: LOGPIXELSY.
	n := metrics height - metrics internalLeading * 72 / y.
	^self getCurrentFont
		pointSize: n rounded dc: self;
		metrics: metrics]

{ #category : #private }
DeviceContext >> currentObject: anInteger [
	| token |
	token := GDILibrary GetCurrentObject: handle uObjectType: anInteger.
	token = 0 ifTrue: [
		self winError.
		^nil].
	^token]

{ #category : #private }
DeviceContext >> currentPalette [
	| ulong |
	ulong := self currentObject: OBJ_PAL.
	^GDIPalette fromInteger: ulong]

{ #category : #private }
DeviceContext >> currentPen [
	| pointer |
	pointer := self currentObject: OBJ_PEN.
	(pen isNil or: [pen handle != pointer])
		ifTrue: [pen := GDIPen fromHandle: (self currentObject: OBJ_PEN)]
		ifFalse: [pen fromHandle: pointer].
	^pen]

{ #category : #removing }
DeviceContext >> delete [
	| success pointer |
	(bitmap notNil and: [bitmap deviceContext == self])
		ifTrue: [bitmap deviceContext: nil].
	handle isNil ifTrue: [^self].
	self
		selectObject: GDIPen default;
		selectObject: GDIBrush default;
		selectObject: GDIFont default;
		selectObject: GDIBitmap defaultBitmap.
	pointer := handle.
	pen := brush := bitmap := handle := nil.
	success := GDILibrary DeleteDC: pointer.
	success ifFalse: [
		handle := pointer.
		self winError].
	self ignoreFinalization]

{ #category : #removing }
DeviceContext >> delete: aGDIObject [
	| success |
	success := GDILibrary DeleteObject: aGDIObject asParameter.
	success ifFalse: [self winError]]

{ #category : #services }
DeviceContext >> deleteObject: anObject [
	anObject isNil ifTrue: [^self].
	(GDILibrary DeleteObject: anObject asParameter) ifFalse: [^self winError]]

{ #category : #removing }
DeviceContext >> deselectBitmap [
	bitmap notNil ifTrue: [
		bitmap deviceContext: nil.
		bitmap := nil].
	self selectObject: GDIBitmap defaultBitmap]

{ #category : #'clip regions' }
DeviceContext >> destroyRegion: hRegion [
	self clipRegion: nil; deleteObject: hRegion]

{ #category : #dimensions }
DeviceContext >> dpToLp: aPoint [
	| wp success |
	wp := POINT external fromPoint: aPoint.
	success := GDILibrary
		DpToLp: handle asParameter
		lpPoints: wp asParameter
		nCount: 1.
	success ifFalse: [^self winError].
	^wp makeLocal asPoint]

{ #category : #bitmaps }
DeviceContext >> draw: aRectangle ofBitmap: aGDIBitmap at: aPoint [
	| rect |
	aGDIBitmap hasAlphaChannel
		ifTrue: [
			rect := aPoint extent: aRectangle extent.
			self
				alphaBlendBitmap: aGDIBitmap
				from: aRectangle
				to: rect
				alpha: aGDIBitmap alphaConstant]
		ifFalse: [self copyBitmap: aGDIBitmap from: aRectangle at: aPoint]]

{ #category : #pen }
DeviceContext >> drawArc: radius
center: center
startAngle: startAngle
sweepAngle: sweepAngle [
	| success |
	success := GDILibrary
		AngleArc: handle
		X: center x
		Y: center y
		dwRadius: radius
		eStartAngle: startAngle
		eSweepAngle: sweepAngle.
	success ifFalse: [self winNotification]]

{ #category : #pen }
DeviceContext >> drawArc: aRectangle start: startPoint end: endPoint [
	| success |
	success := GDILibrary
		Arc: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom
		nXStartArc: startPoint x
		nYStartArc: startPoint y
		nXEndArc: endPoint x
		nYEndArc: endPoint y.
	success ifFalse: [self winNotification]]

{ #category : #bitmaps }
DeviceContext >> drawBitmap: aBitmap at: aPoint [
	aBitmap hasAlphaChannel
		ifTrue: [self
			alphaBlendBitmap: aBitmap
			at: aPoint
			alpha: aBitmap alphaConstant]
		ifFalse: [self
			copyBitmap: aBitmap
			from: aBitmap boundingRectangle
			at: aPoint]]

{ #category : #pen }
DeviceContext >> drawEllipse: aRectangle [
	| success |
	success := GDILibrary
		Ellipse: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom.
	success ifFalse: [self winNotification]]

{ #category : #bitmaps }
DeviceContext >> drawEnhMetaFile: aEnhMetaFile in: aRectangle [
	| r |
	aEnhMetaFile handle isNil ifTrue: [^self].
	r := RECT external from: aRectangle.
	[| success |
		success := GDILibrary
			PlayEnhMetaFile: self asParameter
			hemf: aEnhMetaFile handle asParameter
			lpRect: r asParameter.
		success ifFalse: [self winNotification]]
		ensure: [r free]]

{ #category : #services }
DeviceContext >> drawFocusRectangle: aRectangle [
	| box success |
	box := RECT external from: aRectangle.
	success := UserDLL current DrawFocusRect: handle lprc: box asParameter.
	success ifFalse: [self winError].
	box free]

{ #category : #images }
DeviceContext >> drawIcon: anIcon at: aPoint [
	| success |
	success := UserDLL current
		DrawIcon: self asParameter
		X: aPoint x
		Y: aPoint y
		hIcon: anIcon handle asParameter.
	success ifFalse: [self winNotification]]

{ #category : #images }
DeviceContext >> drawIcon: anIcon in: aRectangle [
	| success |
	success := UserDLL current
		DrawIconEx: self asParameter
		xLeft: aRectangle left
		yTop: aRectangle top
		hIcon: anIcon handle asParameter
		cxWidth: aRectangle width
		cyWidth: aRectangle height
		istepIfAniCur: 0
		hbrFlickerFreeDraw: 0
		diFlags: DI_NORMAL.
	success ifFalse: [self winNotification]]

{ #category : #pen }
DeviceContext >> drawLineFrom: p1 to: p2 [
	| success |
	success := GDILibrary moveToEx: handle location: p1.
	success ifFalse: [^self winError].
	success := GDILibrary LineTo: handle nXEnd: p2 x nYEnd: p2 y.
	success ifFalse: [^self winError]]

{ #category : #pen }
DeviceContext >> drawLineTo: aPoint [
	| success |
	success := GDILibrary LineTo: handle nXEnd: aPoint x nYEnd: aPoint y.
	success ifFalse: [^self winError]]

{ #category : #errors }
DeviceContext >> drawPie: aRectangle start: startPoint end: endPoint [
	| success |
	success := GDILibrary
		Pie: self asParameter
		left: aRectangle left
		top: aRectangle top
		right: aRectangle right
		bottom: aRectangle bottom
		xr1: startPoint x
		yr1: startPoint y
		xr2: endPoint x
		yr2: endPoint y.
	success ifFalse: [self winNotification]]

{ #category : #pen }
DeviceContext >> drawPolygon: points [
	| buffer n success |
	buffer := BufferArray externalOn: points type: POINT.
	n := points size.
	success := GDILibrary
		Polygon: handle
		lpPoints: buffer asParameter
		nCount: n.
	success ifFalse: [self winNotification].
	buffer free]

{ #category : #pen }
DeviceContext >> drawPolyline: points [
	| buffer n success |
	buffer := BufferArray externalOn: points type: POINT.
	n := points size.
	success := GDIDLL current
		Polyline: handle
		lppt: buffer asParameter
		cPoints: n.
	success ifFalse: [self winNotification].
	buffer free]

{ #category : #pen }
DeviceContext >> drawRectangle: aRectangle [
	| success |
	success := GDILibrary
		Rectangle: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom.
	success ifFalse: [^self winError]]

{ #category : #pen }
DeviceContext >> drawRoundRectangle: aRectangle corner: aPoint [
	| success |
	success := GDILibrary
		RoundRect: self asParameter
		nLeftRect: aRectangle left
		nTopRect: aRectangle top
		nRightRect: aRectangle right
		nBottomRect: aRectangle bottom
		nWidth: aPoint x
		nHeight: aPoint y.
	success ifFalse: [^self winError]]

{ #category : #text }
DeviceContext >> drawText: aString in: aRectangle format: f [
	| utf characters rect offset |
	aString isEmptyOrNil ifTrue: [^self].
	utf := aString externalCopy.
	characters := aString size.
	rect := RECT external from: aRectangle.
	offset := UserDLL current
		DrawTextW: handle
		lpchText: utf asParameter
		nCount: characters
		lpRect: rect asParameter
		uFormat: f asParameter.
	offset = 0 ifTrue: [self winError].
	utf free.
	rect free]

{ #category : #bitmaps }
DeviceContext >> drawWinMetaFile: metafile in: aRectangle [
	| mode position origin extent |
	metafile handle isNil ifTrue: [^self].
	mode := self mapMode.
	position := self windowOrigin.
	origin := self viewportOrigin.
	extent := self viewportExtent.
	self
		mapMode: MM_ANISOTROPIC;
		windowOrigin: 0 @ 0;
		viewportOrigin: aRectangle origin;
		viewportExtent: aRectangle extent;
		setTextAlign: TA_NOUPDATECP.
	[| success |
		success := GDILibrary
			PlayMetaFile: self asParameter
			with: metafile handle asParameter.
		success ifFalse: [self winNotification]]
		ensure: [
			self
				mapMode: mode;
				windowOrigin: position;
				viewportOrigin: origin;
				viewportExtent: extent]]

{ #category : #enumerating }
DeviceContext >> enumBrushes [
	self
		evaluate: [:callback | 
			GDILibrary
				EnumObjects: handle
				nObjectType: OBJ_BRUSH
				lpObjectFunc: callback asParameter
				lParam: nil]
		callback: #brush:lpData:]

{ #category : #enumerating }
DeviceContext >> enumPens [
	self
		evaluate: [:callback | 
			GDILibrary
				EnumObjects: handle
				nObjectType: OBJ_PEN
				lpObjectFunc: callback asParameter
				lParam: nil]
		callback: #pen:lpData:]

{ #category : #pen }
DeviceContext >> fillRectangle: aRectangle [
	| success r |
	r := RECT external from: aRectangle.
	success := UserDLL current
		FillRect: handle
		lprc: r asParameter
		hbr: brush asParameter.
	success ifFalse: [^self winError]]

{ #category : #finalization }
DeviceContext >> finalize [
	handle notNil ifTrue: [self delete]]

{ #category : #copying }
DeviceContext >> flip: aGDIBitmap horizontally: isHorizontal [
	aGDIBitmap
		useValidDCWhile: [:dc | self
			flip: aGDIBitmap boundingRectangle
			of: dc
			horizontally: isHorizontal]]

{ #category : #copying }
DeviceContext >> flip: aRectangle of: aDeviceContext horizontally: isHorizontal [
	| x y w h |
	isHorizontal
		ifTrue: [
			x := aRectangle width - 1.
			y := aRectangle top.
			w := aRectangle width negated.
			h := aRectangle height]
		ifFalse: [
			x := aRectangle left.
			y := aRectangle height - 1.
			w := aRectangle width.
			h := aRectangle height negated].
	self
		stretchBltWith: aDeviceContext
		from: aRectangle
		to: (x @ y extent: w @ h)
		rule: SRCCOPY]

{ #category : #copying }
DeviceContext >> flipHorizontally: isHorizontal [
	self flip: self boundingRectangle of: self horizontally: isHorizontal]

{ #category : #accessing }
DeviceContext >> foreColor [
	| color |
	color := GDILibrary GetDCPenColor: handle.
	^RGBColor fromInteger: color]

{ #category : #private }
DeviceContext >> forInformationOn: aDEVNAMES [
	| driver device pointer |
	driver := aDEVNAMES driver externalCopy.
	device := aDEVNAMES device externalCopy.
	pointer := GDILibrary
		CreateICW: driver asParameter
		lpszDevice: device asParameter
		lpszOutput: 0
		lpdvmInit: 0.
	pointer = 0 ifTrue: [^self winError].
	driver free.
	device free.
	handle := pointer]

{ #category : #private }
DeviceContext >> forWindow: aWindow [
	handle := aWindow getDC]

{ #category : #private }
DeviceContext >> getCurrentFont [
	| ulong struct return |
	ulong := self currentObject: OBJ_FONT.
	struct := LOGFONT external.
	return := GDILibrary
		GetObjectW: ulong
		cbBuffer: struct sizeInBytes
		lpvObject: struct asParameter.
	return = 0 ifTrue: [self winError].
	^GDIFont logicalFont: struct makeLocal handle: ulong asExternalHandle]

{ #category : #bitmaps }
DeviceContext >> getPixelAt: aPoint [
	^GDILibrary GetPixel: handle x: aPoint x y: aPoint y]

{ #category : #services }
DeviceContext >> getROP2 [
	| mode |
	mode := GDILibrary GetROP2: handle.
	mode = 0 ifTrue: [^self winError].
	^mode]

{ #category : #text }
DeviceContext >> getTextAlign [
	| align |
	align := GDILibrary GetTextAlign: handle.
	align = GDI_ERROR ifTrue: [self winError].
	^align]

{ #category : #accessing }
DeviceContext >> horizontalInchSize [
	^self horizontalSize * 10.0 / 254.0]

{ #category : #dimensions }
DeviceContext >> horizontalPixelsPerInch [
	^GDILibrary GetDeviceCaps: handle index: LOGPIXELSX]

{ #category : #dimensions }
DeviceContext >> horizontalResolution [
	^GDILibrary GetDeviceCaps: handle index: HORZRES]

{ #category : #dimensions }
DeviceContext >> horizontalSize [
	| return |
	return := GDILibrary GetDeviceCaps: handle index: HORZSIZE.
	return = 0 ifTrue: [self winError].
	^return]

{ #category : #dimensions }
DeviceContext >> inchSize [
	^self horizontalInchSize @ self verticalInchSize]

{ #category : #bitmaps }
DeviceContext >> invertColorsIn: aRectangle [
	^self patternFill: aRectangle rule: DSTINVERT]

{ #category : #services }
DeviceContext >> logicalFromPoint: pointSize [
	| pixel |
	pixel := self pixelFromPoint: pointSize.
	^(self dpToLp: 0 @ pixel) - (self dpToLp: 0 @ 0)]

{ #category : #dimensions }
DeviceContext >> logicalRectFrom: aRectangle [
	| points |
	points := {aRectangle origin. aRectangle corner}.
	points := GDIDLL current dpToLp: handle points: points.
	^Rectangle origin: points first corner: points last]

{ #category : #dimensions }
DeviceContext >> lpToDp: aPoint [
	| wp success |
	wp := POINT external fromPoint: aPoint.
	success := GDILibrary
		LpToDp: handle asParameter
		lpPoints: wp asParameter
		nCount: 1.
	success ifFalse: [self winError].
	^wp makeLocal asPoint]

{ #category : #windows }
DeviceContext >> mapMode [
	| mode |
	mode := GDILibrary GetMapMode: self handle.
	mode = 0 ifTrue: [^self winError].
	^mode]

{ #category : #windows }
DeviceContext >> mapMode: anInteger [
	| success |
	success := GDILibrary SetMapMode: handle fnMapMode: anInteger.
	success = 0 ifTrue: [^self winError]]

{ #category : #pen }
DeviceContext >> moveTo: aPoint [
	| success |
	success := GDILibrary moveToEx: handle location: aPoint.
	success ifFalse: [^self winError]]

{ #category : #text }
DeviceContext >> outputText: aString at: aPoint [
	| memory success |
	memory := aString externalCopy.
	success := GDILibrary
		TextOutW: self asParameter
		nXStart: aPoint x
		nYStart: aPoint y
		lpString: memory asParameter
		cchString: memory length // 2 - 1.
	success ifFalse: [^self winError].
	memory free]

{ #category : #bitmaps }
DeviceContext >> patternFill: aRectangle rule: rop [
	| success |
	success := GDILibrary
		PatBlt: handle
		x: aRectangle origin x
		y: aRectangle origin y
		w: aRectangle width
		h: aRectangle height
		rop: rop.
	success ifFalse: [^self winNotification]]

{ #category : #callbacks }
DeviceContext >> pen: anExternalMemory lpData: long [
	| structure |
	structure := LOGPEN atMemory: anExternalMemory.
	self doSomethingWith: structure]

{ #category : #services }
DeviceContext >> pixelFromPoint: pointSize [
	| pixel |
	pixel := GDILibrary GetDeviceCaps: self asParameter index: LOGPIXELSY.
	^(pointSize / 72 * pixel) rounded]

{ #category : #services }
DeviceContext >> pixelsPerInch [
	^self horizontalResolution / self horizontalInchSize
		@ (self verticalResolution / self verticalInchSize)]

{ #category : #dimensions }
DeviceContext >> pixelsPerMillimeter [
	^self horizontalResolution / self horizontalSize
		@ (self verticalResolution / self verticalSize)]

{ #category : #dimensions }
DeviceContext >> planes [
	^GDILibrary GetDeviceCaps: handle index: PLANES]

{ #category : #services }
DeviceContext >> playEnhMetaFile: aEnhMetaFile in: aRectangle [
	| rect |
	rect := RECT external from: aRectangle.
	[| success |
		success := GDILibrary
			PlayEnhMetaFile: handle asParameter
			hemf: aEnhMetaFile handle asParameter
			lpRect: rect asParameter.
		success ifFalse: [self lastWinError]]
		ensure: [rect free]]

{ #category : #services }
DeviceContext >> playMetaFile: metafile [
	(GDILibrary PlayMetaFile: handle with: metafile handle)
		ifFalse: [self winNotification]]

{ #category : #services }
DeviceContext >> pointFromPixel: pixelSize [
	| pixel |
	pixel := GDILibrary GetDeviceCaps: self asParameter index: LOGPIXELSY.
	^(pixelSize * 72 / pixel) rounded]

{ #category : #services }
DeviceContext >> realizePalette [
	| return |
	return := GDIDLL current RealizePalette: self asParameter.
	return = GDI_ERROR ifTrue: [self winError]]

{ #category : #dimensions }
DeviceContext >> rectFromLogical: aRectangle [
	| points |
	points := {aRectangle origin. aRectangle corner}.
	points := GDIDLL current lpToDp: handle points: points.
	^Rectangle origin: points first corner: points last]

{ #category : #finalization }
DeviceContext >> release [
	]

{ #category : #finalization }
DeviceContext >> releaseHandle [
	handle := nil]

{ #category : #'saving/restoring' }
DeviceContext >> restore [
	| success |
	success := GDILibrary RestoreDC: handle nSavedDC: -1.
	success ifFalse: [^self winError].
	brush := GDIBrush fromHandle: (self currentObject: OBJ_BRUSH).
	pen := GDIPen fromHandle: (self currentObject: OBJ_PEN).
	font := GDIFont fromHandle: (self currentObject: OBJ_FONT)]

{ #category : #'saving/restoring' }
DeviceContext >> save [
	| success |
	success := GDILibrary SaveDC: handle.
	success = 0 ifTrue: [^self winError]]

{ #category : #services }
DeviceContext >> saveWhile: aBlock [
	self save.
	aBlock ensure: [self restore]]

{ #category : #services }
DeviceContext >> selectBitmap: aGDIBitmap [
	(bitmap notNil
		and: [bitmap deviceContext == self]
		and: [bitmap !== aGDIBitmap])
		ifTrue: [bitmap deviceContext: nil].
	bitmap := aGDIBitmap.
	bitmap deviceContext: self.
	^self selectObject: bitmap]

{ #category : #private }
DeviceContext >> selectBrush: aGDIBrush [
	| previous |
	brush == aGDIBrush ifTrue: [^brush].
	previous := brush.
	self selectObject: aGDIBrush.
	brush := aGDIBrush.
	self ASSERT: (self currentObject: OBJ_BRUSH) = brush handle.
	^previous]

{ #category : #services }
DeviceContext >> selectFont: aGDIFont [
	self selectObject: aGDIFont.
	font := aGDIFont]

{ #category : #private }
DeviceContext >> selectObject: anObject [
	| previous |
	previous := GDIDLL current
		SelectObject: handle
		hgdiobj: anObject asParameter.
	previous = 0 ifTrue: [self winNotification].
	^previous]

{ #category : #services }
DeviceContext >> selectObject: anObject while: aBlock [
	^GDIDLL current selectObject: anObject into: self while: aBlock]

{ #category : #services }
DeviceContext >> selectPalette: palette [
	| return |
	return := GDIDLL current
		selectPalette: palette asParameter
		into: self asParameter.
	return = 0 ifTrue: [self winError]]

{ #category : #services }
DeviceContext >> selectPen: aGDIPen [
	self selectObject: aGDIPen.
	pen := aGDIPen]

{ #category : #accessing }
DeviceContext >> selectStockBrush: brushID [
	| b |
	b := GDIBrush stockObject: brushID.
	^self selectBrush: b]

{ #category : #accessing }
DeviceContext >> selectStockPen: penID [
	pen := GDIPen stockObject: penID.
	^self selectObject: pen]

{ #category : #windows }
DeviceContext >> setAnisotropicMapMode [
	self mapMode = MM_ANISOTROPIC ifFalse: [self mapMode: MM_ANISOTROPIC]]

{ #category : #services }
DeviceContext >> setBackgroundModeTransparent [
	self setBackMode: TRANSPARENT]

{ #category : #accessing }
DeviceContext >> setBackMode: anInteger [
	| success |
	success := GDILibrary SetBkMode: handle iBkMode: anInteger.
	success = 0 ifTrue: [^self winNotification]]

{ #category : #'clip regions' }
DeviceContext >> setClipElliptic: aRectangle [
	| region |
	aRectangle isNil ifTrue: [^self clipRegion: nil].
	region := self createEllipticRegion: aRectangle.
	self clipRegion: region.
	^region]

{ #category : #'clip regions' }
DeviceContext >> setClipPolygon: points [
	| region |
	region := self createPolygonRegion: points.
	self clipRegion: region.
	^region]

{ #category : #'clip regions' }
DeviceContext >> setClipRect: aRectangle [
	| region |
	aRectangle isNil ifTrue: [^self clipRegion: nil].
	region := self createRegion: aRectangle.
	regions isEmptyOrNil
		ifFalse: [self combineRegion: regions last with: region mode: RGN_AND].
	self clipRegion: region.
	^region]

{ #category : #bitmaps }
DeviceContext >> setPixel: aPoint color: aColor [
	GDILibrary
		SetPixelV: self handle
		X: aPoint x
		Y: aPoint y
		crColor: aColor asParameter]

{ #category : #services }
DeviceContext >> setRop2: anInteger [
	| success |
	success := GDILibrary SetROP2: handle fnDrawMode: anInteger.
	success = 0 ifTrue: [^self winError]]

{ #category : #text }
DeviceContext >> setTextAlign: flags [
	| success |
	success := GDILibrary SetTextAlign: handle align: flags.
	success = GDI_ERROR ifTrue: [self winNotification]]

{ #category : #services }
DeviceContext >> setXORWhile: aBlock [
	| mode |
	mode := self getROP2.
	self setRop2: R2_NOTXORPEN.
	aBlock ensure: [self setRop2: mode]]

{ #category : #bitmaps }
DeviceContext >> stretchBltWith: sourceDeviceContext
from: sourceRectangle
to: targetRectangle
rule: rop [
	| success |
	success := GDILibrary
		StretchBlt: handle
		nXOriginDest: targetRectangle left
		nYOriginDest: targetRectangle top
		nWidthDest: targetRectangle signedWidth
		nHeightDest: targetRectangle signedHeight
		hdcSrc: sourceDeviceContext asParameter
		nXOriginSrc: sourceRectangle left
		nYOriginSrc: sourceRectangle top
		nWidthSrc: sourceRectangle signedWidth
		nHeightSrc: sourceRectangle signedHeight
		dwRop: rop.
	success ifFalse: [^self winError].
	^success]

{ #category : #accessing }
DeviceContext >> textColor: aColor [
	| previous |
	previous := GDILibrary
		SetTextColor: self asParameter
		color: aColor asParameter.
	previous = CLR_INVALID ifTrue: [self winError]]

{ #category : #private }
DeviceContext >> textMetric [
	| metrics success |
	metrics := TEXTMETRIC external.
	success := GDILibrary GetTextMetricsW: handle lptm: metrics asParameter.
	success ifFalse: [self winError].
	^metrics makeLocal]

{ #category : #services }
DeviceContext >> transparentBackgroundWhile: aBlock [
	| prev |
	prev := GDILibrary GetBkMode: handle.
	prev = 0 ifTrue: [self winError].
	prev = TRANSPARENT ifTrue: [^aBlock value].
	self setBackMode: TRANSPARENT.
	aBlock ensure: [self setBackMode: prev]]

{ #category : #accessing }
DeviceContext >> verticalInchSize [
	^self verticalSize * 10.0 / 254.0]

{ #category : #dimensions }
DeviceContext >> verticalPixelsPerInch [
	^GDILibrary GetDeviceCaps: handle index: LOGPIXELSY]

{ #category : #dimensions }
DeviceContext >> verticalResolution [
	^GDILibrary GetDeviceCaps: handle index: VERTRES]

{ #category : #dimensions }
DeviceContext >> verticalSize [
	^GDILibrary GetDeviceCaps: handle index: VERTSIZE]

{ #category : #windows }
DeviceContext >> viewportExtent [
	| struct success |
	struct := SIZE external.
	success := GDILibrary
		GetViewportExtEx: self handle
		extent: struct asParameter.
	success ifFalse: [self winError].
	^struct makeLocal asPoint]

{ #category : #windows }
DeviceContext >> viewportExtent: aPoint [
	| success |
	success := GDILibrary
		SetViewportExtEx: handle
		nXExtent: aPoint x
		nYExtent: aPoint y
		lpSize: 0.
	success ifFalse: [^self winError]]

{ #category : #windows }
DeviceContext >> viewportOrgin: aPoint [
	| success |
	success := GDILibrary
		OffsetViewportOrgEx: pen handle
		nXOffset: aPoint x
		nYOffset: aPoint y
		lpPoint: nil.
	success ifFalse: [^self winError]]

{ #category : #accessing }
DeviceContext >> viewportOrigin [
	| struct success |
	struct := POINT external.
	success := GDILibrary
		GetViewportOrgEx: self handle
		lpPoint: struct asParameter.
	success ifFalse: [self winError].
	^struct makeLocal asPoint]

{ #category : #services }
DeviceContext >> viewportOrigin: aPoint [
	| success |
	success := GDILibrary
		SetViewportOrgEx: handle
		X: aPoint x
		Y: aPoint y
		lpPoint: 0.
	success ifFalse: [^self winError]]

{ #category : #text }
DeviceContext >> widthOfString: aString [
	| memory struct success |
	memory := aString externalCopy.
	struct := POINT external.
	success := GDILibrary
		GetTextExtentPoint32W: handle
		lpString: memory asParameter
		c: aString size
		lpSize: struct asParameter.
	success ifFalse: [self winError].
	memory free.
	^struct makeLocal x]

{ #category : #windows }
DeviceContext >> windowExtent [
	| success origin |
	origin := POINT external.
	success := GDILibrary
		GetWindowExtEx: self handle
		lpSize: origin asParameter.
	success ifFalse: [self winError].
	^origin makeLocal asPoint]

{ #category : #windows }
DeviceContext >> windowExtent: aPoint [
	| success |
	success := GDILibrary
		SetWindowExtEx: handle
		nXExtent: aPoint x
		nYExtent: aPoint y
		lpSize: 0.
	success ifFalse: [^self winError]]

{ #category : #accessing }
DeviceContext >> windowHandle [
	^UserDLL current WindowFromDC: handle]

{ #category : #windows }
DeviceContext >> windowOrigin [
	| success origin |
	origin := POINT external.
	success := GDILibrary
		GetWindowOrgEx: self handle
		lpPoint: origin asParameter.
	success ifFalse: [self winError].
	^origin makeLocal asPoint]

{ #category : #windows }
DeviceContext >> windowOrigin: aPoint [
	| success |
	success := GDILibrary setWindowOrgEx: handle point: aPoint.
	success ifFalse: [^self winError]]

{ #category : #errors }
DeviceContext >> winError: anInteger [
	((anInteger = 6 or: [anInteger = 5]) and: [SmalltalkSession current isLocked])
		ifTrue: [^self].
	super winError: anInteger]

{ #category : #private }
DeviceContext >> winStyleFor: lineStyle [
	lineStyle == #solid ifTrue: [^PS_SOLID].
	lineStyle == #dash ifTrue: [^PS_DASH].
	lineStyle == #dot ifTrue: [^PS_DOT].
	lineStyle == #dashdot ifTrue: [^PS_DASHDOT].
	lineStyle == #dashdotdot ifTrue: [^PS_DASHDOTDOT].
	lineStyle == #inside ifTrue: [^PS_INSIDEFRAME].
	self ASSERT: false]

