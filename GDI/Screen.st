"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Screen,
	#superclass : #Object,
	#instVars : [
		'monitor',
		'bounds',
		'workingArea',
		'dpi',
		'metrics',
		'dc',
		'fonts'
	],
	#classVars : [
		'OriginalExtent'
	],
	#category : #GDI
}

{ #category : #'instance creation' }
Screen class >> current [
	^(self fromPoint: CursorPointer current position)
		ifNil: [VirtualScreen current]]

{ #category : #'instance creation' }
Screen class >> fromPoint: aPoint [
	| handle |
	handle := UserDLL current monitorFromPoint: aPoint.
	^screens detect: [:s | s monitorHandle = handle] ifNone: nil]

{ #category : #'instance creation' }
Screen class >> fromRectangle: aRectangle [
	(self fromPoint: aRectangle center) ifNotNil: [:s | ^s].
	aRectangle corners
		do: [:point | (self fromPoint: point) ifNotNil: [:s | ^s]].
	^self current]

{ #category : #'instance creation' }
Screen class >> fromWindow: aWindow [
	| handle |
	handle := UserDLL current monitorFromWindow: aWindow.
	handle = 0 ifTrue: [^aWindow parent ifNotNil: [:w | w screen]].
	^screens detect: [:s | s monitorHandle = handle] ifNone: [
		self update.
		screens detect: [:s | s monitorHandle = handle] ifNone: nil]]

{ #category : #'startup/shutdown' }
Screen class >> initializeDisplay [
	VirtualScreen initialize]

{ #category : #'instance creation' }
Screen class >> new [
	^super new initialize]

{ #category : #accessing }
Screen class >> primaryMonitor [
	^screens detect: [:s | s isPrimaryMonitor]]

{ #category : #'startup/shutdown' }
Screen class >> sessionShutdown [
	screens do: [:s | s deviceContext release]]

{ #category : #'startup/shutdown' }
Screen class >> setDpiAwareness [
	| success e |
	[success := UserDLL current SetProcessDpiAwarenessContext: 18]
		on: FFIError
		do: [^self].
	success ifFalse: [
		e := self lastWinError.
		Smalltalk transcript nextPutAll: 'setDpiAwareness ' , e asString; cr.
		WinSettings current isWine ifFalse: [self winError: e]]]

{ #category : #'startup/shutdown' }
Screen class >> startUp [
	Smalltalk registerExternal: self.
	self setDpiAwareness; initializeDisplay.
	screens := OrderedCollection new.
	self
		evaluate: [:callback | 
			UserDLL current
				EnumDisplayMonitors: nil asParameter
				lprcClip: nil asParameter
				lpfnEnum: callback asParameter
				dwData: nil asParameter]
		callback: [:h :hdc :rect :d | 
			screens add: (self new monitorHandle: h).
			1]]

{ #category : #'startup/shutdown' }
Screen class >> update [
	| prev |
	prev := screens
		collect: [:screen | screen monitorHandle -> screen]
		in: Dictionary new.
	screens := OrderedCollection new.
	self
		evaluate: [:callback | 
			UserDLL current
				EnumDisplayMonitors: nil asParameter
				lprcClip: nil asParameter
				lpfnEnum: callback asParameter
				dwData: nil asParameter]
		callback: [:h :hdc :rect :d | | screen |
			screen := prev
				at: h
				ifAbsent: [self new monitorHandle: h]
				ifPresent: [:s | s update].
			screens add: screen.
			prev removeKey: h ifAbsent: nil.
			1].
	prev do: [:screen | screen deviceContext delete].
	VirtualScreen current update.
	SmalltalkSession current triggerEvent: #displayChanged]

{ #category : #accessing }
Screen >> aboutToSaveImage [
	metrics := fonts := nil]

{ #category : #accessing }
Screen >> bitsPerPixel [
	^dc bitsPerPixel]

{ #category : #accessing }
Screen >> boundingRectangle [
	^bounds]

{ #category : #fonts }
Screen >> captionFont [
	^fonts at: #captionFont ifAbsentPut: [
		GDIFont
			fromLogicalFont: self getNonClientStruct captionFont
			deviceContext: dc]]

{ #category : #services }
Screen >> compatibleDC [
	^dc compatibleDC]

{ #category : #services }
Screen >> copyRectangle: aRectangle [
	| clip |
	clip := GDIBitmap
		width: aRectangle width
		height: aRectangle height
		bitCount: self bitsPerPixel.
	clip useValidDCWhile: [:context | 
		context
			bitBltAt: 0 @ 0
			width: aRectangle width
			height: aRectangle height
			from: dc asParameter
			at: aRectangle origin
			rop: SRCCOPY].
	^clip]

{ #category : #defaults }
Screen >> defaultIconExtent [
	^(self systemMetric: SM_CXICON) @ (self systemMetric: SM_CYICON)]

{ #category : #accessing }
Screen >> deviceContext [
	^dc]

{ #category : #accessing }
Screen >> deviceName [
	^self info device]

{ #category : #accessing }
Screen >> dpi [
	^dpi ifNil: [dpi := ShcoreDLL current dpiFromMonitor: monitor]]

{ #category : #accessing }
Screen >> drawer [
	^GDIDrawer on: self]

{ #category : #accessing }
Screen >> extent [
	^bounds extent]

{ #category : #fonts }
Screen >> getIconFont [
	| logfont |
	logfont := UserDLL current getIconTitleLogFontFor: self.
	^GDIFont fromLogicalFont: logfont deviceContext: dc]

{ #category : #private }
Screen >> getNonClientStruct [
	^UserDLL current getNonClientStructFor: self]

{ #category : #accessing }
Screen >> height [
	^bounds height]

{ #category : #accessing }
Screen >> horizontalPixelsPerInch [
	^dc horizontalPixelsPerInch]

{ #category : #metrics }
Screen >> iconExtent [
	^self defaultIconExtent]

{ #category : #fonts }
Screen >> iconFont [
	^fonts at: #iconFont ifAbsentPut: [self getIconFont]]

{ #category : #accessing }
Screen >> info [
	^MONITORINFOEX fromHandle: monitor]

{ #category : #initialization }
Screen >> initialize [
	metrics := Dictionary new.
	fonts := Dictionary new]

{ #category : #'filein/out' }
Screen >> isPrimaryMonitor [
	^bounds left = 0 and: [bounds top = 0]]

{ #category : #fonts }
Screen >> menuFont [
	^fonts
		at: #menuFont
		ifAbsentPut: [GDIFont
			fromLogicalFont: self getNonClientStruct menuFont
			deviceContext: dc]]

{ #category : #fonts }
Screen >> messageFont [
	^fonts at: #messageFont ifAbsentPut: [
		GDIFont
			fromLogicalFont: self getNonClientStruct messageFont
			deviceContext: dc]]

{ #category : #accessing }
Screen >> monitorHandle [
	^monitor]

{ #category : #accessing }
Screen >> monitorHandle: anInteger [
	monitor := anInteger.
	self update]

{ #category : #services }
Screen >> origin [
	^self workingArea origin]

{ #category : #accessing }
Screen >> originalExtent [
	^OriginalExtent]

{ #category : #accessing }
Screen >> planes [
	^dc planes]

{ #category : #drawing }
Screen >> redraw [
	UserDLL current InvalidateRect: 0 lpRect: 0 bErase: true asParameter]

{ #category : #services }
Screen >> reinitialize [
	| info |
	info := self info.
	dc := DeviceContext createDC: 'DISPLAY' device: info device.
	bounds := info monitorRectangle.
	workingArea := info workingArea]

{ #category : #metrics }
Screen >> scrollbarHeight [
	^self systemMetric: SM_CYVSCROLL]

{ #category : #metrics }
Screen >> scrollbarWidth [
	^self systemMetric: SM_CXVSCROLL]

{ #category : #metrics }
Screen >> SM_CXBORDER [
	^self systemMetric: SM_CXBORDER]

{ #category : #metrics }
Screen >> SM_CXCURSOR [
	^self systemMetric: SM_CXCURSOR]

{ #category : #metrics }
Screen >> SM_CXFRAME [
	^self systemMetric: SM_CXFRAME]

{ #category : #metrics }
Screen >> SM_CXICON [
	^self systemMetric: SM_CXICON]

{ #category : #metrics }
Screen >> SM_CXMIN [
	^self systemMetric: SM_CXMIN]

{ #category : #'gui support' }
Screen >> SM_CXSCREEN [
	^self systemMetric: SM_CXSCREEN]

{ #category : #'gui support' }
Screen >> SM_CXSIZE [
	^self systemMetric: SM_CXSIZE]

{ #category : #metrics }
Screen >> SM_CYBORDER [
	^self systemMetric: SM_CYBORDER]

{ #category : #metrics }
Screen >> SM_CYCURSOR [
	^self systemMetric: SM_CYCURSOR]

{ #category : #metrics }
Screen >> SM_CYFRAME [
	^self systemMetric: SM_CYFRAME]

{ #category : #'gui support' }
Screen >> SM_CYSCREEN [
	^self systemMetric: SM_CYSCREEN]

{ #category : #'gui support' }
Screen >> SM_CYSIZE [
	^self systemMetric: SM_CYSIZE]

{ #category : #fonts }
Screen >> smallCaptionFont [
	^fonts at: #smallCaptionFont ifAbsentPut: [
		GDIFont
			fromLogicalFont: self getNonClientStruct smallCaptionFont
			deviceContext: dc]]

{ #category : #'gui support' }
Screen >> smallIconExtent [
	| width height |
	width := self systemMetric: SM_CXSMICON.
	height := self systemMetric: SM_CYSMICON.
	^width @ height]

{ #category : #fonts }
Screen >> statusFont [
	^fonts at: #statusFont ifAbsentPut: [
		GDIFont
			fromLogicalFont: self getNonClientStruct statusFont
			deviceContext: dc]]

{ #category : #private }
Screen >> systemMetric: anInteger [
	^metrics
		at: anInteger
		ifAbsentPut: [UserDLL current getSystemMetrics: anInteger for: self]]

{ #category : #defaults }
Screen >> titleHeight [
	^self systemMetric: SM_CYCAPTION]

{ #category : #private }
Screen >> track: aDrawer while: aBlock [
	| width type fore back |
	width := aDrawer lineWidth.
	type := aDrawer lineStyle.
	fore := aDrawer lineColor.
	back := aDrawer backColor.
	aDrawer
		lineWidth: 1;
		lineStyle: #dot;
		lineColor: Color defaultTextColor;
		backColor: Color defaultBackColor.
	dc setRop2: R2_XORPEN.
	^[aBlock value] ensure: [
		aDrawer
			lineWidth: width;
			lineStyle: type;
			lineColor: fore;
			backColor: back.
		dc setRop2: R2_COPYPEN]]

{ #category : #services }
Screen >> update [
	| prev |
	(dc notNil and: [dc isAlive]) ifTrue: [
		prev := dc.
		dc delete].
	self reinitialize.
	metrics := Dictionary new.
	self updateFonts.
	dpi := nil.
	GDIFont deviceContextDeleted: prev from: self]

{ #category : #fonts }
Screen >> updateFonts [
	fonts keysAndValuesDo: [:k :f | 
		f
			logicalFont: (self getNonClientStruct perform: k);
			deviceContext: dc]]

{ #category : #services }
Screen >> useValidDCWhile: aBlock [
	^aBlock evaluateWith: dc]

{ #category : #accessing }
Screen >> verticalPixelsPerInch [
	^dc verticalPixelsPerInch]

{ #category : #accessing }
Screen >> width [
	^bounds height]

{ #category : #services }
Screen >> workingArea [
	^workingArea]

{ #category : #services }
Screen >> xDU [
	^self
		propertyAt: #xDU
		ifAbsentPut: [self dpi / 120 * 0.6 + (self width / 1920 * 0.4) * 3]]

{ #category : #services }
Screen >> yDU [
	^self
		propertyAt: #yDU
		ifAbsentPut: [self dpi / 120 * 0.6 + (self height / 1200 * 0.4) * 2.6]]

