"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusDrawer,
	#superclass : #Drawer,
	#instVars : [
		'graphics',
		'stringFormat',
		'clipRegion'
	],
	#category : #GDIPlus
}

{ #category : #services }
GDIPlusDrawer class >> drawRectangleFilled: aRectangle gradientAround: aColor [
	"
	self drawRectangleFilled: (10 @ 10 extent: 100 @ 21) gradientAround: Color cyan
	"
	| gradient |
	gradient := LinearGradientFillType new
		startColor: (aColor changeLuminanceBy: 0.4);
		endColor: (aColor changeLuminanceBy: -0.05);
		style: #vertical.
	^self
		drawRectangleFilled: aRectangle
		linearGradient: gradient
		borderColor: gradient endColor darker]

{ #category : #services }
GDIPlusDrawer class >> drawRectangleFilled: aRectangle linearGradient: aLinearGradientFillType borderColor: aColor [
	"
	self 
		drawRectangleFilled: (10 @ 10 extent: 100 @ 21)
		linearGradient: (LinearGradientFillType new startColor: Color yellow; endColor: Color red)
		borderColor: Color darkRed
	"
	| drawer |
	aRectangle isEmpty ifTrue: [^self].
	drawer := GDIPlusDrawer onBitmapExtent: aRectangle extent.
	^drawer
		drawRectangleFilled: (0 @ 0 extent: aRectangle extent)
		linearGradient: aLinearGradientFillType
		borderColor: aColor;
		asBitmap]

{ #category : #defaults }
GDIPlusDrawer class >> gradientBorderColor [
	^Color red: 154 green: 223 blue: 254]

{ #category : #accessing }
GDIPlusDrawer class >> minFontSize [
	^6]

{ #category : #'instance creation' }
GDIPlusDrawer class >> new [
	^super new initialize]

{ #category : #'instance creation' }
GDIPlusDrawer class >> newExtent: point [
	^self onBitmapExtent: point]

{ #category : #'instance creation' }
GDIPlusDrawer class >> on: bitmap [
	^self new on: bitmap]

{ #category : #'instance creation' }
GDIPlusDrawer class >> onBitmapExtent: aPoint [
	^self on: (GDIPlusBitmap extent: aPoint)]

{ #category : #conversion }
GDIPlusDrawer >> asBitmap [
	^canvas asBitmap]

{ #category : #private }
GDIPlusDrawer >> brush: aGDIPlusBrush [
	brush notNil ifTrue: [brush release].
	brush := aGDIPlusBrush]

{ #category : #private }
GDIPlusDrawer >> brushClass [
	^GDIPlusSolidBrush]

{ #category : #services }
GDIPlusDrawer >> clear [
	graphics clear: backColor]

{ #category : #accessing }
GDIPlusDrawer >> clearClipRegion [
	clipRegion notNil ifTrue: [clipRegion makeInfinite].
	graphics resetClip]

{ #category : #services }
GDIPlusDrawer >> clip: aRectangle while: aBlock [
	self clipRectangle: aRectangle.
	aBlock ensure: [self clearClipRegion]]

{ #category : #accessing }
GDIPlusDrawer >> clipRectangle: aRectangle [
	clipRegion isNil ifTrue: [
		clipRegion := GDIPlusRegion fromRectangle: aRectangle.
		graphics clipRegion: clipRegion.
		^self].
	clipRegion rectangle: aRectangle]

{ #category : #private }
GDIPlusDrawer >> dashStyleFor: aSymbol [
	aSymbol == #solid ifTrue: [^DashStyleSolid].
	aSymbol == #dash ifTrue: [^DashStyleDash].
	aSymbol == #dot ifTrue: [^DashStyleDot].
	aSymbol == #dashdot ifTrue: [^DashStyleDashDot].
	aSymbol == #dashdotdot ifTrue: [^DashStyleDashDotDot].
	self ASSERT: false.
	^DashStyleSolid]

{ #category : #'drawing - bitmaps' }
GDIPlusDrawer >> draw: aBitmap ofBitmap: aRectangle at: aPoint [
	graphics drawImage: aBitmap asGDIPlusBitmap from: aRectangle at: aPoint]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> draw3DCircleFilled: radius at: center [
	self
		drawCircleFilled: radius at: center;
		lineColor: pencil color muchLighter;
		drawArc: radius
		center: center
		startAngle: 135
		sweepAngle: 180;
		lineColor: pencil color muchDarker;
		drawArc: radius
		center: center
		startAngle: -45
		sweepAngle: 180]

{ #category : #'drawing - polygons' }
GDIPlusDrawer >> draw3DRhombFilled: center height: height width: width [
	| dh dw polygon |
	dh := height // 2.
	dw := width // 2.
	polygon := {center x @ (center y - dh). center x - dw @ center y.
		center x @ (center y + dh). center x + dw @ center y}.
	self
		drawPolygonFilled: polygon;
		drawLines: polygon allButLast
		width: 1
		color: pencil color muchLighter;
		drawLines: {polygon first. polygon last. polygon third}
		width: 1
		color: pencil color muchDarker]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> drawArc: aRectangle startAngle: startAngle sweepAngle: sweepAngle [
	graphics
		drawArc: aRectangle
		pen: pencil
		startAngle: startAngle
		sweepAngle: sweepAngle]

{ #category : #'drawing - lines' }
GDIPlusDrawer >> drawArrowPointing: aPoint
direction: direction
length: length
width: width [
	| normal base left right |
	normal := direction normal.
	base := aPoint - (direction * length).
	left := width // 2 * normal + base.
	right := base - (width // 2 * normal).
	self drawPolygonFilled: {aPoint. left rounded. right rounded. aPoint}]

{ #category : #'drawing - lines' }
GDIPlusDrawer >> drawArrowPointing: aPoint
direction: direction
length: length
width: width
color: fillColor [
	self
		solidBrush: fillColor;
		drawArrowPointing: aPoint
		direction: direction
		length: length
		width: width]

{ #category : #'drawing - bitmaps' }
GDIPlusDrawer >> drawBitmap: aBitmap at: aPoint [
	graphics drawImage: aBitmap asGDIPlusBitmap at: aPoint]

{ #category : #'drawing - bitmaps' }
GDIPlusDrawer >> drawBitmap: aBitmap centeredAt: aPoint [
	super drawBitmap: aBitmap asGDIPlusBitmap centeredAt: aPoint]

{ #category : #'drawing - bitmaps' }
GDIPlusDrawer >> drawBitmap: aBitmap in: aRectangle [
	self drawImage: aBitmap asGDIPlusBitmap in: aRectangle]

{ #category : #'drawing - ellipses' }
GDIPlusDrawer >> drawCircleFilled: radius at: center gradientAround: aColor [
	| box path |
	box := center extentFromCenter: radius * 2.
	path := GDIPlusGraphicsPath new addEllipse: box.
	brush := GDIPlusPathGradientBrush fromPath: path.
	brush
		centerColor: aColor muchLighter asARGBColor;
		surroundColor: aColor asARGBColor.
	graphics fillEllipse: box brush: brush.
	self lineColor: aColor muchDarker; drawEllipse: box]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> drawCurve: points [
	graphics drawCurve: points pen: pencil]

{ #category : #'drawing - ellipses' }
GDIPlusDrawer >> drawEllipse: aRectangle [
	graphics drawEllipse: aRectangle pen: pencil]

{ #category : #'drawing - metafiles' }
GDIPlusDrawer >> drawEnhMetafile: anEnhMetaFile in: aRectangle [
	self drawImage: anEnhMetaFile asGDIPlusMetafile in: aRectangle]

{ #category : #'drawing - images' }
GDIPlusDrawer >> drawImage: aGDIPlusImage in: aRectangle [
	graphics
		drawImage: aGDIPlusImage
		at: aRectangle origin
		width: aRectangle width
		height: aRectangle height]

{ #category : #'drawing - lines' }
GDIPlusDrawer >> drawLineFrom: point1 to: point2 [
	graphics drawLineFrom: point1 to: point2 pen: pencil]

{ #category : #'drawing - lines' }
GDIPlusDrawer >> drawLines: points [
	graphics drawLines: points pen: pencil]

{ #category : #'drawing - lines' }
GDIPlusDrawer >> drawLineSegments: points [
	| path |
	self ASSERT: points size even.
	path := GDIPlusGraphicsPath new.
	points pairsDo: [:a :b | path addLineFrom: a to: b; closeFigure].
	graphics drawPath: path pen: pencil]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> drawPie: aRectangle angles: angles [
	graphics
		drawPie: aRectangle
		pen: pencil
		startAngle: angles x
		sweepAngle: angles y]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> drawPie: radius angles: angles center: center [
	| box |
	box := center - radius corner: center + radius.
	self drawPie: box rounded angles: angles]

{ #category : #'drawing - polygons' }
GDIPlusDrawer >> drawPolygon: points [
	graphics drawPolygon: points pen: pencil]

{ #category : #'drawing - polygons' }
GDIPlusDrawer >> drawPolygons: aCollection [
	| path |
	path := GDIPlusGraphicsPath new.
	aCollection do: [:points | path addPolygon: points].
	graphics drawPath: path pen: pencil]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> drawRectangle: aRectangle [
	graphics drawRectangle: aRectangle pen: pencil]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> drawRectangleFilled: aRectangle linearGradient: aLinearGradientFillType borderColor: aColor [
	| box |
	box := aRectangle origin corner: aRectangle corner - 1.
	box isEmpty ifTrue: [^self].
	self
		fillRectangle: box linearGradient: aLinearGradientFillType;
		drawRectangle: box color: aColor]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> drawRectangles: aCollection [
	graphics drawRectangles: aCollection pen: pencil]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> drawRing: radii angles: angles center: center [
	| path |
	path := self ringPath: radii angles: angles center: center.
	graphics drawPath: path pen: pencil]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawRoundedString: aString
font: aFont
backColor: bColor
centeredAt: aPoint [
	self
		drawRoundedString: aString
		font: aFont
		color: Color black
		backColor: bColor
		centeredAt: aPoint]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawRoundedString: aString
font: aFont
color: aColor
backColor: bColor
centeredAt: aPoint [
	| height width box |
	height := aFont height.
	width := aFont stringWidth: aString.
	box := Rectangle
		center: aPoint
		extent: (width * 1.5 max: 20) @ (height * 1.25).
	self
		drawRoundRectangle: box rounded color: bColor borderColor: Color black;
		drawString: aString font: aFont color: aColor centeredAt: box center]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> drawRoundRectangle: aRectangle corner: aNumber [
	graphics drawRoundRectangle: aRectangle pen: pencil corner: aNumber]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString at: aPoint [
	| origin box |
	origin := aPoint.
	pen verticalAlignment == #baseline
		ifTrue: [origin := aPoint up: self font ascent ceiling].
	box := origin extent: 0.
	self drawString: aString in: box]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString at: aPoint angle: angle [
	| box |
	box := aPoint extent: 0.
	self drawString: aString in: box angle: angle]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString
font: aFont
color: aColor
baseAt: aPoint [
	self
		stringAlignment: #left;
		textColor: aColor;
		font: aFont;
		drawString: aString at: aPoint]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString
font: aFont
color: aColor
in: aRectangle
origin: aPoint
alignment: aSymbol
angle: aNumber [
	self
		font: aFont;
		resizeFontToDrawString: aString in: aRectangle angle: 0;
		textColor: aColor;
		stringAlignment: aSymbol.
	graphics translateTransform: aPoint; rotateTransform: aNumber.
	self drawString: aString in: aRectangle.
	graphics resetTransform]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString in: aRectangle [
	graphics
		drawString: aString
		font: self font
		layoutRectangle: aRectangle
		stringFormat: stringFormat
		brush: self textBrush]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString
in: aRectangle
alignment: aSymbol
angle: angle [
	self stringAlignment: aSymbol.
	angle = 0 ifTrue: [self drawString: aString in: aRectangle] ifFalse: [
		self
			resizeFontToDrawString: aString in: aRectangle angle: angle;
			drawString: aString in: aRectangle angle: angle]]

{ #category : #'drawing - strings' }
GDIPlusDrawer >> drawString: aString in: aRectangle angle: angle [
	| box |
	box := aRectangle rotatedBy: angle negated.
	graphics
		rotateTransform: angle;
		drawString: aString
		font: self font
		layoutRectangle: box
		stringFormat: stringFormat
		brush: self textBrush.
	graphics resetTransform]

{ #category : #'drawing - metafiles' }
GDIPlusDrawer >> drawWinMetafile: anEnhMetaFile in: aRectangle [
	self drawImage: anEnhMetaFile asGDIPlusMetafile in: aRectangle]

{ #category : #'drawing - ellipses' }
GDIPlusDrawer >> fillEllipse: aRectangle [
	graphics fillEllipse: aRectangle rounded brush: brush]

{ #category : #accessing }
GDIPlusDrawer >> fillFormat: aChartFillFormat rectangle: aRectangle [
	| rectangle |
	aChartFillFormat isSolid ifTrue: [^self solidBrush: aChartFillFormat color].
	aChartFillFormat isHatch ifTrue: [
		^self
			hatchBrush: aChartFillFormat style
			foreColor: aChartFillFormat foreColor
			backColor: aChartFillFormat backColor].
	aChartFillFormat isLinearGradient ifTrue: [
		rectangle := aRectangle expandBy: 2.
		^self
			linearGradientBrush: aChartFillFormat style
			rectangle: rectangle
			startColor: aChartFillFormat startColor
			endColor: aChartFillFormat endColor].
	aChartFillFormat isRadialGradient ifTrue: [
		^self
			radialGradientBrush: (aRectangle width max: aRectangle height)
			center: aRectangle center
			startColor: aChartFillFormat startColor
			endColor: aChartFillFormat endColor].
	self ASSERT: false]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> fillPie: aRectangle angles: angles [
	graphics
		fillPie: aRectangle
		brush: brush
		startAngle: angles x
		sweepAngle: angles y]

{ #category : #'drawing - polygons' }
GDIPlusDrawer >> fillPolygon: points [
	graphics fillPolygon: points brush: brush]

{ #category : #'drawing - polygons' }
GDIPlusDrawer >> fillPolygons: aCollection [
	| path |
	path := GDIPlusGraphicsPath new.
	aCollection do: [:points | path addPolygon: points].
	graphics fillPath: path brush: brush]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRectangle: aRectangle [
	graphics
		fillRectangleAt: aRectangle leftTop
		width: aRectangle width + 1
		height: aRectangle height + 1
		brush: brush]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRectangle: aRectangle angle: angle [
	graphics rotateTransform: angle.
	self fillRectangle: aRectangle.
	graphics resetTransform]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRectangle: aRectangle linearGradient: aLinearGradientFillType [
	aRectangle area = 0 ifTrue: [^self].
	self
		linearGradientBrush: aLinearGradientFillType style
		rectangle: aRectangle
		startColor: aLinearGradientFillType startColor
		endColor: aLinearGradientFillType endColor;
		fillRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRectangle: aRectangle
linearGradient: style
startColor: startColor
endColor: endColor [
	self
		linearGradientBrush: style
		rectangle: aRectangle
		startColor: startColor
		endColor: endColor;
		fillRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRectangles: aCollection [
	graphics fillRectangles: aCollection brush: brush]

{ #category : #'drawing - curves' }
GDIPlusDrawer >> fillRing: radii angles: angles center: center [
	| path |
	path := self ringPath: radii angles: angles center: center.
	graphics fillPath: path brush: brush]

{ #category : #'drawing - rectangles' }
GDIPlusDrawer >> fillRoundRectangle: aRectangle corner: aNumber [
	graphics fillRoundRectangle: aRectangle brush: brush corner: aNumber]

{ #category : #accessing }
GDIPlusDrawer >> font [
	^super font asGDIPlusFont]

{ #category : #accessing }
GDIPlusDrawer >> font: aFont [
	super font: aFont asGDIPlusFont]

{ #category : #private }
GDIPlusDrawer >> gradientModeFor: aSymbol [
	aSymbol == #horizontal ifTrue: [^LinearGradientModeHorizontal].
	aSymbol == #vertical ifTrue: [^LinearGradientModeVertical].
	aSymbol == #bdiagonal ifTrue: [^LinearGradientModeBackwardDiagonal].
	aSymbol == #fdiagonal ifTrue: [^LinearGradientModeForwardDiagonal].
	self ASSERT: false]

{ #category : #brushes }
GDIPlusDrawer >> hatchBrush: aSymbol foreColor: foreColor backColor: backgroundColor [
	| b style |
	style := self hatchStyleFor: aSymbol.
	b := GDIPlusHatchBrush
		style: style
		foreColor: foreColor
		backColor: backgroundColor.
	self brush: b]

{ #category : #private }
GDIPlusDrawer >> hatchStyleFor: aSymbol [
	aSymbol == #horizontal ifTrue: [^HatchStyleHorizontal].
	aSymbol == #vertical ifTrue: [^HatchStyleVertical].
	aSymbol == #cross ifTrue: [^HatchStyleCross].
	aSymbol == #diagcross ifTrue: [^HatchStyleDiagonalCross].
	aSymbol == #bdiagonal ifTrue: [^HatchStyleBackwardDiagonal].
	aSymbol == #fdiagonal ifTrue: [^HatchStyleForwardDiagonal].
	self ASSERT: false]

{ #category : #initialization }
GDIPlusDrawer >> initializeConverter [
	converter := GDIPlusMatrix new]

{ #category : #accessing }
GDIPlusDrawer >> invalidateDC [
	graphics := nil]

{ #category : #testing }
GDIPlusDrawer >> isValid [
	^graphics notNil and: [graphics isValid]]

{ #category : #private }
GDIPlusDrawer >> lineAlignmentFor: aSymbol [
	aSymbol == #center ifTrue: [^StringAlignmentCenter].
	^StringAlignmentNear]

{ #category : #brushes }
GDIPlusDrawer >> linearGradientBrush: aSymbol
rectangle: rectangle
startColor: startColor
endColor: endColor [
	| mode b |
	mode := self gradientModeFor: aSymbol.
	b := GDIPlusLinearGradientBrush
		rectangle: rectangle
		startColor: startColor
		endColor: endColor
		mode: mode.
	b isNil ifTrue: [b := GDIPlusSolidBrush color: startColor].
	self brush: b]

{ #category : #accessing }
GDIPlusDrawer >> lineFormat: aChartLineFormat [
	self
		dashPen: aChartLineFormat style
		color: aChartLineFormat color
		width: aChartLineFormat width]

{ #category : #accessing }
GDIPlusDrawer >> lineStyle: aSymbol [
	| style |
	style := self dashStyleFor: aSymbol.
	super lineStyle: style]

{ #category : #accessing }
GDIPlusDrawer >> minFontSize [
	^self class minFontSize]

{ #category : #accessing }
GDIPlusDrawer >> noSmoothing [
	graphics smoothingMode: SmoothingModeNone]

{ #category : #accessing }
GDIPlusDrawer >> on: aBitmap [
	canvas := aBitmap asGDIPlusBitmap.
	graphics := canvas graphics.
	graphics
		compositingQuality: CompositingQualityGammaCorrected;
		smoothingMode: SmoothingModeAntiAlias]

{ #category : #accessing }
GDIPlusDrawer >> onDC: aDeviceContext [
	graphics := GDIPlusGraphics fromHDC: aDeviceContext asParameter.
	graphics
		compositingQuality: CompositingQualityDefault;
		smoothingMode: SmoothingModeNone;
		pixelOffsetMode: PixelOffsetModeNone;
		interpolationMode: InterpolationModeNearestNeighbor]

{ #category : #private }
GDIPlusDrawer >> pencilClass [
	^GDIPlusPen]

{ #category : #'drawing - private' }
GDIPlusDrawer >> preDraw [
	graphics
		compositingQuality: CompositingQualityGammaCorrected;
		smoothingMode: SmoothingModeAntiAlias]

{ #category : #brushes }
GDIPlusDrawer >> radialGradientBrush: radius
center: aPoint
startColor: startColor
endColor: endColor [
	| b |
	b := GDIPlusPathGradientBrush
		radial: radius
		center: aPoint
		centerColor: startColor
		surroundColor: endColor.
	b isNil ifTrue: [b := GDIPlusSolidBrush color: startColor].
	self brush: b]

{ #category : #services }
GDIPlusDrawer >> release [
	graphics release]

{ #category : #private }
GDIPlusDrawer >> resizeFontToDrawString: aString in: aRectangle angle: angle [
	| min font width available size height |
	min := self minFontSize.
	font := self font.
	width := font stringWidth: aString.
	available := (angle = 90 or: [angle = 270])
		ifTrue: [aRectangle height]
		ifFalse: [aRectangle width].
	width > available ifTrue: [
		size := available / width * font pointSize max: min.
		font := font resizedTo: size floor].
	height := font height.
	available := (angle = 90 or: [angle = 270])
		ifTrue: [aRectangle width]
		ifFalse: [aRectangle height].
	height > available ifTrue: [
		size := available / height * font pointSize max: min.
		font := font resizedTo: size floor]]

{ #category : #private }
GDIPlusDrawer >> ringPath: radii angles: angles center: center [
	| path outer inner angle p1 p2 |
	path := GDIPlusGraphicsPath new.
	outer := center - radii y corner: center + radii y.
	inner := center - radii x corner: center + radii x.
	angle := angles x degreesToRadians.
	p1 := (angle cos @ angle sin * radii y + center) rounded.
	p2 := (angle cos @ angle sin * radii x + center) rounded.
	path
		addArc: outer angles: angles;
		addArc: inner angles: angles x + angles y @ angles y negated;
		addLineFrom: p2 to: p1.
	^path]

{ #category : #brushes }
GDIPlusDrawer >> solidBrush: aColor [
	| b |
	brush isSolidBrush ifTrue: [
		brush color: aColor.
		^self].
	b := GDIPlusSolidBrush color: aColor.
	self brush: b]

{ #category : #private }
GDIPlusDrawer >> stringAlignment: aSymbol [
	| alignment |
	super stringAlignment: aSymbol.
	stringFormat isNil ifTrue: [stringFormat := GDIPlusStringFormat new].
	alignment := self stringAlignmentFor: aSymbol.
	stringFormat alignment: alignment.
	alignment := self lineAlignmentFor: aSymbol.
	stringFormat lineAlignment: alignment]

{ #category : #private }
GDIPlusDrawer >> stringAlignmentFor: aSymbol [
	aSymbol == #topLeft ifTrue: [^StringAlignmentNear].
	aSymbol == #center ifTrue: [^StringAlignmentCenter].
	aSymbol == #left ifTrue: [^StringAlignmentNear].
	aSymbol == #right ifTrue: [^StringAlignmentFar].
	self ASSERT: false.
	^StringAlignmentNear]

{ #category : #testing }
GDIPlusDrawer >> supportsCachedBitmaps [
	^true]

{ #category : #accessing }
GDIPlusDrawer >> textBrush [
	^GDIPlusSolidBrush color: self textColor]

{ #category : #services }
GDIPlusDrawer >> useDC: dcHandle while: aBlock [
	| original |
	original := graphics.
	self onDC: dcHandle.
	[aBlock value] ensure: [graphics := original]]

{ #category : #accessing }
GDIPlusDrawer >> window: aWindow [
	graphics := GDIPlusGraphics fromHWND: aWindow]

