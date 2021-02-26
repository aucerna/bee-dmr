"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusGraphics,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusGraphics class >> fromHDC: aDeviceContext [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateFromHDC: aDeviceContext asParameter
		graphics: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusGraphics class >> fromHDC: aDeviceContext hDevice: hDevice [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateFromHDC2: aDeviceContext asParameter
		hDevice: hDevice asParameter
		graphics: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusGraphics class >> fromHWND: aWindow [
	^self fromHWND: aWindow useICM: false]

{ #category : #'instance creation' }
GDIPlusGraphics class >> fromHWND: aWindow useICM: useICM [
	| pointer status |
	pointer := ExternalPointer external.
	status := useICM
		ifTrue: [
			self dll
				GdipCreateFromHWNDICM: aWindow asParameter
				graphics: pointer asParameter]
		ifFalse: [
			self dll
				GdipCreateFromHWND: aWindow asParameter
				graphics: pointer asParameter].
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusGraphics class >> fromImage: aGDIPlusImage [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipGetImageGraphicsContext: aGDIPlusImage asParameter
		graphics: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #private }
GDIPlusGraphics >> basicRelease [
	status := self dll GdipDeleteGraphics: self asParameter.
	self checkStatus]

{ #category : #erasing }
GDIPlusGraphics >> clear: color [
	| argb |
	argb := ARGB from: color.
	status := self dll
		GdipGraphicsClear: self asParameter
		color: argb asParameter.
	self checkStatus]

{ #category : #clipping }
GDIPlusGraphics >> clipPath: aGDIPlusGraphicsPath combineMode: combineMode [
	status := self dll
		GdipSetClipPath: self asParameter
		path: aGDIPlusGraphicsPath asParameter
		combineMode: combineMode.
	self checkStatus]

{ #category : #clipping }
GDIPlusGraphics >> clipRectangle: aRectangle [
	| region |
	region := GDIPlusRegion fromRectangle: aRectangle.
	self clipRegion: region.
	^region]

{ #category : #clipping }
GDIPlusGraphics >> clipRegion [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipGetClip: self asParameter
		region: pointer asParameter.
	self checkStatus.
	^GDIPlusRegion new handle: pointer makeInteger]

{ #category : #clipping }
GDIPlusGraphics >> clipRegion: aGDIPlusRegion [
	self clipRegion: aGDIPlusRegion combineMode: nil]

{ #category : #clipping }
GDIPlusGraphics >> clipRegion: aGDIPlusRegion combineMode: combineMode [
	status := self dll
		GdipSetClipRegion: self asParameter
		region: aGDIPlusRegion asParameter
		combineMode: combineMode.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphics >> compositingMode [
	| mode |
	mode := ExternalPointer external.
	status := self dll
		GdipGetCompositingMode: self asParameter
		compositingMode: mode asParameter.
	self checkStatus.
	^mode makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> compositingMode: compositingMode [
	status := self dll
		GdipSetCompositingMode: self asParameter
		compositingMode: compositingMode asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphics >> compositingQuality [
	| quality |
	quality := ExternalInt32 external.
	status := self dll
		GdipGetCompositingQuality: self asParameter
		compositingQuality: quality asParameter.
	self checkStatus.
	^quality makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> compositingQuality: compositingQuality [
	status := self dll
		GdipSetCompositingQuality: self asParameter
		compositingQuality: compositingQuality asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawArc: aRectangle
pen: aGDIPlusPen
startAngle: startAngle
sweepAngle: sweepAngle [
	| start sweep |
	start := ExternalFloat from: startAngle.
	sweep := ExternalFloat from: sweepAngle.
	status := self dll
		GdipDrawArcI: self asParameter
		pen: aGDIPlusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: start asParameter
		sweepAngle: sweep asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawBezier: pointsCollection pen: aGDIPlusPen [
	status := self dll
		GdipDrawBezierI: self asParameter
		pen: aGDIPlusPen asParameter
		x1: pointsCollection first x
		y1: pointsCollection first y
		x2: pointsCollection second x
		y2: pointsCollection second y
		x3: pointsCollection third x
		y3: pointsCollection third y
		x4: pointsCollection fourth x
		y4: pointsCollection fourth y.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawCachedBitmap: aGDIPlusCachedBitmap at: aPoint [
	status := self dll
		GdipDrawCachedBitmap: self asParameter
		cachedBitmap: aGDIPlusCachedBitmap asParameter
		x: aPoint x asParameter
		y: aPoint y asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawCircle: radius center: aPoint pen: aGDIPlusPen [
	| box |
	box := aPoint - radius corner: aPoint + radius.
	self drawEllipse: box rounded pen: aGDIPlusPen]

{ #category : #drawing }
GDIPlusGraphics >> drawClosedCurve: pointsCollection pen: aGDIPlusPen tension: aNumber [
	| points real |
	points := BufferArray externalOn: pointsCollection type: POINT.
	real := ExternalFloat from: aNumber.
	status := self dll
		GdipDrawClosedCurve2I: self asParameter
		pen: aGDIPlusPen asParameter
		points: points asParameter
		count: pointsCollection size
		tension: real asParameter.
	self checkStatus.
	points free]

{ #category : #drawing }
GDIPlusGraphics >> drawCurve: points pen: aGDIPlusPen [
	| buffer |
	buffer := (BufferArray on: points type: POINT) externalCopy.
	status := self dll
		GdipDrawCurveI: self asParameter
		pen: aGDIPlusPen asParameter
		points: buffer asParameter
		count: points size.
	self checkStatus.
	buffer free]

{ #category : #drawing }
GDIPlusGraphics >> drawCurve: points pen: aGDIPlusPen tension: aNumber [
	| buffer real |
	buffer := BufferArray externalOn: points type: POINT.
	real := ExternalFloat from: aNumber.
	status := self dll
		GdipDrawCurve2I: self asParameter
		pen: aGDIPlusPen asParameter
		points: buffer asParameter
		count: points size
		tension: real asParameter.
	self checkStatus.
	buffer free]

{ #category : #drawing }
GDIPlusGraphics >> drawEllipse: aRectangle pen: aGDIPlusPen [
	| xr yr wr hr |
	xr := ExternalFloat from: aRectangle left.
	yr := ExternalFloat from: aRectangle top.
	wr := ExternalFloat from: aRectangle width.
	hr := ExternalFloat from: aRectangle height.
	status := self dll
		GdipDrawEllipse: self asParameter
		pen: aGDIPlusPen asParameter
		x: xr asParameter
		y: yr asParameter
		width: wr asParameter
		height: hr asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage at: aPoint [
	| x y |
	aGDIPlusImage isCachedBitmap
		ifTrue: [^self drawCachedBitmap: aGDIPlusImage at: aPoint].
	x := ExternalFloat from: aPoint x.
	y := ExternalFloat from: aPoint y.
	status := self dll
		GdipDrawImage: self asParameter
		image: aGDIPlusImage asParameter
		x: x asParameter
		y: y asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage
at: aPoint
width: width
height: height [
	status := self dll
		GdipDrawImageRectI: self asParameter
		image: aGDIPlusImage asParameter
		x: aPoint x asParameter
		y: aPoint y asParameter
		width: width asParameter
		height: height asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage from: aRectangle at: aPoint [
	status := self dll
		GdipDrawImagePointRectI: self asParameter
		image: aGDIPlusImage asParameter
		x: aPoint x
		y: aPoint y
		srcx: aRectangle left
		srcy: aRectangle top
		srcwidth: aRectangle width
		srcheight: aRectangle height
		srcUnit: UnitPixel.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage from: srcRect to: dstRect [
	self
		drawImage: aGDIPlusImage
		from: srcRect
		to: dstRect
		unit: UnitPixel]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage
from: srcRect
to: dstRect
unit: srcUnit [
	self
		drawImage: aGDIPlusImage
		from: srcRect
		to: dstRect
		unit: srcUnit
		imageAttributes: nil]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage
from: srcRect
to: dstRect
unit: srcUnit
imageAttributes: imageAttributes [
	self
		drawImage: aGDIPlusImage
		from: srcRect
		to: dstRect
		unit: srcUnit
		imageAttributes: imageAttributes
		callback: nil
		callbackData: nil]

{ #category : #drawing }
GDIPlusGraphics >> drawImage: aGDIPlusImage
from: srcRect
to: dstRect
unit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	| dstx dsty dstwidth dstheight srcx srcy srcwidth srcheight |
	(srcRect left isInteger
		and: [srcRect right isInteger]
		and: [srcRect top isInteger]
		and: [srcRect bottom isInteger]
		and: [dstRect left isInteger]
		and: [dstRect right isInteger]
		and: [dstRect top isInteger]
		and: [dstRect bottom isInteger])
		ifTrue: [
			self
				drawImageInt: aGDIPlusImage
				from: srcRect
				to: dstRect
				unit: srcUnit
				imageAttributes: imageAttributes
				callback: callback
				callbackData: callbackData]
		ifFalse: [
			dstx := ExternalFloat from: dstRect left.
			dsty := ExternalFloat from: dstRect top.
			dstwidth := ExternalFloat from: dstRect width.
			dstheight := ExternalFloat from: dstRect height.
			srcx := ExternalFloat from: srcRect left.
			srcy := ExternalFloat from: srcRect top.
			srcwidth := ExternalFloat from: srcRect width.
			srcheight := ExternalFloat from: srcRect height.
			status := self dll
				GdipDrawImageRectRect: self asParameter
				image: aGDIPlusImage asParameter
				dstx: dstx asParameter
				dsty: dsty asParameter
				dstwidth: dstwidth asParameter
				dstheight: dstheight asParameter
				srcx: srcx asParameter
				srcy: srcy asParameter
				srcwidth: srcwidth asParameter
				srcheight: srcheight asParameter
				srcUnit: srcUnit asParameter
				imageAttributes: imageAttributes asParameter
				callback: callback asParameter
				callbackData: callbackData asParameter.
			self checkStatus]]

{ #category : #drawing }
GDIPlusGraphics >> drawImageInt: aGDIPlusImage
from: srcRect
to: dstRect
unit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	status := self dll
		GdipDrawImageRectRectI: self asParameter
		image: aGDIPlusImage asParameter
		dstx: dstRect left asParameter
		dsty: dstRect top asParameter
		dstwidth: dstRect width asParameter
		dstheight: dstRect height asParameter
		srcx: srcRect left asParameter
		srcy: srcRect top asParameter
		srcwidth: srcRect width asParameter
		srcheight: srcRect height asParameter
		srcUnit: srcUnit asParameter
		imageAttributes: imageAttributes asParameter
		callback: callback asParameter
		callbackData: callbackData asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawLineFrom: startPoint to: endPoint pen: aGDIPlusPen [
	| x1 y1 x2 y2 |
	x1 := ExternalFloat from: startPoint x.
	y1 := ExternalFloat from: startPoint y.
	x2 := ExternalFloat from: endPoint x.
	y2 := ExternalFloat from: endPoint y.
	status := self dll
		GdipDrawLine: self asParameter
		pen: aGDIPlusPen asParameter
		x1: x1 asParameter
		y1: y1 asParameter
		x2: x2 asParameter
		y2: y2 asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawLines: points pen: aGDIPlusPen [
	| buffer |
	buffer := BufferArray externalOn: points type: POINT.
	status := self dll
		GdipDrawLinesI: self asParameter
		pen: aGDIPlusPen asParameter
		points: buffer asParameter
		count: points size.
	self checkStatus.
	buffer free]

{ #category : #drawing }
GDIPlusGraphics >> drawPath: aGDIPlusGraphicsPath pen: aGDIPlusPen [
	status := self dll
		GdipDrawPath: self asParameter
		pen: aGDIPlusPen asParameter
		path: aGDIPlusGraphicsPath asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawPie: aRectangle
pen: aGDIPlusPen
startAngle: startAngle
sweepAngle: sweepAngle [
	| start sweep |
	start := ExternalFloat from: startAngle.
	sweep := ExternalFloat from: sweepAngle.
	status := self dll
		GdipDrawPieI: self asParameter
		pen: aGDIPlusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: start asParameter
		sweepAngle: sweep asParameter.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawPolygon: pointsCollection pen: aGDIPlusPen [
	| points |
	points := BufferArray externalOn: pointsCollection type: POINT.
	status := self dll
		GdipDrawPolygonI: self asParameter
		pen: aGDIPlusPen asParameter
		points: points asParameter
		count: pointsCollection size.
	points free.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawRectangle: aRectangle pen: aGDIPlusPen [
	status := self dll
		GdipDrawRectangleI: self asParameter
		pen: aGDIPlusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height.
	self checkStatus]

{ #category : #drawing }
GDIPlusGraphics >> drawRectangles: rectangles pen: aGDIPlusPen [
	| buffer |
	buffer := BufferArray externalOn: rectangles type: RectF.
	status := self dll
		GdipDrawRectangles: self asParameter
		pen: aGDIPlusPen asParameter
		rects: buffer asParameter
		count: rectangles size.
	self checkStatus.
	buffer free]

{ #category : #drawing }
GDIPlusGraphics >> drawRoundRectangle: aRectangle pen: aGDIPlusPen corner: radius [
	| path |
	path := GDIPlusGraphicsPath new.
	path
		addLineFrom: aRectangle left + radius @ aRectangle top
		to: aRectangle right - (radius * 2) @ aRectangle top;
		addArc: (aRectangle right - (radius * 2) @ aRectangle top extent: radius
			* 2)
		angles: 270 @ 90;
		addLineFrom: aRectangle right @ (aRectangle top + radius)
		to: aRectangle right @ (aRectangle bottom - (radius * 2));
		addArc: (aRectangle right - (radius * 2) @ (aRectangle bottom - (radius
			* 2))
			extent: radius * 2)
		angles: 0 @ 90;
		addLineFrom: aRectangle right - (radius * 2) @ aRectangle bottom
		to: aRectangle left + radius @ aRectangle bottom;
		addArc: (aRectangle left @ (aRectangle bottom - (radius * 2))
			extent: radius * 2)
		angles: 90 @ 90;
		addLineFrom: aRectangle left @ (aRectangle bottom - (radius * 2))
		to: aRectangle left @ (aRectangle top + radius);
		addArc: (aRectangle leftTop extent: radius * 2) angles: 180 @ 90;
		closeFigure.
	self drawPath: path pen: aGDIPlusPen]

{ #category : #drawing }
GDIPlusGraphics >> drawString: aString at: aPoint [
	self
		drawString: aString
		font: nil
		origin: aPoint
		stringFormat: nil
		brush: nil]

{ #category : #drawing }
GDIPlusGraphics >> drawString: aString
font: aGDIPlusFont
layoutRectangle: aRectangle
stringFormat: aGDIPlusStringFormat
brush: aGDIPlusBrush [
	| font format brush rect string |
	font := aGDIPlusFont ifNil: [GDIPlusFont new].
	format := aGDIPlusStringFormat ifNil: [GDIPlusStringFormat new].
	brush := aGDIPlusBrush ifNil: [GDIPlusSolidBrush new].
	rect := RectF external from: aRectangle.
	string := aString externalCopy.
	status := self dll
		GdipDrawString: self asParameter
		string: string asParameter
		length: aString size
		font: font asParameter
		layoutRect: rect asParameter
		stringFormat: format asParameter
		brush: brush asParameter.
	self checkStatus.
	rect free.
	string free]

{ #category : #drawing }
GDIPlusGraphics >> drawString: aString
font: aGDIPlusFont
origin: aPoint
stringFormat: aGDIPlusStringFormat
brush: aGDIPlusBrush [
	^self
		drawString: aString
		font: aGDIPlusFont
		layoutRectangle: (aPoint extent: 0 @ 0)
		stringFormat: aGDIPlusStringFormat
		brush: aGDIPlusBrush]

{ #category : #filling }
GDIPlusGraphics >> fillEllipse: aRectangle brush: aGdiplusBrush [
	status := self dll
		GdipFillEllipseI: self asParameter
		brush: aGdiplusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height.
	self checkStatus]

{ #category : #filling }
GDIPlusGraphics >> fillPath: aGDIPlusGraphicsPath brush: aGDIPlusBrush [
	status := self dll
		GdipFillPath: self asParameter
		brush: aGDIPlusBrush asParameter
		path: aGDIPlusGraphicsPath asParameter.
	self checkStatus]

{ #category : #filling }
GDIPlusGraphics >> fillPie: aRectangle
brush: aGDIPlusBrush
startAngle: startAngle
sweepAngle: sweepAngle [
	| start sweep |
	start := ExternalFloat from: startAngle.
	sweep := ExternalFloat from: sweepAngle.
	status := self dll
		GdipFillPieI: self asParameter
		brush: aGDIPlusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: start asParameter
		sweepAngle: sweep asParameter.
	self checkStatus]

{ #category : #filling }
GDIPlusGraphics >> fillPolygon: points brush: aGDIPlusBrush [
	self fillPolygon: points brush: aGDIPlusBrush fillMode: nil]

{ #category : #filling }
GDIPlusGraphics >> fillPolygon: points brush: aGDIPlusBrush fillMode: mode [
	| buffer |
	aGDIPlusBrush isNil ifTrue: [^self].
	buffer := BufferArray externalOn: points type: POINT.
	status := self dll
		GdipFillPolygonI: self asParameter
		brush: aGDIPlusBrush asParameter
		points: buffer asParameter
		count: points size
		fillMode: mode asParameter.
	self checkStatus.
	buffer free]

{ #category : #filling }
GDIPlusGraphics >> fillRectangle: aRectangle brush: aGDIPlusBrush [
	self
		fillRectangleAt: aRectangle leftTop
		width: aRectangle width
		height: aRectangle height
		brush: aGDIPlusBrush]

{ #category : #filling }
GDIPlusGraphics >> fillRectangleAt: origin
width: width
height: height
brush: aGDIPlusBrush [
	| x y w h |
	x := ExternalFloat from: origin x.
	y := ExternalFloat from: origin y.
	w := ExternalFloat from: width.
	h := ExternalFloat from: height.
	status := self dll
		GdipFillRectangle: self asParameter
		brush: aGDIPlusBrush asParameter
		x: x asParameter
		y: y asParameter
		width: w asParameter
		height: h asParameter.
	self checkStatus]

{ #category : #filling }
GDIPlusGraphics >> fillRectangles: rectangles brush: aGDIPlusBrush [
	| buffer |
	buffer := BufferArray externalOn: rectangles type: RectF.
	status := self dll
		GdipFillRectangles: self asParameter
		brush: aGDIPlusBrush asParameter
		rects: buffer asParameter
		count: rectangles size.
	self checkStatus.
	buffer free]

{ #category : #filling }
GDIPlusGraphics >> fillRoundRectangle: aRectangle brush: aGDIPlusBrush corner: radius [
	| path |
	path := GDIPlusGraphicsPath new.
	path
		addLineFrom: aRectangle left + radius @ aRectangle top
		to: aRectangle right - (radius * 2) @ aRectangle top;
		addArc: (aRectangle right - (radius * 2) @ aRectangle top extent: radius
			* 2)
		angles: 270 @ 90;
		addLineFrom: aRectangle right @ (aRectangle top + radius)
		to: aRectangle right @ (aRectangle bottom - (radius * 2));
		addArc: (aRectangle right - (radius * 2) @ (aRectangle bottom - (radius
			* 2))
			extent: radius * 2)
		angles: 0 @ 90;
		addLineFrom: aRectangle right - (radius * 2) @ aRectangle bottom
		to: aRectangle left + radius @ aRectangle bottom;
		addArc: (aRectangle left @ (aRectangle bottom - (radius * 2))
			extent: radius * 2)
		angles: 90 @ 90;
		addLineFrom: aRectangle left @ (aRectangle bottom - (radius * 2))
		to: aRectangle left @ (aRectangle top + radius);
		addArc: (aRectangle leftTop extent: radius * 2) angles: 180 @ 90;
		closeFigure.
	self fillPath: path brush: aGDIPlusBrush]

{ #category : #private }
GDIPlusGraphics >> getHDC [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll GdipGetDC: self asParameter hdc: pointer asParameter.
	self checkStatus.
	^pointer makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> interpolationMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll
		GdipGetInterpolationMode: self asParameter
		interpolationMode: mode asParameter.
	self checkStatus.
	^mode makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> interpolationMode: mode [
	status := self dll
		GdipSetInterpolationMode: self asParameter
		interpolationMode: mode asParameter.
	self checkStatus]

{ #category : #services }
GDIPlusGraphics >> measureString: string font: font layoutRectangle: layoutRectangle [
	^self
		measureString: string
		font: font
		layoutRectangle: layoutRectangle
		stringFormat: nil]

{ #category : #services }
GDIPlusGraphics >> measureString: aString
font: aFont
layoutRectangle: aRectangle
stringFormat: aGDIPlusStringFormat [
	| rectangle codepoints lines string layout format |
	rectangle := RectF external.
	codepoints := ExternalInt32 external.
	lines := ExternalInt32 external.
	string := aString externalCopy.
	layout := RectF external from: aRectangle.
	format := aGDIPlusStringFormat externalCopy.
	status := self dll
		GdipMeasureString: self asParameter
		string: string asParameter
		length: aString size
		font: aFont asParameter
		layoutRect: layout asParameter
		stringFormat: format asParameter
		boundingBox: rectangle asParameter
		codepointsFitted: codepoints asParameter
		linesFilled: lines asParameter.
	self checkStatus.
	string free.
	layout free.
	format free.
	^GDIPlusMeasureStringResult
		boundingBox: rectangle makeLocal asRectangle
		codepoints: codepoints makeInteger
		lines: lines makeInteger]

{ #category : #accessing }
GDIPlusGraphics >> pixelOffsetMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll
		GdipGetPixelOffsetMode: self asParameter
		pixelOffsetMode: mode asParameter.
	self checkStatus.
	^mode makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> pixelOffsetMode: mode [
	status := self dll
		GdipSetPixelOffsetMode: self asParameter
		pixelOffsetMode: mode asParameter.
	self checkStatus]

{ #category : #private }
GDIPlusGraphics >> releaseHDC: hdc [
	status := self dll GdipReleaseDC: self asParameter hdc: hdc asParameter.
	self checkStatus]

{ #category : #clipping }
GDIPlusGraphics >> resetClip [
	status := self dll GdipResetClip: self asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusGraphics >> resetTransform [
	status := self dll GdipResetWorldTransform: self asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusGraphics >> rotateTransform: angle [
	self rotateTransform: angle order: MatrixOrderPrepend]

{ #category : #transforming }
GDIPlusGraphics >> rotateTransform: angle order: matrixOrder [
	| real |
	real := ExternalFloat from: angle.
	status := self dll
		GdipRotateWorldTransform: self asParameter
		angle: real asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusGraphics >> smoothingMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll
		GdipGetSmoothingMode: self asParameter
		smoothingMode: mode asParameter.
	self checkStatus.
	^mode makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusGraphics >> smoothingMode: mode [
	status := self dll
		GdipSetSmoothingMode: self asParameter
		smoothingMode: mode.
	self checkStatus]

{ #category : #transforming }
GDIPlusGraphics >> transform: matrix [
	status := self dll
		GdipSetWorldTransform: self asParameter
		matrix: matrix asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusGraphics >> translateTransform: aPoint [
	self translateTransform: aPoint x y: aPoint y]

{ #category : #transforming }
GDIPlusGraphics >> translateTransform: dx y: dy [
	self translateTransform: dx y: dy order: MatrixOrderPrepend]

{ #category : #transforming }
GDIPlusGraphics >> translateTransform: dx y: dy order: matrixOrder [
	| x y |
	x := ExternalFloat from: dx.
	y := ExternalFloat from: dy.
	status := self dll
		GdipTranslateWorldTransform: self asParameter
		dx: x asParameter
		dy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

