"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Drawer,
	#superclass : #Object,
	#instVars : [
		'converter',
		'canvas',
		'pen',
		'pencil',
		'brush',
		'backColor',
		'pencilCase',
		'dc'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
Drawer class >> canvas: aWindow [
	^self new canvas: aWindow]

{ #category : #defaults }
Drawer class >> defaultClass [
	^GDIDrawer]

{ #category : #defaults }
Drawer class >> defaultHighlightGradient [
	^LinearGradientFillType new
		startColor: ((Color red: 208 green: 239 blue: 137) changeLuminanceBy: 0.2);
		endColor: (Color red: 208 green: 239 blue: 137);
		style: #vertical]

{ #category : #examples }
Drawer class >> example [
	| bmp |
	bmp := GDIBitmap extent: 400 @ 400.
	bmp backColor: Color white.
	^bmp drawer]

{ #category : #'instance creation' }
Drawer class >> new [
	^super new initialize]

{ #category : #'instance creation' }
Drawer class >> newExtent: point [
	^self defaultClass onBitmapExtent: point]

{ #category : #'instance creation' }
Drawer class >> onBitmap: aBitmap [
	^self on: aBitmap]

{ #category : #'instance creation' }
Drawer class >> onDC: aDeviceContext [
	^self new onDC: aDeviceContext]

{ #category : #'instance creation' }
Drawer class >> onMenu: aMenuWindow [
	^self new onMenu: aMenuWindow]

{ #category : #'instance creation' }
Drawer class >> onWindow: aWindow [
	^self new onWindow: aWindow]

{ #category : #testing }
Drawer class >> supportsGradient [
	^true]

{ #category : #colors }
Drawer >> backColor [
	^backColor]

{ #category : #colors }
Drawer >> backColor: aColor [
	backColor := aColor ifNil: [Color COLOR_WINDOW]]

{ #category : #'line settings' }
Drawer >> bevelLineJoin [
	pencil bevelLineJoin]

{ #category : #accessing }
Drawer >> boundingRectangle [
	canvas isNil ifTrue: [^0 @ 0 extent: VirtualScreen current extent // 4].
	^canvas boundingRectangle]

{ #category : #private }
Drawer >> brushClass [
	^Brush]

{ #category : #colors }
Drawer >> brushColor [
	| color |
	color := brush notNil ifTrue: [brush color].
	^color ifNil: [Color COLOR_WINDOW]]

{ #category : #colors }
Drawer >> brushColor: aColor [
	self solidBrush: aColor]

{ #category : #private }
Drawer >> canvas [
	^canvas]

{ #category : #private }
Drawer >> canvas: aWindow [
	canvas := aWindow]

{ #category : #services }
Drawer >> clear [
	self clear: self boundingRectangle]

{ #category : #services }
Drawer >> clear: aRectangle [
	self fillRectangle: aRectangle color: backColor]

{ #category : #services }
Drawer >> clip: aRectangle while: aBlock [
	self subclassResponsibility]

{ #category : #colors }
Drawer >> colorAt: aPoint [
	self subclassResponsibility]

{ #category : #accessing }
Drawer >> dashPen: aSymbol color: aColor width: aNumber [
	| style |
	style := self dashStyleFor: aSymbol.
	pencil
		color: aColor;
		width: aNumber;
		dashStyle: style]

{ #category : #private }
Drawer >> dashStyleFor: aSymbol [
	self subclassResponsibility]

{ #category : #'drawing - bitmaps' }
Drawer >> draw: aBitmap ofBitmap: aRectangle at: aPoint [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> draw3DRectangle: box filled: aBoolean [
	| lighter darker inside outside left right color |
	color := self lineColor.
	lighter := color blendWith: Color white.
	darker := color blendWith: Color darkGray.
	inside := box origin + 1 corner: box right - 1 @ box bottom.
	outside := box origin corner: box right @ (box bottom - 1).
	left := box leftBottom rightAndUp: 0 @ 3.
	right := box rightBottom leftAndUp: 1 @ 3.
	self lineColor: darker.
	aBoolean
		ifTrue: [self drawRoundRectangleFilled: outside corner: 4]
		ifFalse: [self drawRoundRectangle: outside corner: 5].
	self lineColor: lighter.
	aBoolean
		ifTrue: [self drawRoundRectangleFilled: inside corner: 4]
		ifFalse: [self drawRoundRectangle: inside corner: 4].
	self
		drawLineFrom: left to: (left up: 1);
		drawLineFrom: right to: (right up: 1).
	self lineColor: color]

{ #category : #'drawing - rectangles' }
Drawer >> draw3DRectangleFilled: aRectangle [
	| color |
	color := pencil color.
	self
		drawRectangleFilled: aRectangle;
		drawBeveledRectangle: aRectangle
		lightColor: color muchLighter
		shadowColor: color muchDarker]

{ #category : #'drawing - curves' }
Drawer >> drawArc: radius
center: center
startAngle: startAngle
sweepAngle: sweepAngle [
	| box |
	box := center - radius corner: center + radius.
	self drawArc: box startAngle: startAngle sweepAngle: sweepAngle]

{ #category : #'drawing - curves' }
Drawer >> drawArc: aRectangle startAngle: startAngle sweepAngle: sweepAngle [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> drawBeveledRectangle: aRectangle lightColor: aColor shadowColor: anotherColor [
	self
		drawLineFrom: aRectangle leftTop to: aRectangle rightTop color: aColor;
		drawLineFrom: aRectangle leftTop to: aRectangle leftBottom color: aColor;
		drawLineFrom: aRectangle leftBottom + (1 @ -1)
		to: aRectangle rightBottom + (0 @ -1)
		color: anotherColor;
		drawLineFrom: aRectangle rightTop - (1 @ 0)
		to: aRectangle rightBottom - (1 @ 0)
		color: anotherColor]

{ #category : #'drawing - bitmaps' }
Drawer >> drawBitmap: aBitmap at: aPoint [
	| rectangle |
	rectangle := aPoint extent: aBitmap extent.
	self drawBitmap: aBitmap in: rectangle]

{ #category : #'drawing - bitmaps' }
Drawer >> drawBitmap: aBitmap centeredAt: aPoint [
	| origin |
	origin := aPoint - (aBitmap extent // 2).
	self drawBitmap: aBitmap at: origin]

{ #category : #'drawing - bitmaps' }
Drawer >> drawBitmap: bitmap
from: aRectangle
in: otherRectangle
opacity: byte [
	self subclassResponsibility]

{ #category : #'drawing - bitmaps' }
Drawer >> drawBitmap: aBitmap in: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircle: radius at: aPoint color: borderColor [
	self
		lineColor: borderColor;
		drawCircle: radius center: aPoint]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircle: radius center: aPoint [
	| box |
	box := aPoint - radius corner: aPoint + radius.
	self drawEllipse: box rounded]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircleFilled: radius at: center [
	| box |
	box := center - radius corner: center + radius.
	self drawEllipseFilled: box rounded]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircleFilled: radius at: aPoint color: aColor [
	self
		solidBrush: aColor;
		drawCircleFilled: radius at: aPoint]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircleFilled: radius
at: aPoint
color: fillColor
borderColor: borderColor [
	self
		lineColor: borderColor;
		drawCircleFilled: radius at: aPoint color: fillColor]

{ #category : #'drawing - ellipses' }
Drawer >> drawCircleFilled: radius at: center gradientAround: aColor [
	self
		lineColor: aColor muchDarker;
		drawCircleFilled: radius at: center color: aColor]

{ #category : #'drawing - ellipses' }
Drawer >> drawEllipse: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - ellipses' }
Drawer >> drawEllipseFilled: aRectangle [
	self fillEllipse: aRectangle; drawEllipse: aRectangle]

{ #category : #'drawing - metafiles' }
Drawer >> drawEnhMetafile: anEnhMetaFile in: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> drawFocusRectangle: aRectangle [
	| style |
	style := self lineStyle.
	self
		lineStyle: #dot;
		drawRectangle: aRectangle;
		lineStyle: style]

{ #category : #'drawing - rectangles' }
Drawer >> drawHighlightRectangle: aRectangle [
	self
		drawRectangleFilled: aRectangle
		linearGradient: self class defaultHighlightGradient
		borderColor: self backColor]

{ #category : #'drawing - icons' }
Drawer >> drawIcon: anIcon at: aPoint [
	self subclassResponsibility]

{ #category : #'drawing - bitmaps' }
Drawer >> drawImage: image at: aPoint [
	| rectangle |
	rectangle := aPoint extent: image extent.
	self drawBitmap: image in: rectangle]

{ #category : #'drawing - lines' }
Drawer >> drawLineFrom: p1 to: p2 [
	self subclassResponsibility]

{ #category : #'drawing - lines' }
Drawer >> drawLineFrom: point1 to: point2 color: aColor [
	self
		lineColor: aColor;
		drawLineFrom: point1 to: point2]

{ #category : #'drawing - lines' }
Drawer >> drawLineFrom: point1 to: point2 width: aNumber [
	self
		lineWidth: aNumber;
		drawLineFrom: point1 to: point2]

{ #category : #'drawing - lines' }
Drawer >> drawLineFrom: point1
to: point2
width: aNumber
color: aColor [
	self
		lineWidth: aNumber;
		lineColor: aColor;
		drawLineFrom: point1 to: point2]

{ #category : #'drawing - lines' }
Drawer >> drawLines: points [
	points withNextDo: [:p :q | self drawLineFrom: p to: q]]

{ #category : #'drawing - lines' }
Drawer >> drawLines: points width: aNumber color: aColor [
	self
		lineWidth: aNumber;
		lineColor: aColor;
		drawLines: points]

{ #category : #'drawing - lines' }
Drawer >> drawLineSegments: points [
	points pairsDo: [:p :q | self drawLineFrom: p to: q]]

{ #category : #'drawing - lines' }
Drawer >> drawLineSegments: points width: aNumber [
	self lineWidth: aNumber; drawLineSegments: points]

{ #category : #'drawing - metafiles' }
Drawer >> drawMetafile: metafile in: aRectangle [
	metafile isEnhMetaFile
		ifTrue: [self drawEnhMetafile: metafile in: aRectangle]
		ifFalse: [self drawWinMetafile: metafile in: aRectangle]]

{ #category : #'drawing - curves' }
Drawer >> drawPie: aRectangle angles: angles [
	self subclassResponsibility]

{ #category : #'drawing - curves' }
Drawer >> drawPieFilled: aRectangle angles: angles [
	self
		fillPie: aRectangle angles: angles;
		drawPie: aRectangle angles: angles]

{ #category : #'drawing - curves' }
Drawer >> drawPieFilled: radius angles: angles center: center [
	| box |
	box := center - radius corner: center + radius.
	self drawPieFilled: box angles: angles]

{ #category : #'drawing - polygons' }
Drawer >> drawPolygon: points [
	self subclassResponsibility]

{ #category : #'drawing - polygons' }
Drawer >> drawPolygonFilled: points [
	self fillPolygon: points; drawPolygon: points]

{ #category : #'drawing - polygons' }
Drawer >> drawPolygonFilled: points color: color [
	self solidBrush: color; drawPolygonFilled: points]

{ #category : #'drawing - polygons' }
Drawer >> drawPolygonFilled: points color: fillColor borderColor: borderColor [
	self
		lineColor: borderColor;
		drawPolygonFilled: points color: fillColor]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangle: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangle: aRectangle color: aColor [
	self lineColor: aColor; drawRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangleFilled: aRectangle [
	self fillRectangle: aRectangle; drawRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangleFilled: aRectangle gradientAround: aColor [
	| gradient |
	gradient := LinearGradientFillType new
		startColor: (aColor changeLuminanceBy: 0.4);
		endColor: (aColor changeLuminanceBy: -0.05);
		style: #vertical.
	^self
		drawRectangleFilled: aRectangle
		linearGradient: gradient
		borderColor: gradient endColor darker]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangleFilled: aRectangle linearGradient: aLinearGradientFillType [
	self
		drawRectangleFilled: aRectangle
		linearGradient: aLinearGradientFillType
		borderColor: self lineColor]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangleFilled: aRectangle linearGradient: aLinearGradientFillType borderColor: aColor [
	self ASSERT: self supportsGradient not.
	self
		solidBrush: aLinearGradientFillType averageColor;
		lineColor: aColor;
		drawRectangleFilled: aRectangle]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectangles: aCollection [
	aCollection do: [:rectangle | self drawRectangle: rectangle]]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectanglesFilled: aCollection [
	self fillRectangles: aCollection; drawRectangles: aCollection]

{ #category : #'drawing - rectangles' }
Drawer >> drawRectanglesFilled: aCollection color: aColor [
	self solidBrush: aColor; drawRectanglesFilled: aCollection]

{ #category : #'drawing - curves' }
Drawer >> drawRing: radii angles: angles center: center [
	self subclassResponsibility]

{ #category : #'drawing - curves' }
Drawer >> drawRingFilled: radii angles: angles center: center [
	self
		fillRing: radii angles: angles center: center;
		drawRing: radii angles: angles center: center]

{ #category : #'drawing - rectangles' }
Drawer >> drawRoundRectangle: aRectangle [
	self drawRoundRectangle: aRectangle corner: 6]

{ #category : #'drawing - rectangles' }
Drawer >> drawRoundRectangle: aRectangle color: fillColor borderColor: borderColor [
	pencil width: 1; color: borderColor.
	self
		lineWidth: 1;
		lineColor: borderColor;
		solidBrush: fillColor;
		drawRoundRectangleFilled: aRectangle]

{ #category : #'drawing - rectangles' }
Drawer >> drawRoundRectangle: aRectangle corner: radius [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> drawRoundRectangleFilled: aRectangle [
	self drawRoundRectangleFilled: aRectangle corner: 6]

{ #category : #'drawing - rectangles' }
Drawer >> drawRoundRectangleFilled: aRectangle corner: radius [
	self
		fillRoundRectangle: aRectangle corner: radius;
		drawRoundRectangle: aRectangle corner: radius]

{ #category : #'drawing - rectangles' }
Drawer >> drawSelectionRectangle: aRectangle [
	self
		drawRectangleFilled: aRectangle
		linearGradient: self class defaultSelectionGradient
		borderColor: self class gradientBorderColor]

{ #category : #'drawing - polygons' }
Drawer >> drawStarFilled: radius
innerRadius: innerRadius
points: aNumber
at: center [
	| sweep angles points |
	sweep := 180.0 / aNumber.
	angles := (0 to: 360 by: sweep)
		collect: [:s | s + 90 \\ 360]
		in: OrderedCollection new.
	points := angles withIndexCollect: [:a :i | | r x y |
		r := i even ifTrue: [radius] ifFalse: [innerRadius].
		x := a degreesToRadians cos * r.
		y := a degreesToRadians sin * r.
		(x + center x) rounded @ (y + center y) rounded].
	self drawPolygonFilled: points]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString at: aPoint [
	self subclassResponsibility]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString at: aPoint alignment: aSymbol [
	self
		stringAlignment: aSymbol;
		drawString: aString at: aPoint]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
at: aPoint
font: aFont
color: aColor
alignment: aSymbol [
	self
		font: aFont;
		stringAlignment: aSymbol;
		textColor: aColor;
		drawString: aString at: aPoint]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString centeredAt: aPoint [
	self
		stringAlignment: #center;
		drawString: aString at: aPoint]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString centeredIn: aRectangle [
	self
		stringAlignment: #center;
		drawString: aString in: aRectangle]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
font: aFont
color: aColor
at: aPoint
alignment: aSymbol [
	self
		stringAlignment: aSymbol;
		solidBrush: aColor;
		font: aFont;
		drawString: aString at: aPoint]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
font: aFont
color: aColor
centeredAt: aPoint [
	self
		solidBrush: aColor;
		font: aFont;
		drawString: aString centeredAt: aPoint]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
font: aFont
color: aColor
centeredIn: aRectangle [
	self
		solidBrush: aColor;
		font: aFont;
		drawString: aString centeredIn: aRectangle]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
font: aFont
color: aColor
in: aRectangle
alignment: aSymbol
angle: angle [
	self
		font: aFont;
		textColor: aColor;
		drawString: aString
		in: aRectangle
		alignment: aSymbol
		angle: angle]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString in: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString
in: aRectangle
alignment: aSymbol
angle: angle [
	self stringAlignment: aSymbol.
	self ASSERT: angle = 0.
	self drawString: aString in: aRectangle]

{ #category : #'drawing - strings' }
Drawer >> drawString: aString in: aRectangle format: stringFormat [
	]

{ #category : #'drawing - metafiles' }
Drawer >> drawWinMetafile: anEnhMetaFile in: aRectangle [
	self subclassResponsibility]

{ #category : #services }
Drawer >> erase [
	self clear]

{ #category : #'drawing - ellipses' }
Drawer >> fillEllipse: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - curves' }
Drawer >> fillPie: aRectangle angles: angles [
	self subclassResponsibility]

{ #category : #'drawing - polygons' }
Drawer >> fillPolygon: points [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> fillRectangle: aRectangle [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> fillRectangle: aRectangle color: aColor [
	self solidBrush: aColor; fillRectangle: aRectangle]

{ #category : #'drawing - rectangles' }
Drawer >> fillRectangles: aCollection [
	aCollection do: [:rectangle | self fillRectangle: rectangle]]

{ #category : #'drawing - rectangles' }
Drawer >> fillRectangles: aCollection color: aColor [
	self solidBrush: aColor; fillRectangles: aCollection]

{ #category : #'drawing - curves' }
Drawer >> fillRing: radii angles: angles center: center [
	self subclassResponsibility]

{ #category : #'drawing - rectangles' }
Drawer >> fillRoundRectangle: aRectangle corner: aNumber [
	self subclassResponsibility]

{ #category : #services }
Drawer >> fillWithColor: aColor [
	self backColor: aColor; clear]

{ #category : #accessing }
Drawer >> font [
	^pen font ifNil: [GDIFont defaultTextFont]]

{ #category : #fonts }
Drawer >> font: aFont [
	pen font: aFont]

{ #category : #brushes }
Drawer >> hatchBrush: style foreColor: aColor backColor: anotherColor [
	brush beHatch: style foreColor: aColor backColor: anotherColor]

{ #category : #private }
Drawer >> hatchStyleFor: aSymbol [
	self subclassResponsibility]

{ #category : #initialization }
Drawer >> initialize [
	super initialize.
	pen := self penClass new.
	pencil := self pencilClass new.
	brush := self brushClass new.
	pencilCase := PencilCase for: self.
	backColor := Color COLOR_WINDOW]

{ #category : #initialization }
Drawer >> initializeConverter [
	self subclassResponsibility]

{ #category : #services }
Drawer >> invalidateHandles [
	self subclassResponsibility]

{ #category : #testing }
Drawer >> isAlive [
	self subclassResponsibility]

{ #category : #colors }
Drawer >> lineColor [
	^pencil color]

{ #category : #colors }
Drawer >> lineColor: aColor [
	pencil color: aColor]

{ #category : #'line settings' }
Drawer >> lineStyle [
	^pencil dashStyle]

{ #category : #'line settings' }
Drawer >> lineStyle: aSymbol [
	pencil dashStyle: aSymbol]

{ #category : #'line settings' }
Drawer >> lineWidth [
	^pencil width]

{ #category : #'line settings' }
Drawer >> lineWidth: pixels [
	pencil width = pixels ifTrue: [^self].
	pencil width: pixels]

{ #category : #'line settings' }
Drawer >> miterLineJoin [
	pencil miterLineJoin]

{ #category : #accessing }
Drawer >> onBitmap: aBitmap [
	self on: aBitmap]

{ #category : #accessing }
Drawer >> onDC: aDeviceContext [
	self subclassResponsibility]

{ #category : #accessing }
Drawer >> onWindow: aWindow [
	^self
		canvas: aWindow;
		font: aWindow font;
		backColor: aWindow backColor;
		lineColor: aWindow foreColor;
		textColor: aWindow foreColor]

{ #category : #accessing }
Drawer >> pencilCase: aPencilCase [
	pencilCase := aPencilCase]

{ #category : #private }
Drawer >> pencilClass [
	^Pencil]

{ #category : #private }
Drawer >> penClass [
	^Pen]

{ #category : #'line settings' }
Drawer >> roundLineJoin [
	pencil roundLineJoin]

{ #category : #coordinates }
Drawer >> scale [
	^converter isNil ifTrue: [1 @ 1] ifFalse: [converter scale]]

{ #category : #coordinates }
Drawer >> scale: aPoint [
	converter isNil ifTrue: [self initializeConverter].
	converter scale: aPoint asPoint]

{ #category : #private }
Drawer >> scaledOf: anInteger [
	^self scale x * anInteger]

{ #category : #'scaled & tranlated' }
Drawer >> scaleX: object [
	^converter isNil ifTrue: [object] ifFalse: [converter scaleX: object]]

{ #category : #'scaled & tranlated' }
Drawer >> scaleY: object [
	^converter isNil ifTrue: [object] ifFalse: [converter scaleY: object]]

{ #category : #startup }
Drawer >> sessionStartup [
	self invalidateDC.
	pencilCase removeAll]

{ #category : #brushes }
Drawer >> solidBrush: aColor [
	brush beSolid; color: aColor]

{ #category : #accessing }
Drawer >> solidPen: aColor width: aNumber [
	self lineStyle: #solid.
	pencil color: aColor; width: aNumber]

{ #category : #accessing }
Drawer >> stringAlignment [
	^pen alignment]

{ #category : #accessing }
Drawer >> stringAlignment: aSymbol [
	pen alignment: aSymbol]

{ #category : #testing }
Drawer >> supportsCachedBitmaps [
	^false]

{ #category : #testing }
Drawer >> supportsGradient [
	^self class supportsGradient]

{ #category : #colors }
Drawer >> textColor [
	^pen color ifNil: [Color defaultTextColor]]

{ #category : #colors }
Drawer >> textColor: aColor [
	pen color: aColor]

{ #category : #services }
Drawer >> useAntiAliasSmoothing [
	]

{ #category : #brushes }
Drawer >> useBrush: aBrush while: aBlock [
	| prev |
	prev := brush.
	brush := aBrush.
	aBlock ensure: [brush := prev]]

{ #category : #services }
Drawer >> useCanvas: canvasObject while: aBlock [
	| original |
	original := canvas.
	canvas := canvasObject.
	aBlock ensure: [canvas := original]]

{ #category : #services }
Drawer >> useDC: dcHandle while: aBlock [
	self subclassResponsibility]

{ #category : #services }
Drawer >> usePencil: aPencil while: aBlock [
	| prev |
	prev := pencil.
	pencil := aPencil.
	aBlock ensure: [pencil := prev]]

{ #category : #services }
Drawer >> widthOfString: aString [
	self subclassResponsibility]

