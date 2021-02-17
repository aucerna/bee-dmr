"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIDrawer,
	#superclass : #Drawer,
	#category : #GDI
}

{ #category : #private }
GDIDrawer class >> brushClass [
	^GDIBrush]

{ #category : #'instance creation' }
GDIDrawer class >> newExtent: point [
	^self onBitmapExtent: point]

{ #category : #'instance creation' }
GDIDrawer class >> on: gdiObject [
	^self new on: gdiObject]

{ #category : #'instance creation' }
GDIDrawer class >> onBitmapExtent: aPoint [
	| bitmap |
	bitmap := GDIBitmap extent: aPoint bitCount: 32.
	bitmap usePrivateDC.
	^self onBitmap: bitmap]

{ #category : #private }
GDIDrawer class >> pencilClass [
	^GDIPen]

{ #category : #testing }
GDIDrawer class >> supportsGradient [
	^false]

{ #category : #converting }
GDIDrawer >> asBitmap [
	^dc currentBitmap]

{ #category : #colors }
GDIDrawer >> backColor: aColor [
	super backColor: aColor.
	dc notNil ifTrue: [dc backColor: aColor]]

{ #category : #private }
GDIDrawer >> brushStyle [
	brush isSolidBrush ifTrue: [^BS_SOLID].
	brush isHatchBrush ifTrue: [^BS_HATCHED].
	self ASSERT: false.
	^nil]

{ #category : #errors }
GDIDrawer >> clip: aRectangle while: aBlock [
	| rect region |
	aRectangle isNil ifTrue: [^aBlock value].
	rect := dc rectFromLogical: aRectangle.
	region := dc setClipRect: rect.
	aBlock ensure: [dc destroyRegion: region]]

{ #category : #colors }
GDIDrawer >> colorAt: aPoint [
	| point |
	point := self transform: aPoint.
	^super colorAt: point]

{ #category : #bitblt }
GDIDrawer >> copy: aRectangle at: aPoint [
	self copy: aRectangle from: canvas at: aPoint]

{ #category : #bitblt }
GDIDrawer >> copy: aRectangle from: aDeviceContext at: aPoint [
	| rect |
	rect := aPoint extent: aRectangle extent.
	self copy: aRectangle from: aDeviceContext to: rect]

{ #category : #bitblt }
GDIDrawer >> copy: aRectangle from: aBitmap to: anotherRectangle [
	self
		copy: aRectangle
		from: aBitmap
		to: anotherRectangle
		rule: SRCCOPY]

{ #category : #bitblt }
GDIDrawer >> copy: aRectangle
from: aBitmap
to: anotherRectangle
rule: rop [
	aBitmap
		useValidDCWhile: [:vdc | vdc
			stretchBltWith: vdc
			from: aRectangle
			to: anotherRectangle
			rule: rop]]

{ #category : #private }
GDIDrawer >> dashStyleFor: aSymbol [
	aSymbol == #solid ifTrue: [^PS_SOLID].
	aSymbol == #dash ifTrue: [^PS_DASH].
	aSymbol == #dot ifTrue: [^PS_DOT].
	aSymbol == #dashdot ifTrue: [^PS_DASHDOT].
	aSymbol == #dashdotdot ifTrue: [^PS_DASHDOTDOT].
	aSymbol == #inside ifTrue: [^PS_INSIDEFRAME].
	aSymbol == #null ifTrue: [^PS_NULL].
	self ASSERT: false.
	^PS_SOLID]

{ #category : #accessing }
GDIDrawer >> deviceContext [
	^dc]

{ #category : #bitmaps }
GDIDrawer >> draw: aRectangle ofBitmap: aBitmap at: aPoint [
	dc draw: aRectangle ofBitmap: aBitmap at: aPoint]

{ #category : #'drawing - curves' }
GDIDrawer >> drawArc: radius
center: center
startAngle: startAngle
sweepAngle: sweepAngle [
	self updatePencil.
	dc
		drawArc: radius
		center: center
		startAngle: startAngle
		sweepAngle: sweepAngle]

{ #category : #'drawing - curves' }
GDIDrawer >> drawArc: aRectangle startAngle: startPoint sweepAngle: endPoint [
	self updatePencil.
	dc drawArc: aRectangle start: startPoint end: endPoint]

{ #category : #'drawing - bitmaps' }
GDIDrawer >> drawBitmap: aBitmap at: aPoint [
	dc drawBitmap: aBitmap asGDIBitmap at: aPoint]

{ #category : #'drawing - bitmaps' }
GDIDrawer >> drawBitmap: aBitmap in: aRectangle [
	| bitmap |
	bitmap := aBitmap asGDIBitmap.
	bitmap hasAlphaChannel
		ifTrue: [dc
			alphaBlendBitmap: bitmap
			in: aRectangle
			alpha: bitmap alphaConstant]
		ifFalse: [dc
			copyBitmap: bitmap
			from: bitmap boundingRectangle
			to: aRectangle]]

{ #category : #'drawing - ellipses' }
GDIDrawer >> drawEllipse: aRectangle [
	| previous |
	self updatePencil.
	previous := dc selectStockBrush: NULL_BRUSH.
	[dc drawEllipse: aRectangle] ensure: [dc selectBrush: previous]]

{ #category : #'drawing - ellipses' }
GDIDrawer >> drawEllipseFilled: aRectangle [
	"
	(self example lineColor: Color blue; brushColor: Color yellow; lineWidth: 14; drawEllipseFilled: (10 @ 10 extent: 170 @ 90)) canvas
	"
	self updatePencil; updateBrush.
	dc drawEllipse: aRectangle]

{ #category : #'drawing - metafiles' }
GDIDrawer >> drawEnhMetafile: anEnhMetaFile in: aRectangle [
	dc playEnhMetaFile: anEnhMetaFile in: aRectangle]

{ #category : #'drawing - metafiles' }
GDIDrawer >> drawEnhMetaFile: anEnhMetaFile in: aRectangle [
	dc drawEnhMetaFile: anEnhMetaFile in: aRectangle]

{ #category : #services }
GDIDrawer >> drawFocusRectangle: aRectangle [
	dc drawFocusRectangle: aRectangle]

{ #category : #'drawing - icons' }
GDIDrawer >> drawIcon: anIcon at: aPoint [
	dc drawIcon: anIcon at: aPoint]

{ #category : #'drawing - icons' }
GDIDrawer >> drawIcon: anIcon in: aRectangle [
	dc drawIcon: anIcon in: aRectangle]

{ #category : #'drawing - lines' }
GDIDrawer >> drawLineFrom: p1 to: p2 [
	self updatePencil.
	dc moveTo: p1; drawLineTo: p2]

{ #category : #'drawing - lines' }
GDIDrawer >> drawLines: points [
	self updatePencil.
	dc drawPolyline: points]

{ #category : #'drawing - polygons' }
GDIDrawer >> drawPolygon: points [
	| prev |
	self lineWidth > 1 ifTrue: [self lineStyle: #inside].
	self updatePencil.
	prev := dc selectStockBrush: NULL_BRUSH.
	[dc drawPolygon: points] ensure: [dc selectBrush: prev]]

{ #category : #'drawing - polygons' }
GDIDrawer >> drawPolygonFilled: points [
	pencil lineWidth > 1 ifTrue: [self lineStyle: #inside].
	self updatePencil; updateBrush.
	dc drawPolygon: points]

{ #category : #'drawing - rectangles' }
GDIDrawer >> drawRectangle: aRectangle [
	| prev |
	(aRectangle width max: aRectangle height) = 1 ifTrue: [
		self drawLineFrom: aRectangle origin to: aRectangle corner.
		^self].
	pencil lineWidth > 1 ifTrue: [self lineStyle: #inside].
	self updatePencil.
	prev := dc selectStockBrush: NULL_BRUSH.
	[dc drawRectangle: aRectangle] ensure: [dc selectBrush: prev]]

{ #category : #'drawing - rectangles' }
GDIDrawer >> drawRectangleFilled: aRectangle [
	| rectangle |
	rectangle := self transform: aRectangle.
	rectangle extent max = 1 ifTrue: [
		self drawLineFrom: rectangle origin to: rectangle corner.
		^self].
	pencil lineWidth > 1 ifTrue: [self lineStyle: #inside].
	self updatePencil; updateBrush.
	dc drawRectangle: rectangle]

{ #category : #'drawing - rectangles' }
GDIDrawer >> drawRoundRectangle: aRectangle corner: radius [
	| rectangle prev |
	pencil lineWidth > 1 ifTrue: [self lineStyle: #inside].
	rectangle := self transform: aRectangle.
	self updatePencil.
	prev := dc selectStockBrush: NULL_BRUSH.
	[dc drawRoundRectangle: rectangle corner: radius asPoint]
		ensure: [dc selectBrush: prev]]

{ #category : #'drawing - rectangles' }
GDIDrawer >> drawRoundRectangleFilled: aRectangle corner: radius [
	| rectangle |
	pencil lineWidth > 1 ifTrue: [self lineStyle: #inside].
	rectangle := self transform: aRectangle.
	self updatePencil; updateBrush.
	dc drawRoundRectangle: rectangle corner: radius asPoint]

{ #category : #'drawing - strings' }
GDIDrawer >> drawString: aString at: aPoint [
	| p box |
	p := self transform: aPoint.
	box := p extent: 0 @ 0.
	self drawString: aString in: box format: self stringAlignment]

{ #category : #'drawing - strings' }
GDIDrawer >> drawString: aString in: aRectangle [
	self drawString: aString in: aRectangle format: #center]

{ #category : #'drawing - strings' }
GDIDrawer >> drawString: aString in: aRectangle format: stringFormat [
	"
	ShellDLL current openWebPage: 'https://msdn.microsoft.com/en-us/library/windows/desktop/dd144932(v=vs.85).aspx'
	"
	| format align |
	format := self stringFormatFor: stringFormat.
	aRectangle isEmpty ifTrue: [format := format | DT_NOCLIP].
	aString lines size > 1 ifFalse: [format := format | DT_SINGLELINE].
	align := dc getTextAlign.
	dc
		setTextAlign: TA_LEFT | TA_TOP | TA_NOUPDATECP;
		drawText: aString in: aRectangle format: format;
		setTextAlign: align]

{ #category : #'drawing - metafiles' }
GDIDrawer >> drawWinMetafile: anEnhMetaFile in: aRectangle [
	| rectangle unitsPerInch extent |
	rectangle := dc rectFromLogical: aRectangle.
	extent := anEnhMetaFile header isNil
		ifTrue: [self boundingRectangle extent]
		ifFalse: [
			unitsPerInch := dc horizontalPixelsPerInch @ dc verticalPixelsPerInch.
			(anEnhMetaFile header box extent / anEnhMetaFile header inch
				* unitsPerInch)
				truncated].
	dc saveWhile: [
		dc
			mapMode: MM_ANISOTROPIC;
			windowOrigin: 0 @ 0;
			windowExtent: extent;
			viewportOrigin: rectangle origin;
			viewportExtent: rectangle extent;
			playMetaFile: anEnhMetaFile]]

{ #category : #'drawing - ellipses' }
GDIDrawer >> fillEllipse: aRectangle [
	| previous |
	self updateBrush.
	previous := dc selectStockPen: NULL_PEN.
	[dc drawEllipse: aRectangle] ensure: [dc selectObject: previous]]

{ #category : #'drawing - polygons' }
GDIDrawer >> fillPolygon: points [
	| previous |
	self updateBrush.
	previous := dc selectStockPen: NULL_PEN.
	[dc drawPolygon: points] ensure: [dc selectObject: previous]]

{ #category : #'drawing - rectangles' }
GDIDrawer >> fillRectangle: aRectangle [
	self updateBrush.
	dc fillRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
GDIDrawer >> fillRoundRectangle: aRectangle corner: radius [
	| previous |
	self updateBrush.
	previous := dc selectStockPen: NULL_PEN.
	[dc drawRoundRectangle: aRectangle corner: radius asPoint]
		ensure: [dc selectObject: previous]]

{ #category : #fonts }
GDIDrawer >> font: aFont [
	self font = aFont ifTrue: [^self].
	super font: aFont.
	dc notNil ifTrue: [dc selectFont: aFont]]

{ #category : #private }
GDIDrawer >> hatchStyleFor: aSymbol [
	aSymbol == #horizontal ifTrue: [^HS_HORIZONTAL].
	aSymbol == #vertical ifTrue: [^HS_VERTICAL].
	aSymbol == #cross ifTrue: [^HS_CROSS].
	aSymbol == #diagcross ifTrue: [^HS_DIAGCROSS].
	aSymbol == #bdiagonal ifTrue: [^HS_BDIAGONAL].
	aSymbol == #fdiagonal ifTrue: [^HS_FDIAGONAL].
	self ASSERT: false]

{ #category : #accessing }
GDIDrawer >> invalidateDC [
	dc := nil]

{ #category : #testing }
GDIDrawer >> isAlive [
	^dc notNil and: [dc isAlive]]

{ #category : #'line settings' }
GDIDrawer >> lineWidth: anInteger [
	| pixels |
	pixels := self scaledOf: anInteger.
	super lineWidth: pixels]

{ #category : #accessing }
GDIDrawer >> on: gdiObject [
	canvas := gdiObject.
	self onDC: gdiObject deviceContext]

{ #category : #accessing }
GDIDrawer >> onDC: aDeviceContext [
	dc := aDeviceContext isInteger
		ifTrue: [DeviceContext fromInteger: aDeviceContext asParameter]
		ifFalse: [aDeviceContext].
	dc
		brushColor: self brushColor;
		textColor: self textColor;
		selectFont: self font;
		setBackgroundModeTransparent]

{ #category : #accessing }
GDIDrawer >> onMenu: aMenuWindow [
	dc := DeviceContext new.
	canvas := aMenuWindow]

{ #category : #services }
GDIDrawer >> release [
	dc release]

{ #category : #coordinates }
GDIDrawer >> scale [
	^converter isNil ifTrue: [1 @ 1] ifFalse: [converter scale]]

{ #category : #'scaled & tranlated' }
GDIDrawer >> scaleX: object [
	^converter isNil ifTrue: [object] ifFalse: [converter scaleX: object]]

{ #category : #'scaled & tranlated' }
GDIDrawer >> scaleY: object [
	^converter isNil ifTrue: [object] ifFalse: [converter scaleY: object]]

{ #category : #styles }
GDIDrawer >> setCopy [
	dc setRop2: R2_COPYPEN]

{ #category : #styles }
GDIDrawer >> setXOR [
	dc setRop2: R2_NOTXORPEN]

{ #category : #accessing }
GDIDrawer >> stringAlignment: aSymbol [
	| constant |
	super stringAlignment: aSymbol.
	constant := self stringAlignmentFor: aSymbol.
	dc setTextAlign: constant]

{ #category : #private }
GDIDrawer >> stringAlignmentFor: aSymbol [
	aSymbol == #topLeft ifTrue: [^TA_LEFT | TA_TOP].
	aSymbol == #topRight ifTrue: [^TA_RIGHT | TA_TOP].
	aSymbol == #topCenter ifTrue: [^TA_CENTER | TA_TOP].
	aSymbol == #center ifTrue: [^TA_CENTER | TA_BASELINE].
	aSymbol == #left ifTrue: [^TA_LEFT | TA_BASELINE].
	aSymbol == #right ifTrue: [^TA_RIGHT | TA_BASELINE].
	self ASSERT: false.
	^TA_LEFT | TA_BASELINE]

{ #category : #accessing }
GDIDrawer >> stringFormatFor: aSymbol [
	aSymbol == #topLeft ifTrue: [^DT_TOP | DT_LEFT].
	aSymbol == #topRight ifTrue: [^DT_TOP | DT_RIGHT].
	aSymbol == #topCenter ifTrue: [^DT_TOP | DT_CENTER].
	aSymbol == #center ifTrue: [^DT_VCENTER | DT_CENTER].
	aSymbol == #bottom ifTrue: [^DT_BOTTOM].
	aSymbol == #left ifTrue: [^DT_LEFT].
	aSymbol == #right ifTrue: [^DT_RIGHT].
	self ASSERT: false.
	^DT_TOP | DT_LEFT]

{ #category : #colors }
GDIDrawer >> textColor: aColor [
	super textColor: aColor.
	dc notNil ifTrue: [dc textColor: aColor]]

{ #category : #transforming }
GDIDrawer >> transform: geometry [
	^converter isNil
		ifTrue: [geometry]
		ifFalse: [converter transform: geometry]]

{ #category : #coordinates }
GDIDrawer >> transformCollection: geometry [
	^converter isNil
		ifTrue: [geometry]
		ifFalse: [converter transformCollection: geometry]]

{ #category : #private }
GDIDrawer >> updateBrush [
	| hatch logical |
	brush isHatchBrush ifTrue: [
		self backColor: brush backColor.
		hatch := self hatchStyleFor: brush hatchStyle].
	logical := pencilCase
		brushWithAttributes: {self brushStyle ifNil: BS_SOLID.
			brush color asInteger. hatch ifNil: HS_HORIZONTAL}.
	dc selectBrush: logical]

{ #category : #private }
GDIDrawer >> updatePencil [
	| logical style |
	style := self dashStyleFor: pencil lineStyle.
	logical := pencilCase
		pencilWithAttributes: {style. pencil color asInteger. pencil width}.
	dc selectPen: logical]

{ #category : #services }
GDIDrawer >> useDC: dcHandle while: aBlock [
	| original |
	original := dc.
	self onDC: dcHandle.
	aBlock ensure: [dc := original]]

{ #category : #services }
GDIDrawer >> widthOfString: aString [
	^dc widthOfString: aString]

