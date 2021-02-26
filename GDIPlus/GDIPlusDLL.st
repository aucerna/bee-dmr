"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusDLL,
	#superclass : #ExternalLibrary,
	#type : #bytes,
	#category : #GDIPlus
}

{ #category : #parsing }
GDIPlusDLL class >> h [
	^SmalltalkSession current devDirectory \ 'gdiplusflat.h']

{ #category : #accessing }
GDIPlusDLL class >> moduleName [
	^'GDIPlus']

{ #category : #accessing }
GDIPlusDLL class >> open [
	^super open startUp; yourself]

{ #category : #accessing }
GDIPlusDLL class >> script [
	"
	GDIPlusDLL script
	"
	GDIPlusDLL methodDictionary values
		do: [:cm | | ast comment formatted cmt source |
			ast := cm parseTree.
			comment := ast selectorNode comment.
			comment notNil ifTrue: [
				ast selectorNode comment: nil.
				cmt := comment source reject: [:c | c = $"].
				formatted := '
"
' , cmt inOneLine , '
"'].
			formatted isNil ifTrue: [formatted := ''].
			source := ast format trimBlanks , formatted.
			cm project changes compile: source in: cm classBinding]]

{ #category : #private }
GDIPlusDLL class >> typedefTable [
	^#(
		#('GpStatus' #int)
		#('GpRegion' #ulong)
		#('GpGraphics' #ulong)
		#('GpRectF' #RectF)
		#('WarpMode' #ulong)
		#('WrapMode' #ulong)
		#('InterpolationMode' #ulong)
		#('PixelOffsetMode' #ulong)
		#('SmoothingMode' #ulong)
		#('LinearGradientMode' #ulong)
		#('CombineMode' #ulong)
		#('CompositingMode' #ulong)
		#('CompositingQuality' #ulong)
		#('EmfPlusRecordType' #long)
		#('ColorAdjustType' #long)
		#('EmfType' #long)
		#('PROPID' #ulong)
		#('GraphicsState' #long)
		#('MetafileFrameUnit' #long)
		#('Status' #long)
		#('StringAlignment' #long)
		#('GraphicsContainer' #ulong)
		#('PixelFormat' #ulong)
		#('DitherType' #ulong)
		#('PaletteType' #ulong)
		#('HistogramFormat' #ulong)
		#('RotateFlipType' #ulong)
		#('ColorMatrixFlags' #long)
		#('ColorChannelFlags' #long)
		#('StringDigitSubstitute' #long)
		#('StringTrimming' #long)
		#('TextRenderingHint' #long)
		#('PointF' #PointF)
		#('IStream' #pointer)
		#('DebugEventProc' #callback)
	)]

{ #category : #other }
GDIPlusDLL >> close [
	self GdiplusShutdown: (self propertyAt: #starUpToken) asParameter.
	^super close]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathArc: path
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipAddPathArc>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathArc(GpPath *path, REAL x, REAL y, REAL width, REAL height,
						REAL startAngle, REAL sweepAngle)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathArcI: path
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipAddPathArcI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
	GdipAddPathArcI(GpPath *path, INT x, INT y, INT width, INT height,
						REAL startAngle, REAL sweepAngle)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathBezier: path
x1: x1
y1: y1
x2: x2
y2: y2
x3: x3
y3: y3
x4: x4
y4: y4 [
	<ulong: GdipAddPathBezier>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathBezier(GpPath *path, REAL x1, REAL y1, REAL x2, REAL y2,
						REAL x3, REAL y3, REAL x4, REAL y4)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathBezierI: path
x1: x1
y1: y1
x2: x2
y2: y2
x3: x3
y3: y3
x4: x4
y4: y4 [
	<ulong: GdipAddPathBezierI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathBezierI(GpPath *path, INT x1, INT y1, INT x2, INT y2,
						INT x3, INT y3, INT x4, INT y4)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathBeziers: path points: points count: count [
	<ulong: GdipAddPathBeziers>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathBeziers(GpPath *path, GDIPCONST GpPointF *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathBeziersI: path points: points count: count [
	<ulong: GdipAddPathBeziersI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathBeziersI(GpPath *path, GDIPCONST GpPoint *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathClosedCurve: path points: points count: count [
	<ulong: GdipAddPathClosedCurve>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathClosedCurve(GpPath *path, GDIPCONST GpPointF *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathClosedCurve2: path
points: points
count: count
tension: tension [
	<ulong: GdipAddPathClosedCurve2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathClosedCurve2(GpPath *path, GDIPCONST GpPointF *points, INT count,
								REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathClosedCurve2I: path
points: points
count: count
tension: tension [
	<ulong: GdipAddPathClosedCurve2I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathClosedCurve2I(GpPath *path, GDIPCONST GpPoint *points, INT count,
								REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathClosedCurveI: path points: points count: count [
	<ulong: GdipAddPathClosedCurveI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathClosedCurveI(GpPath *path, GDIPCONST GpPoint *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurve: path points: points count: count [
	<ulong: GdipAddPathCurve>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurve(GpPath *path, GDIPCONST GpPointF *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurve2: path
points: points
count: count
tension: tension [
	<ulong: GdipAddPathCurve2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurve2(GpPath *path, GDIPCONST GpPointF *points, INT count,
						REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurve2I: path
points: points
count: count
tension: tension [
	<ulong: GdipAddPathCurve2I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurve2I(GpPath *path, GDIPCONST GpPoint *points, INT count,
						REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurve3: path
points: points
count: count
offset: offset
numberOfSegments: numberOfSegments
tension: tension [
	<ulong: GdipAddPathCurve3>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurve3(GpPath *path, GDIPCONST GpPointF *points, INT count,
						INT offset, INT numberOfSegments, REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurve3I: path
points: points
count: count
offset: offset
numberOfSegments: numberOfSegments
tension: tension [
	<ulong: GdipAddPathCurve3I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurve3I(GpPath *path, GDIPCONST GpPoint *points, INT count,
						INT offset, INT numberOfSegments, REAL tension)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathCurveI: path points: points count: count [
	<ulong: GdipAddPathCurveI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathCurveI(GpPath *path, GDIPCONST GpPoint *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathEllipse: path
x: x
y: y
width: width
height: height [
	<ulong: GdipAddPathEllipse>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathEllipse(GpPath *path, REAL x, REAL y, REAL width,
							REAL height)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathEllipseI: path
x: x
y: y
width: width
height: height [
	<ulong: GdipAddPathEllipseI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathEllipseI(GpPath *path, INT x, INT y, INT width, INT height)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathLine: path
x1: x1
y1: y1
x2: x2
y2: y2 [
	<ulong: GdipAddPathLine>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathLine(GpPath *path, REAL x1, REAL y1, REAL x2, REAL y2)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathLine2: path points: points count: count [
	<ulong: GdipAddPathLine2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathLine2(GpPath *path, GDIPCONST GpPointF *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathLine2I: path points: points count: count [
	<ulong: GdipAddPathLine2I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathLine2I(GpPath *path, GDIPCONST GpPoint *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathLineI: path
x1: x1
y1: y1
x2: x2
y2: y2 [
	<ulong: GdipAddPathLineI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipAddPathLineI(GpPath *path, INT x1, INT y1, INT x2, INT y2) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathPath: path addingPath: addingPath connect: connect [
	<ulong: GdipAddPathPath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathPath(GpPath *path, GDIPCONST GpPath* addingPath, BOOL connect)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathPie: path
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipAddPathPie>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathPie(GpPath *path, REAL x, REAL y, REAL width, REAL height,
						REAL startAngle, REAL sweepAngle)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathPieI: path
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipAddPathPieI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathPieI(GpPath *path, INT x, INT y, INT width, INT height,
						REAL startAngle, REAL sweepAngle)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathPolygon: path points: points count: count [
	<ulong: GdipAddPathPolygon>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathPolygon(GpPath *path, GDIPCONST GpPointF *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathPolygonI: path points: points count: count [
	<ulong: GdipAddPathPolygonI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathPolygonI(GpPath *path, GDIPCONST GpPoint *points, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathRectangle: path
x: x
y: y
width: width
height: height [
	<ulong: GdipAddPathRectangle>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathRectangle(GpPath *path, REAL x, REAL y, REAL width, REAL height)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathRectangleI: path
x: x
y: y
width: width
height: height [
	<ulong: GdipAddPathRectangleI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathRectangleI(GpPath *path, INT x, INT y, INT width, INT height)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathRectangles: path rects: rects count: count [
	<ulong: GdipAddPathRectangles>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathRectangles(GpPath *path, GDIPCONST GpRectF *rects, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathRectanglesI: path rects: rects count: count [
	<ulong: GdipAddPathRectanglesI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathRectanglesI(GpPath *path, GDIPCONST GpRect *rects, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathString: path
string: string
length: length
family: family
style: style
emSize: emSize
layoutRect: layoutRect
format: format [
	<ulong: GdipAddPathString>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathString(GpPath *path, GDIPCONST WCHAR *string,
						INT length, GDIPCONST GpFontFamily *family, INT style,
						REAL emSize, GDIPCONST RectF *layoutRect,
						GDIPCONST GpStringFormat *format)
"]

{ #category : #paths }
GDIPlusDLL >> GdipAddPathStringI: path
string: string
length: length
family: family
style: style
emSize: emSize
layoutRect: layoutRect
format: format [
	<ulong: GdipAddPathStringI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipAddPathStringI(GpPath *path, GDIPCONST WCHAR *string,
						INT length, GDIPCONST GpFontFamily *family, INT style,
						REAL emSize, GDIPCONST Rect *layoutRect,
						GDIPCONST GpStringFormat *format)
"]

{ #category : #containers }
GDIPlusDLL >> GdipBeginContainer: graphics
dstrect: dstrect
srcrect: srcrect
unit: unit
state: state [
	<ulong: GdipBeginContainer>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBeginContainer(GpGraphics *graphics, GDIPCONST GpRectF* dstrect,
				GDIPCONST GpRectF *srcrect, GpUnit unit,
				GraphicsContainer *state)
"]

{ #category : #containers }
GDIPlusDLL >> GdipBeginContainer2: graphics state: state [
	<ulong: GdipBeginContainer2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBeginContainer2(GpGraphics *graphics, GraphicsContainer* state)
"]

{ #category : #containers }
GDIPlusDLL >> GdipBeginContainerI: graphics
dstrect: dstrect
srcrect: srcrect
unit: unit
state: state [
	<ulong: GdipBeginContainerI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBeginContainerI(GpGraphics *graphics, GDIPCONST GpRect* dstrect,
					GDIPCONST GpRect *srcrect, GpUnit unit,
					GraphicsContainer *state)
"]

{ #category : #paths }
GDIPlusDLL >> GdipBitmapApplyEffect: bitmap
effect: effect
roi: roi
useAuxData: useAuxData
auxData: auxData
auxDataSize: auxDataSize [
	<ulong: GdipBitmapApplyEffect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipBitmapApplyEffect(
		GpBitmap* bitmap,
		CGpEffect *effect,
		RECT *roi,
		BOOL useAuxData,
		VOID **auxData,
		INT *auxDataSize)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapConvertFormat: bitmap
format: format
dithertype: dithertype
palettetype: palettetype
palette: palette
alphaThresholdPercent: alphaThresholdPercent [
	<ulong: GdipBitmapConvertFormat>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapConvertFormat(
			IN GpBitmap *pInputBitmap,
			PixelFormat format,
			DitherType dithertype,
			PaletteType palettetype,
			ColorPalette *palette,
			REAL alphaThresholdPercent)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapCreateApplyEffect: inputBitmaps
numInputs: numInputs
effect: effect
roi: roi
outputRect: outputRect
outputBitmap: outputBitmap
useAuxData: useAuxData
auxData: auxData
auxDataSize: auxDataSize [
	<ulong: GdipBitmapCreateApplyEffect>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapCreateApplyEffect(
			GpBitmap **inputBitmaps,
			INT numInputs,
			CGpEffect *effect,
			RECT *roi,
			RECT *outputRect,
			GpBitmap **outputBitmap,
			BOOL useAuxData,
			VOID **auxData,
			INT *auxDataSize);
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapGetHistogramSize: format numberOfEntries: numberOfEntries [
	<ulong: GdipBitmapGetHistogramSize>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapGetHistogramSize(
			IN HistogramFormat format,
			OUT UINT *NumberOfEntries);
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapGetPixel: bitmap
x: x
y: y
color: color [
	<ulong: GdipBitmapGetPixel>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapGetPixel(GpBitmap* bitmap, INT x, INT y, ARGB *color)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapLockBits: bitmap
rect: rect
flags: flags
format: format
lockedBitmapData: lockedBitmapData [
	<ulong: GdipBitmapLockBits>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapLockBits(GpBitmap* bitmap,
				GDIPCONST GpRect* rect,
				UINT flags,
				PixelFormat format,
				BitmapData* lockedBitmapData)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapSetPixel: bitmap
x: x
y: y
color: color [
	<ulong: GdipBitmapSetPixel>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapSetPixel(GpBitmap* bitmap, INT x, INT y, ARGB color)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapSetResolution: bitmap xdpi: xdpi ydpi: ydpi [
	<ulong: GdipBitmapSetResolution>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapSetResolution(GpBitmap* bitmap, REAL xdpi, REAL ydpi)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipBitmapUnlockBits: bitmap lockedBitmapData: lockedBitmapData [
	<ulong: GdipBitmapUnlockBits>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipBitmapUnlockBits(GpBitmap* bitmap,
					BitmapData* lockedBitmapData)
"]

{ #category : #paths }
GDIPlusDLL >> GdipClearPathMarkers: path [
	<ulong: GdipClearPathMarkers>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipClearPathMarkers(GpPath* path)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCloneBitmapArea: x
y: y
width: width
height: height
format: format
srcBitmap: srcBitmap
dstBitmap: dstBitmap [
	<ulong: GdipCloneBitmapArea>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneBitmapArea(REAL x, REAL y, REAL width, REAL height,
							PixelFormat format,
							GpBitmap *srcBitmap,
							GpBitmap **dstBitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCloneBitmapAreaI: x
y: y
width: width
height: height
format: format
srcBitmap: srcBitmap
dstBitmap: dstBitmap [
	<ulong: GdipCloneBitmapAreaI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
	GdipCloneBitmapAreaI(INT x,
					INT y,
					INT width,
					INT height,
					PixelFormat format,
					GpBitmap *srcBitmap,
					GpBitmap **dstBitmap)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCloneBrush: brush cloneBrush: cloneBrush [
	<ulong: GdipCloneBrush>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneBrush(GpBrush *brush, GpBrush **cloneBrush);
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipCloneCustomLineCap: customCap clonedCap: clonedCap [
	<ulong: GdipCloneCustomLineCap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneCustomLineCap(GpCustomLineCap* customCap,
					GpCustomLineCap** clonedCap)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCloneFont: font cloneFont: cloneFont [
	<ulong: GdipCloneFont>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneFont(GpFont* font, GpFont** cloneFont)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCloneFontFamily: fontFamily clonedFontFamily: clonedFontFamily [
	<ulong: GdipCloneFontFamily>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneFontFamily(GpFontFamily *FontFamily, GpFontFamily **clonedFontFamily)
"]

{ #category : #images }
GDIPlusDLL >> GdipCloneImage: image cloneImage: cloneImage [
	<ulong: GdipCloneImage>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneImage(GpImage *image, GpImage **cloneImage)
"]

{ #category : #images }
GDIPlusDLL >> GdipCloneImageAttributes: imageattr cloneImageattr: cloneImageattr [
	<ulong: GdipCloneImageAttributes>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneImageAttributes(GDIPCONST GpImageAttributes *imageattr,
						GpImageAttributes **cloneImageattr)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipCloneMatrix: matrix cloneMatrix: cloneMatrix [
	<ulong: GdipCloneMatrix>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneMatrix(GpMatrix *matrix, GpMatrix **cloneMatrix)
"]

{ #category : #paths }
GDIPlusDLL >> GdipClonePath: path clonePath: clonePath [
	<ulong: GdipClonePath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipClonePath(GpPath* path, GpPath **clonePath)
"]

{ #category : #pen }
GDIPlusDLL >> GdipClonePen: pen clonepen: clonepen [
	<ulong: GdipClonePen>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipClonePen(GpPen *pen, GpPen **clonepen)
"]

{ #category : #regions }
GDIPlusDLL >> GdipCloneRegion: region cloneRegion: cloneRegion [
	<ulong: GdipCloneRegion>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneRegion(GpRegion *region, GpRegion **cloneRegion);
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipCloneStringFormat: format newFormat: newFormat [
	<ulong: GdipCloneStringFormat>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCloneStringFormat(GDIPCONST GpStringFormat *format,
					GpStringFormat **newFormat)
"]

{ #category : #paths }
GDIPlusDLL >> GdipClosePathFigure: path [
	<ulong: GdipClosePathFigure>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipClosePathFigure(GpPath *path)
"]

{ #category : #paths }
GDIPlusDLL >> GdipClosePathFigures: path [
	<ulong: GdipClosePathFigures>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipClosePathFigures(GpPath *path)
"]

{ #category : #regions }
GDIPlusDLL >> GdipCombineRegionPath: region path: path combineMode: combineMode [
	<ulong: GdipCombineRegionPath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCombineRegionPath(GpRegion *region, GpPath *path, CombineMode combineMode);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCombineRegionRect: region rect: rect combineMode: combineMode [
	<ulong: GdipCombineRegionRect>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCombineRegionRect(GpRegion *region, GDIPCONST GpRectF *rect,
					CombineMode combineMode);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCombineRegionRectI: region rect: rect combineMode: combineMode [
	<ulong: GdipCombineRegionRectI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCombineRegionRectI(GpRegion *region, GDIPCONST GpRect *rect,
					CombineMode combineMode);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCombineRegionRegion: region region2: region2 combineMode: combineMode [
	<ulong: GdipCombineRegionRegion>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCombineRegionRegion(GpRegion *region,  GpRegion *region2,
						CombineMode combineMode);
"]

{ #category : #other }
GDIPlusDLL >> GdipComment: graphics sizeData: sizeData data: data [
	<ulong: GdipComment>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipComment(GpGraphics* graphics, UINT sizeData, GDIPCONST BYTE * data);
"]

{ #category : #arrows }
GDIPlusDLL >> GdipCreateAdjustableArrowCap: height
width: width
isFilled: isFilled
cap: cap [
	<ulong: GdipCreateAdjustableArrowCap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateAdjustableArrowCap(REAL height, REAL width, BOOL isFilled,
							GpAdjustableArrowCap **cap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromDirectDrawSurface: surface bitmap: bitmap [
	<ulong: GdipCreateBitmapFromDirectDrawSurface>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromDirectDrawSurface(IDirectDrawSurface7* surface,
									GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromFile: filename bitmap: bitmap [
	<ulong: GdipCreateBitmapFromFile>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromFile(GDIPCONST WCHAR* filename, GpBitmap **bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromFileICM: filename bitmap: bitmap [
	<ulong: GdipCreateBitmapFromFileICM>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromFileICM(GDIPCONST WCHAR* filename, GpBitmap **bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromGdiDib: gdiBitmapInfo gdiBitmapData: gdiBitmapData bitmap: bitmap [
	<ulong: GdipCreateBitmapFromGdiDib>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromGdiDib(GDIPCONST BITMAPINFO* gdiBitmapInfo,
						VOID* gdiBitmapData,
						GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromGraphics: width
height: height
target: target
bitmap: bitmap [
	<ulong: GdipCreateBitmapFromGraphics>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromGraphics(INT width,
							INT height,
							GpGraphics* target,
							GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap [
	<ulong: GdipCreateBitmapFromHBITMAP>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromHBITMAP(HBITMAP hbm,
							HPALETTE hpal,
							GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromHICON: hicon bitmap: bitmap [
	<ulong: GdipCreateBitmapFromHICON>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromHICON(HICON hicon,
						GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromResource: hInstance lpBitmapName: lpBitmapName bitmap: bitmap [
	<ulong: GdipCreateBitmapFromResource>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromResource(HINSTANCE hInstance,
							GDIPCONST WCHAR* lpBitmapName,
							GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromScan0: width
height: height
stride: stride
format: format
scan0: scan0
bitmap: bitmap [
	<ulong: GdipCreateBitmapFromScan0>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromScan0(INT width,
						INT height,
						INT stride,
						PixelFormat format,
						BYTE* scan0,
						GpBitmap** bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromStream: stream bitmap: bitmap [
	<ulong: GdipCreateBitmapFromStream>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromStream(IStream* stream, GpBitmap **bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateBitmapFromStreamICM: stream bitmap: bitmap [
	<ulong: GdipCreateBitmapFromStreamICM>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateBitmapFromStreamICM(IStream* stream, GpBitmap **bitmap)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateCachedBitmap: bitmap graphics: graphics cachedBitmap: cachedBitmap [
	<ulong: GdipCreateCachedBitmap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
GdipCreateCachedBitmap(
	GpBitmap *bitmap,
	GpGraphics *graphics,
	GpCachedBitmap **cachedBitmap
)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipCreateCustomLineCap: fillPath
strokePath: strokePath
baseCap: baseCap
baseInset: baseInset
customCap: customCap [
	<ulong: GdipCreateCustomLineCap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateCustomLineCap(GpPath* fillPath, GpPath* strokePath,
				GpLineCap baseCap, REAL baseInset, GpCustomLineCap **customCap)
"]

{ #category : #other }
GDIPlusDLL >> GdipCreateEffect: guid effect: effect [
	<ulong: GdipCreateEffect>
	^self invalidArgument

"
	Status __stdcall GdipCreateEffect(const GUID guid, CGpEffect **effect)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCreateFont: fontFamily
emSize: emSize
style: style
unit: unit
font: font [
	<ulong: GdipCreateFont>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFont(
			GDIPCONST GpFontFamily  *fontFamily,
			REAL emSize,
			INT style,
			Unit unit,
			GpFont **font)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCreateFontFamilyFromName: name fontCollection: fontCollection fontFamily: fontFamily [
	<ulong: GdipCreateFontFamilyFromName>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFontFamilyFromName(GDIPCONST WCHAR *name,
							GpFontCollection *fontCollection,
							GpFontFamily **FontFamily)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCreateFontFromDC: hdc font: font [
	<ulong: GdipCreateFontFromDC>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFontFromDC(
	HDC        hdc,
	GpFont   **font)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCreateFontFromLogfont: hdc logfont: logfont font: font [
	<ulong: GdipCreateFontFromLogfontA>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFontFromLogfontA( HDC hdc, GDIPCONST LOGFONTA *logfont, GpFont **font ) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipCreateFontFromLogfontW: hdc logfont: logfont font: font [
	<ulong: GdipCreateFontFromLogfontW>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFontFromLogfont( HDC hdc, GDIPCONST LOGFONTA *logfont, GpFont **font ) 
"]

{ #category : #graphics }
GDIPlusDLL >> GdipCreateFromHDC: hdc graphics: graphics [
	<ulong: GdipCreateFromHDC>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFromHDC(HDC hdc, GpGraphics **graphics)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipCreateFromHDC2: hdc hDevice: hDevice graphics: graphics [
	<ulong: GdipCreateFromHDC2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFromHDC2(HDC hdc, HANDLE hDevice, GpGraphics **graphics)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipCreateFromHWND: hwnd graphics: graphics [
	<ulong: GdipCreateFromHWND>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFromHWND(HWND hwnd, GpGraphics **graphics)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipCreateFromHWNDICM: hwnd graphics: graphics [
	<ulong: GdipCreateFromHWNDICM>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateFromHWNDICM(HWND hwnd, GpGraphics **graphics)
"]

{ #category : #other }
GDIPlusDLL >> GdipCreateHalftonePalette [
	<pointer: GdipCreateHalftonePalette>
	^self invalidArgument

"
	HPALETTE WINGDIPAPI
		GdipCreateHalftonePalette()
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateHatchBrush: hatchstyle
forecol: forecol
backcol: backcol
brush: brush [
	<ulong: GdipCreateHatchBrush>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateHatchBrush(GpHatchStyle hatchstyle, ARGB forecol, ARGB backcol, GpHatch **brush);
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateHBITMAPFromBitmap: bitmap hbmReturn: hbmReturn background: background [
	<ulong: GdipCreateHBITMAPFromBitmap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateHBITMAPFromBitmap(GpBitmap* bitmap,
							HBITMAP* hbmReturn,
							ARGB background)
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipCreateHICONFromBitmap: bitmap hbmReturn: hbmReturn [
	<ulong: GdipCreateHICONFromBitmap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
GdipCreateHICONFromBitmap(GpBitmap* bitmap,
						HICON* hbmReturn)
"]

{ #category : #images }
GDIPlusDLL >> GdipCreateImageAttributes: imageattr [
	<ulong: GdipCreateImageAttributes>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateImageAttributes(GpImageAttributes **imageattr)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrush: point1
point2: point2
color1: color1
color2: color2
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrush>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateLineBrush(GDIPCONST GpPointF* point1,
					GDIPCONST GpPointF* point2,
					ARGB color1, ARGB color2,
					GpWrapMode wrapMode,
					GpLineGradient **lineGradient)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrushFromRect: rect
color1: color1
color2: color2
mode: mode
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrushFromRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI
	GdipCreateLineBrushFromRect(
		GDIPCONST GpRectF* rect,
		ARGB color1,
		ARGB color2,
		LinearGradientMode mode,
		GpWrapMode wrapMode,
		GpLineGradient **lineGradient)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrushFromRectI: rect
color1: color1
color2: color2
mode: mode
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrushFromRectI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateLineBrushFromRectI(GDIPCONST GpRect* rect,
							ARGB color1, ARGB color2,
							LinearGradientMode mode,
							GpWrapMode wrapMode,
							GpLineGradient **lineGradient)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrushFromRectWithAngle: rect
color1: color1
color2: color2
angle: angle
isAngleScalable: isAngleScalable
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrushFromRectWithAngle>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateLineBrushFromRectWithAngle(GDIPCONST GpRectF* rect,
									ARGB color1, ARGB color2,
									REAL angle,
									BOOL isAngleScalable,
									GpWrapMode wrapMode,
									GpLineGradient **lineGradient)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrushFromRectWithAngleI: rect
color1: color1
color2: color2
angle: angle
isAngleScalable: isAngleScalable
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrushFromRectWithAngleI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateLineBrushFromRectWithAngleI(GDIPCONST GpRect* rect,
									ARGB color1, ARGB color2,
									REAL angle,
									BOOL isAngleScalable,
									GpWrapMode wrapMode,
									GpLineGradient **lineGradient)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateLineBrushI: point1
point2: point2
color1: color1
color2: color2
wrapMode: wrapMode
lineGradient: lineGradient [
	<ulong: GdipCreateLineBrushI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateLineBrushI(GDIPCONST GpPoint* point1,
					GDIPCONST GpPoint* point2,
					ARGB color1, ARGB color2,
					GpWrapMode wrapMode,
					GpLineGradient **lineGradient)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipCreateMatrix: matrix [
	<ulong: GdipCreateMatrix>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMatrix(GpMatrix **matrix)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipCreateMatrix2: m11
m12: m12
m21: m21
m22: m22
dx: dx
dy: dy
matrix: matrix [
	<ulong: GdipCreateMatrix2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMatrix2(REAL m11, REAL m12, REAL m21, REAL m22, REAL dx,
									REAL dy, GpMatrix **matrix)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipCreateMatrix3: rect dstplg: dstplg matrix: matrix [
	<ulong: GdipCreateMatrix3>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMatrix3(GDIPCONST GpRectF *rect, GDIPCONST GpPointF *dstplg,
									GpMatrix **matrix)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipCreateMatrix3I: rect dstplg: dstplg matrix: matrix [
	<ulong: GdipCreateMatrix3I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMatrix3I(GDIPCONST GpRect *rect, GDIPCONST GpPoint *dstplg,
									GpMatrix **matrix)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipCreateMetafileFromEmf: hEmf deleteEmf: deleteEmf metafile: metafile [
	<ulong: GdipCreateMetafileFromEmf>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMetafileFromEmf(HENHMETAFILE hEmf, BOOL deleteEmf,
						GpMetafile **metafile);
"]

{ #category : #metafile }
GDIPlusDLL >> GdipCreateMetafileFromFile: file metafile: metafile [
	<ulong: GdipCreateMetafileFromFile>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMetafileFromFile(GDIPCONST WCHAR* file, GpMetafile **metafile);
"]

{ #category : #metafile }
GDIPlusDLL >> GdipCreateMetafileFromStream: stream metafile: metafile [
	<ulong: GdipCreateMetafileFromStream>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMetafileFromStream(IStream * stream, GpMetafile **metafile);
"]

{ #category : #metafile }
GDIPlusDLL >> GdipCreateMetafileFromWmf: hWmf
deleteWmf: deleteWmf
wmfPlaceableFileHeader: wmfPlaceableFileHeader
metafile: metafile [
	<ulong: GdipCreateMetafileFromWmf>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateMetafileFromWmf(HMETAFILE hWmf, BOOL deleteWmf,
						GDIPCONST WmfPlaceableFileHeader * wmfPlaceableFileHeader,
						GpMetafile **metafile);
"]

{ #category : #metafile }
GDIPlusDLL >> GdipCreateMetafileFromWmfFile: file wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile [
	<ulong: GdipCreateMetafileFromWmfFile>
	^self invalidArgument

"
	GpStatus GdipCreateMetafileFromWmfFile(GDIPCONST WCHAR* file,
							GDIPCONST WmfPlaceableFileHeader * wmfPlaceableFileHeader,
							GpMetafile **metafile);
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePath: brushMode path: path [
	<ulong: GdipCreatePath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePath(GpFillMode brushMode, GpPath **path)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePath2: points
types: types
count: count
fillMode: fillMode
path: path [
	<ulong: GdipCreatePath2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePath2(GDIPCONST GpPointF* points, GDIPCONST BYTE* types, INT count, GpFillMode fillMode, GpPath **path)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePath2I: points
types: types
count: count
fillMode: fillMode
path: path [
	<ulong: GdipCreatePath2I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
			GdipCreatePath2I(GDIPCONST GpPoint* points, GDIPCONST BYTE* types, INT count, GpFillMode fillMode, GpPath **path)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePathGradient: points
count: count
wrapMode: wrapMode
polyGradient: polyGradient [
	<ulong: GdipCreatePathGradient>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePathGradient(GDIPCONST GpPointF* points,
									INT count,
									GpWrapMode wrapMode,
									GpPathGradient **polyGradient)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePathGradientFromPath: path polyGradient: polyGradient [
	<ulong: GdipCreatePathGradientFromPath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePathGradientFromPath(GDIPCONST GpPath* path,
									GpPathGradient **polyGradient)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePathGradientI: points
count: count
wrapMode: wrapMode
polyGradient: polyGradient [
	<ulong: GdipCreatePathGradientI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePathGradientI(GDIPCONST GpPoint* points,
									INT count,
									GpWrapMode wrapMode,
									GpPathGradient **polyGradient)
"]

{ #category : #paths }
GDIPlusDLL >> GdipCreatePathIter: iterator path: path [
	<ulong: GdipCreatePathIter>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePathIter(GpPathIterator **iterator, GpPath* path)
"]

{ #category : #pen }
GDIPlusDLL >> GdipCreatePen1: color
width: width
unit: unit
pen: pen [
	<ulong: GdipCreatePen1>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePen1(ARGB color, REAL width, GpUnit unit, GpPen **pen)
"]

{ #category : #pen }
GDIPlusDLL >> GdipCreatePen2: brush
width: width
unit: unit
pen: pen [
	<ulong: GdipCreatePen2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreatePen2(GpBrush *brush, REAL width, GpUnit unit, GpPen **pen)
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegion: region [
	<ulong: GdipCreateRegion>
	^self invalidArgument

"
	GpStatus GdipCreateRegion(GpRegion **region);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegionHrgn: hRgn region: region [
	<ulong: GdipCreateRegionHrgn>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateRegionHrgn(HRGN hRgn, GpRegion **region);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegionPath: path region: region [
	<ulong: GdipCreateRegionPath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateRegionPath(GpPath *path, GpRegion **region);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegionRect: rect region: region [
	<ulong: GdipCreateRegionRect>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateRegionRect(GDIPCONST GpRectF *rect, GpRegion **region);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegionRectI: rect region: region [
	<ulong: GdipCreateRegionRectI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateRegionRectI(GDIPCONST GpRect *rect, GpRegion **region);
"]

{ #category : #regions }
GDIPlusDLL >> GdipCreateRegionRgnData: regionData size: size region: region [
	<ulong: GdipCreateRegionRgnData>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateRegionRgnData(GDIPCONST BYTE *regionData, INT size,
						GpRegion **region);
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateSolidFill: color brush: brush [
	<ulong: GdipCreateSolidFill>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateSolidFill(ARGB color, GpSolidFill **brush);
"]

{ #category : #other }
GDIPlusDLL >> GdipCreateStreamOnFile: filename access: access stream: stream [
	<ulong: GdipCreateStreamOnFile>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateStreamOnFile(GDIPCONST WCHAR * filename, UINT access,
					IStream **stream);
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipCreateStringFormat: formatAttributes language: language format: format [
	<ulong: GdipCreateStringFormat>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateStringFormat(
			INT formatAttributes,
			LANGID language,
			GpStringFormat **format)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateTexture: image wrapmode: wrapmode texture: texture [
	<ulong: GdipCreateTexture>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateTexture(GpImage *image, GpWrapMode wrapmode,
							GpTexture **texture)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateTexture2: image
wrapmode: wrapmode
x: x
y: y
width: width
height: height
texture: texture [
	<ulong: GdipCreateTexture2>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateTexture2(GpImage *image, GpWrapMode wrapmode, REAL x,
					REAL y, REAL width, REAL height, GpTexture **texture)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateTexture2I: image
wrapmode: wrapmode
x: x
y: y
width: width
height: height
texture: texture [
	<ulong: GdipCreateTexture2I>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateTexture2I(GpImage *image, GpWrapMode wrapmode, INT x,
					INT y, INT width, INT height, GpTexture **texture)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateTextureIA: image
imageAttributes: imageAttributes
x: x
y: y
width: width
height: height
texture: texture [
	<ulong: GdipCreateTextureIA>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateTextureIA(GpImage *image,
					GDIPCONST GpImageAttributes *imageAttributes,
					REAL x, REAL y, REAL width, REAL height,
					GpTexture **texture)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipCreateTextureIAI: image
imageAttributes: imageAttributes
x: x
y: y
width: width
height: height
texture: texture [
	<ulong: GdipCreateTextureIAI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipCreateTextureIAI(GpImage *image,
					GDIPCONST GpImageAttributes *imageAttributes,
					INT x, INT y, INT width, INT height,
					GpTexture **texture)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipDeleteBrush: brush [
	<ulong: GdipDeleteBrush>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteBrush(GpBrush *brush);
"]

{ #category : #bitmaps }
GDIPlusDLL >> GdipDeleteCachedBitmap: cachedBitmap [
	<ulong: GdipDeleteCachedBitmap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteCachedBitmap(GpCachedBitmap *cachedBitmap)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDeleteCustomLineCap: customCap [
	<ulong: GdipDeleteCustomLineCap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteCustomLineCap(GpCustomLineCap* customCap)
"]

{ #category : #other }
GDIPlusDLL >> GdipDeleteEffect: effect [
	<ulong: GdipDeleteEffect>
	^self invalidArgument

"
	Status __stdcall GdipDeleteEffect(CGpEffect *effect)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipDeleteFont: font [
	<ulong: GdipDeleteFont>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteFont(GpFont* font)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipDeleteFontFamily: fontFamily [
	<ulong: GdipDeleteFontFamily>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteFontFamily(GpFontFamily *FontFamily)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipDeleteGraphics: graphics [
	<ulong: GdipDeleteGraphics>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteGraphics(GpGraphics *graphics)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipDeleteMatrix: matrix [
	<ulong: GdipDeleteMatrix>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteMatrix(GpMatrix *matrix)
"]

{ #category : #paths }
GDIPlusDLL >> GdipDeletePath: path [
	<ulong: GdipDeletePath>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeletePath(GpPath* path)
"]

{ #category : #paths }
GDIPlusDLL >> GdipDeletePathIter: iterator [
	<ulong: GdipDeletePathIter>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeletePathIter(GpPathIterator *iterator)
"]

{ #category : #pen }
GDIPlusDLL >> GdipDeletePen: pen [
	<ulong: GdipDeletePen>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeletePen(GpPen *pen)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipDeletePrivateFontCollection: fontCollection [
	<ulong: GdipDeletePrivateFontCollection>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeletePrivateFontCollection(GpFontCollection** fontCollection)
"]

{ #category : #regions }
GDIPlusDLL >> GdipDeleteRegion: region [
	<ulong: GdipDeleteRegion>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteRegion(GpRegion *region);
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipDeleteStringFormat: format [
	<ulong: GdipDeleteStringFormat>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDeleteStringFormat(GpStringFormat *format)
"]

{ #category : #bitmaps }
GDIPlusDLL >> gdipDisposeBitmap: image [
	^self GdipDisposeImage: image]

{ #category : #images }
GDIPlusDLL >> GdipDisposeImage: image [
	<ulong: GdipDisposeImage>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDisposeImage(GpImage *image)
"]

{ #category : #images }
GDIPlusDLL >> GdipDisposeImageAttributes: imageattr [
	<ulong: GdipDisposeImageAttributes>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDisposeImageAttributes(GpImageAttributes *imageattr)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawArc: graphics
pen: pen
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipDrawArc>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawArc(GpGraphics *graphics, GpPen *pen, REAL x, REAL y,
			REAL width, REAL height, REAL startAngle, REAL sweepAngle)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawArcI: graphics
pen: pen
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipDrawArcI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawArcI(GpGraphics *graphics, GpPen *pen, INT x, INT y,
					INT width, INT height, REAL startAngle, REAL sweepAngle)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawBezier: graphics
pen: pen
x1: x1
y1: y1
x2: x2
y2: y2
x3: x3
y3: y3
x4: x4
y4: y4 [
	<ulong: GdipDrawBezier>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawBezier(GpGraphics *graphics, GpPen *pen, REAL x1, REAL y1,
						REAL x2, REAL y2, REAL x3, REAL y3, REAL x4, REAL y4)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawBezierI: graphics
pen: pen
x1: x1
y1: y1
x2: x2
y2: y2
x3: x3
y3: y3
x4: x4
y4: y4 [
	<ulong: GdipDrawBezierI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawBezierI(GpGraphics *graphics, GpPen *pen, INT x1, INT y1,
						INT x2, INT y2, INT x3, INT y3, INT x4, INT y4)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawBeziers: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawBeziers>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawBeziers(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points,
						INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawBeziersI: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawBeziersI>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawBeziersI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points,
						INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCachedBitmap: graphics
cachedBitmap: cachedBitmap
x: x
y: y [
	<ulong: GdipDrawCachedBitmap>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawCachedBitmap(
			GpGraphics *graphics,
			GpCachedBitmap *cachedBitmap,
			INT x,
			INT y)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawClosedCurve: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawClosedCurve>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipDrawClosedCurve(GpGraphics *graphics, GpPen *pen,
					GDIPCONST GpPointF *points, INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawClosedCurve2: graphics
pen: pen
points: points
count: count
tension: tension [
	<ulong: GdipDrawClosedCurve2>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawClosedCurve2(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points, INT count, REAL tension) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawClosedCurve2I: graphics
pen: pen
points: points
count: count
tension: tension [
	<ulong: GdipDrawClosedCurve2I>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawClosedCurve2I(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count, REAL tension) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawClosedCurveI: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawClosedCurveI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawClosedCurveI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurve: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawCurve>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawCurve(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurve2: graphics
pen: pen
points: points
count: count
tension: tension [
	<ulong: GdipDrawCurve2>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawCurve2(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points, INT count, REAL tension) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurve2I: graphics
pen: pen
points: points
count: count
tension: tension [
	<ulong: GdipDrawCurve2I>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawCurve2I(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count, REAL tension) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurve3: graphics
pen: pen
points: points
count: count
offset: offset
numberOfSegments: numberOfSegments
tension: tension [
	<ulong: GdipDrawCurve3>
	^self invalidArgument

	"
	GpStatus WINGDIPAPI
		GdipDrawCurve3(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points,
			INT count, INT offset, INT numberOfSegments, REAL tension)
	"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurve3I: graphics
pen: pen
points: points
count: count
offset: offset
numberOfSegments: numberOfSegments
tension: tension [
	<ulong: GdipDrawCurve3I>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawCurve3I(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count, INT offset, INT numberOfSegments, REAL tension) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawCurveI: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawCurveI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawCurveI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipDrawDriverString: graphics
text: text
length: length
font: font
brush: brush
positions: positions
flags: flags
matrix: matrix [
	<ulong: GdipDrawDriverString>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawDriverString( GpGraphics *graphics, GDIPCONST UINT16 *text, INT length, GDIPCONST GpFont *font, GDIPCONST GpBrush *brush, GDIPCONST PointF *positions, INT flags, GDIPCONST GpMatrix *matrix ); 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawEllipse: graphics
pen: pen
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawEllipse>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawEllipse(GpGraphics *graphics, GpPen *pen, REAL x, REAL y, REAL width, REAL height) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawEllipseI: graphics
pen: pen
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawEllipseI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawEllipseI(GpGraphics *graphics, GpPen *pen, INT x, INT y, INT width, INT height) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImage: graphics
image: image
x: x
y: y [
	<ulong: GdipDrawImage>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImage(GpGraphics *graphics, GpImage *image, REAL x, REAL y) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImageI: graphics
image: image
x: x
y: y [
	<ulong: GdipDrawImageI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImageI(GpGraphics *graphics, GpImage *image, INT x, INT y) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePointRect: graphics
image: image
x: x
y: y
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit [
	<ulong: GdipDrawImagePointRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePointRect(GpGraphics *graphics, GpImage *image, REAL x, REAL y, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, GpUnit srcUnit) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePointRectI: graphics
image: image
x: x
y: y
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit [
	<ulong: GdipDrawImagePointRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePointRectI(GpGraphics *graphics, GpImage *image, INT x, INT y, INT srcx, INT srcy, INT srcwidth, INT srcheight, GpUnit srcUnit) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePoints: graphics
image: image
dstpoints: dstpoints
count: count [
	<ulong: GdipDrawImagePoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePoints(GpGraphics *graphics, GpImage *image, GDIPCONST GpPointF *dstpoints, INT count) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePointsI: graphics
image: image
dstpoints: dstpoints
count: count [
	<ulong: GdipDrawImagePointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePointsI(GpGraphics *graphics, GpImage *image, GDIPCONST GpPoint *dstpoints, INT count) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePointsRect: graphics
image: image
points: points
count: count
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	<ulong: GdipDrawImagePointsRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePointsRect(GpGraphics *graphics, GpImage *image, GDIPCONST GpPointF *points, INT count, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, GpUnit srcUnit, GDIPCONST GpImageAttributes* imageAttributes, DrawImageAbort callback, VOID * callbackData) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImagePointsRectI: graphics
image: image
points: points
count: count
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	<ulong: GdipDrawImagePointsRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImagePointsRectI(GpGraphics *graphics, GpImage *image, GDIPCONST GpPoint *points, INT count, INT srcx, INT srcy, INT srcwidth, INT srcheight, GpUnit srcUnit, GDIPCONST GpImageAttributes* imageAttributes, DrawImageAbort callback, VOID * callbackData) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImageRect: graphics
image: image
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawImageRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImageRect(GpGraphics *graphics, GpImage *image, REAL x, REAL y, REAL width, REAL height) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImageRectI: graphics
image: image
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawImageRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImageRectI(GpGraphics *graphics, GpImage *image, INT x, INT y, INT width, INT height) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImageRectRect: graphics
image: image
dstx: dstx
dsty: dsty
dstwidth: dstwidth
dstheight: dstheight
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	<ulong: GdipDrawImageRectRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImageRectRect(GpGraphics *graphics, GpImage *image, REAL dstx, REAL dsty, REAL dstwidth, REAL dstheight, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, GpUnit srcUnit, GDIPCONST GpImageAttributes* imageAttributes, DrawImageAbort callback, VOID * callbackData) 
"]

{ #category : #images }
GDIPlusDLL >> GdipDrawImageRectRectI: graphics
image: image
dstx: dstx
dsty: dsty
dstwidth: dstwidth
dstheight: dstheight
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
srcUnit: srcUnit
imageAttributes: imageAttributes
callback: callback
callbackData: callbackData [
	<ulong: GdipDrawImageRectRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawImageRectRectI(GpGraphics *graphics, GpImage *image, INT dstx, INT dsty, INT dstwidth, INT dstheight, INT srcx, INT srcy, INT srcwidth, INT srcheight, GpUnit srcUnit, GDIPCONST GpImageAttributes* imageAttributes, DrawImageAbort callback, VOID * callbackData) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawLine: graphics
pen: pen
x1: x1
y1: y1
x2: x2
y2: y2 [
	<ulong: GdipDrawLine>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawLine(GpGraphics *graphics, GpPen *pen, REAL x1, REAL y1, REAL x2, REAL y2) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawLineI: graphics
pen: pen
x1: x1
y1: y1
x2: x2
y2: y2 [
	<ulong: GdipDrawLineI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawLineI(GpGraphics *graphics, GpPen *pen, INT x1, INT y1, INT x2, INT y2) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawLines: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawLines>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawLines(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawLinesI: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawLinesI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawLinesI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipDrawPath: graphics pen: pen path: path [
	<ulong: GdipDrawPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawPath(GpGraphics *graphics, GpPen *pen, GpPath *path) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawPie: graphics
pen: pen
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipDrawPie>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawPie(GpGraphics *graphics, GpPen *pen, REAL x, REAL y, REAL width, REAL height, REAL startAngle, REAL sweepAngle) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawPieI: graphics
pen: pen
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipDrawPieI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawPieI(GpGraphics *graphics, GpPen *pen, INT x, INT y, INT width, INT height, REAL startAngle, REAL sweepAngle) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawPolygon: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawPolygon>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawPolygon(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPointF *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawPolygonI: graphics
pen: pen
points: points
count: count [
	<ulong: GdipDrawPolygonI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawPolygonI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawRectangle: graphics
pen: pen
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawRectangle>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawRectangle(GpGraphics *graphics, GpPen *pen, REAL x, REAL y, REAL width, REAL height) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawRectangleI: graphics
pen: pen
x: x
y: y
width: width
height: height [
	<ulong: GdipDrawRectangleI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawRectangleI(GpGraphics *graphics, GpPen *pen, INT x, INT y, INT width, INT height) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawRectangles: graphics
pen: pen
rects: rects
count: count [
	<ulong: GdipDrawRectangles>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawRectangles(GpGraphics *graphics, GpPen *pen, GDIPCONST GpRectF *rects, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipDrawRectanglesI: graphics
pen: pen
rects: rects
count: count [
	<ulong: GdipDrawRectanglesI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawRectanglesI(GpGraphics *graphics, GpPen *pen, GDIPCONST GpRect *rects, INT count) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipDrawString: graphics
string: unicodeString
length: length
font: font
layoutRect: layoutRect
stringFormat: stringFormat
brush: brush [
	<ulong: GdipDrawString>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipDrawString( GpGraphics *graphics, GDIPCONST WCHAR *string, INT length, GDIPCONST GpFont *font, GDIPCONST RectF *layoutRect, GDIPCONST GpStringFormat *stringFormat, GDIPCONST GpBrush *brush ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEmfToWmfBits: hemf
cbData16: cbData16
pData16: pData16
iMapMode: iMapMode
eFlags: eFlags [
	<ulong: GdipEmfToWmfBits>
	^self invalidArgument

"
UINT WINGDIPAPI GdipEmfToWmfBits( HENHMETAFILE hemf, UINT cbData16, LPBYTE pData16, INT iMapMode, INT eFlags ) 
"]

{ #category : #containers }
GDIPlusDLL >> GdipEndContainer: graphics state: state [
	<ulong: GdipEndContainer>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipEndContainer(GpGraphics *graphics, GraphicsContainer state)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestPoint: graphics
metafile: metafile
destPoint: destPoint
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestPoint(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST PointF *destPoint
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestPointI: graphics
metafile: metafile
destPoint: destPoint
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestPointI(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST Point *destPoint
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestPoints: graphics
metafile: metafile
destPoints: destPoints
count: count
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestPoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestPoints( GpGraphics * graphics, GDIPCONST GpMetafile * metafile, GDIPCONST PointF * destPoints, INT count, EnumerateMetafileProc callback, VOID * callbackData, GDIPCONST GpImageAttributes * imageAttributes ) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestPointsI: graphics
metafile: metafile
destPoints: destPoints
count: count
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestPointsI( GpGraphics * graphics, GDIPCONST GpMetafile * metafile, GDIPCONST Point * destPoints, INT count, EnumerateMetafileProc callback, VOID * callbackData, GDIPCONST GpImageAttributes * imageAttributes ) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestRect: graphics
metafile: metafile
destRect: destRect
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestRect(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST RectF *destRect
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileDestRectI: graphics
metafile: metafile
destRect: destRect
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileDestRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileDestRectI(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST Rect *destRect
	EnumerateMetafileProc callback
	VOID *callbackData,
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestPoint: graphics
metafile: metafile
destPoint: destPoint
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestPoint(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST PointF *destPoint
	GDIPCONST RectF *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestPointI: graphics
metafile: metafile
destPoint: destPoint
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestPointI(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST Point *destPoint
	GDIPCONST Rect *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestPoints: graphics
metafile: metafile
destPoints: destPoints
count: count
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestPoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestPoints(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST PointF *destPoints
	INT count
	GDIPCONST RectF *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestPointsI: graphics
metafile: metafile
destPoints: destPoints
count: count
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestPointsI(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST Point *destPoints
	INT count
	GDIPCONST Rect *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestRect: graphics
metafile: metafile
destRect: destRect
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestRect(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST RectF *destRect
	GDIPCONST RectF *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipEnumerateMetafileSrcRectDestRectI: graphics
metafile: metafile
destRect: destRect
srcRect: srcRect
srcUnit: srcUnit
callback: callback
callbackData: callbackData
imageAttributes: imageAttributes [
	<ulong: GdipEnumerateMetafileSrcRectDestRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipEnumerateMetafileSrcRectDestRectI(
	GpGraphics *graphics
	GDIPCONST GpMetafile *metafile
	GDIPCONST Rect *destRect
	GDIPCONST Rect *srcRect
	Unit srcUnit
	EnumerateMetafileProc callback
	VOID *callbackData
	GDIPCONST GpImageAttributes *imageAttributes
)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillClosedCurve: graphics
brush: brush
points: points
count: count [
	<ulong: GdipFillClosedCurve>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillClosedCurve(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPointF *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillClosedCurve2: graphics
brush: brush
points: points
count: count
tension: tension
fillMode: fillMode [
	<ulong: GdipFillClosedCurve2>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillClosedCurve2(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPointF *points, INT count, REAL tension, GpFillMode fillMode) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillClosedCurve2I: graphics
brush: brush
points: points
count: count
tension: tension
fillMode: fillMode [
	<ulong: GdipFillClosedCurve2I>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillClosedCurve2I(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPoint *points, INT count, REAL tension, GpFillMode fillMode) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillClosedCurveI: graphics
brush: brush
points: points
count: count [
	<ulong: GdipFillClosedCurveI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillClosedCurveI(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillEllipse: graphics
brush: brush
x: x
y: y
width: width
height: height [
	<ulong: GdipFillEllipse>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillEllipse(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y, REAL width, REAL height) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillEllipseI: graphics
brush: brush
x: x
y: y
width: width
height: height [
	<ulong: GdipFillEllipseI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillEllipseI(GpGraphics *graphics, GpBrush *brush, INT x, INT y, INT width, INT height) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipFillPath: graphics brush: brush path: path [
	<ulong: GdipFillPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPath(GpGraphics *graphics, GpBrush *brush, GpPath *path) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPie: graphics
brush: brush
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipFillPie>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPie(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y, REAL width, REAL height, REAL startAngle, REAL sweepAngle) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPieI: graphics
brush: brush
x: x
y: y
width: width
height: height
startAngle: startAngle
sweepAngle: sweepAngle [
	<ulong: GdipFillPieI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPieI(GpGraphics *graphics, GpBrush *brush, INT x, INT y, INT width, INT height, REAL startAngle, REAL sweepAngle) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPolygon: graphics
brush: brush
points: points
count: count
fillMode: fillMode [
	<ulong: GdipFillPolygon>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPolygon(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPointF *points, INT count, GpFillMode fillMode) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPolygon2: graphics
brush: brush
points: points
count: count [
	<ulong: GdipFillPolygon2>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPolygon2(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPointF *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPolygon2I: graphics
brush: brush
points: points
count: count [
	<ulong: GdipFillPolygon2I>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillPolygon2I(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpPoint *points, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillPolygonI: graphics
brush: brush
points: points
count: count
fillMode: fillMode [
	<ulong: GdipFillPolygonI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
	GdipFillPolygonI(
		GpGraphics *graphics,
		GpBrush *brush,
		GDIPCONST GpPoint *points,
		INT count,
		GpFillMode fillMode)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillRectangle: graphics
brush: brush
x: x
y: y
width: width
height: height [
	<ulong: GdipFillRectangle>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
		GdipFillRectangle(GpGraphics *graphics, GpBrush *brush, REAL x, REAL y,
				REAL width, REAL height)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillRectangleI: graphics
brush: brush
x: x
y: y
width: width
height: height [
	<ulong: GdipFillRectangleI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillRectangleI(GpGraphics *graphics, GpBrush *brush, INT x, INT y, INT width, INT height) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillRectangles: graphics
brush: aGDIPlusBrush
rects: aColllection
count: anInteger [
	<ulong: GdipFillRectangles>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
GdipFillRectangles(GpGraphics *graphics, GpBrush *brush,
				GDIPCONST GpRectF *rects, INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipFillRectanglesI: graphics
brush: brush
rects: rects
count: count [
	<ulong: GdipFillRectanglesI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillRectanglesI(GpGraphics *graphics, GpBrush *brush, GDIPCONST GpRect *rects, INT count) 
"]

{ #category : #regions }
GDIPlusDLL >> GdipFillRegion: graphics brush: brush region: region [
	<ulong: GdipFillRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFillRegion(GpGraphics *graphics, GpBrush *brush, GpRegion *region) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipFlattenPath: path matrix: matrix flatness: flatness [
	<ulong: GdipFlattenPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFlattenPath(GpPath *path, GpMatrix* matrix, REAL flatness) 
"]

{ #category : #other }
GDIPlusDLL >> GdipFlush: graphics intention: intention [
	<ulong: GdipFlush>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFlush(GpGraphics *graphics, GpFlushIntention intention) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipFontCollectionEnumerable: fontCollection graphics: graphics numFound: numFound [
	<ulong: GdipFontCollectionEnumerable>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFontCollectionEnumerable( GpFontCollection* fontCollection, GpGraphics* graphics, INT * numFound ) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipFontCollectionEnumerate: fontCollection
numSought: numSought
pfamilies: pfamilies
numFound: numFound
graphics: graphics [
	<ulong: GdipFontCollectionEnumerate>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipFontCollectionEnumerate( GpFontCollection* fontCollection, INT numSought, GpFontFamily* pfamilies[], INT* numFound, GpGraphics* graphics); 
"]

{ #category : #arrows }
GDIPlusDLL >> GdipGetAdjustableArrowCapFillState: cap fillState: fillState [
	<ulong: GdipGetAdjustableArrowCapFillState>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetAdjustableArrowCapFillState(GpAdjustableArrowCap* cap, BOOL* fillState)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipGetAdjustableArrowCapHeight: cap height: height [
	<ulong: GdipGetAdjustableArrowCapHeight>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetAdjustableArrowCapHeight(GpAdjustableArrowCap* cap, REAL* height)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipGetAdjustableArrowCapMiddleInset: cap middleInset: middleInset [
	<ulong: GdipGetAdjustableArrowCapMiddleInset>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetAdjustableArrowCapMiddleInset(GpAdjustableArrowCap* cap, REAL* middleInset)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipGetAdjustableArrowCapWidth: cap width: width [
	<ulong: GdipGetAdjustableArrowCapWidth>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetAdjustableArrowCapWidth(GpAdjustableArrowCap* cap, REAL* width)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetAllPropertyItems: image
totalBufferSize: integer
numProperties: count
allItems: items [
	<ulong: GdipGetAllPropertyItems>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetAllPropertyItems(GpImage *image, UINT totalBufferSize, UINT numProperties, PropertyItem* allItems)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetBrushType: brush type: type [
	<ulong: GdipGetBrushType>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipGetBrushType(GpBrush *brush, GpBrushType *type);
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetCellAscent: family style: style CellAscent: cellAscent [
	<ulong: GdipGetCellAscent>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCellAscent(GDIPCONST GpFontFamily *family, INT style, UINT16 * CellAscent)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetCellDescent: family style: style CellDescent: descent [
	<ulong: GdipGetCellDescent>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCellDescent(GDIPCONST GpFontFamily *family, INT style, UINT16 * CellDescent)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetClip: graphics region: region [
	<ulong: GdipGetClip>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipGetClip(GpGraphics *graphics, GpRegion *region) 
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetClipBounds: graphics rect: rect [
	<ulong: GdipGetClipBounds>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetClipBounds(GpGraphics *graphics, GpRectF *rect)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetClipBoundsI: graphics rect: rect [
	<ulong: GdipGetClipBoundsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetClipBoundsI(GpGraphics *graphics, GpRect *rect)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetCompositingMode: graphics compositingMode: compositingMode [
	<ulong: GdipGetCompositingMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCompositingMode(GpGraphics *graphics, CompositingMode *compositingMode)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetCompositingQuality: graphics compositingQuality: compositingQuality [
	<ulong: GdipGetCompositingQuality>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCompositingQuality(GpGraphics *graphics, CompositingQuality *compositingQuality)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapBaseCap: customCap baseCap: baseCap [
	<ulong: GdipGetCustomLineCapBaseCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapBaseCap(GpCustomLineCap* customCap, GpLineCap* baseCap)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapBaseInset: customCap inset: inset [
	<ulong: GdipGetCustomLineCapBaseInset>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapBaseInset(GpCustomLineCap* customCap, REAL* inset)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap [
	<ulong: GdipGetCustomLineCapStrokeCaps>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapStrokeCaps(GpCustomLineCap* customCap, GpLineCap* startCap, GpLineCap* endCap)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin [
	<ulong: GdipGetCustomLineCapStrokeJoin>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapStrokeJoin(GpCustomLineCap* customCap, GpLineJoin* lineJoin)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapType: customCap capType: capType [
	<ulong: GdipGetCustomLineCapType>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapType(GpCustomLineCap* customCap, CustomLineCapType* capType)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipGetCustomLineCapWidthScale: customCap widthScale: widthScale [
	<ulong: GdipGetCustomLineCapWidthScale>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetCustomLineCapWidthScale(GpCustomLineCap* customCap, REAL* widthScale)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetDC: graphics hdc: hdc [
	<ulong: GdipGetDC>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetDC(GpGraphics *graphics, HDC *hdc)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetDpiX: graphics dpi: dpi [
	<ulong: GdipGetDpiX>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetDpiX(GpGraphics *graphics, REAL *dpi)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetDpiY: graphics dpi: dpi [
	<ulong: GdipGetDpiY>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetDpiY(GpGraphics *graphics, REAL *dpi)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetEmHeight: family style: style emHeight: emHeight [
	<ulong: GdipGetEmHeight>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetEmHeight(GDIPCONST GpFontFamily *family, INT style, UINT16 * EmHeight)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetEncoderParameterList: image
clsidEncoder: clsidEncoder
size: size
buffer: buffer [
	<ulong: GdipGetEncoderParameterList>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetEncoderParameterList(GpImage *image, GDIPCONST CLSID* clsidEncoder, UINT size, EncoderParameters* buffer)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetEncoderParameterListSize: image clsidEncoder: clsidEncoder size: size [
	<ulong: GdipGetEncoderParameterListSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetEncoderParameterListSize(GpImage *image, GDIPCONST CLSID* clsidEncoder, UINT* size)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFamily: font family: family [
	<ulong: GdipGetFamily>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFamily(GpFont *font, GpFontFamily **family)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFamilyName: family name: name language: language [
	<ulong: GdipGetFamilyName>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFamilyName(GDIPCONST GpFontFamily *family, WCHAR name[LF_FACESIZE], LANGID language);
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontCollectionFamilyCount: fontCollection numFound: numFound [
	<ulong: GdipGetFontCollectionFamilyCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontCollectionFamilyCount(GpFontCollection* fontCollection, INT *numFound)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontCollectionFamilyList: fontCollection
numSought: numSought
gpfamilies: gpfamilies
numFound: numFound [
	<ulong: GdipGetFontCollectionFamilyList>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontCollectionFamilyList(GpFontCollection* fontCollection, INT numSought, GpFontFamily *gpfamilies[], INT* numFound)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontHeight: font graphics: graphics height: height [
	<ulong: GdipGetFontHeight>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontHeight(GDIPCONST GpFont *font, GDIPCONST GpGraphics *graphics, REAL *height)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontHeightGivenDPI: font dpi: dpi height: height [
	<ulong: GdipGetFontHeightGivenDPI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontHeightGivenDPI(GDIPCONST GpFont *font, REAL dpi, REAL *height)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontSize: font size: size [
	<ulong: GdipGetFontSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontSize(GpFont *font, REAL *size)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontStyle: font style: style [
	<ulong: GdipGetFontStyle>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontStyle(GpFont *font, INT *style)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetFontUnit: font unit: unit [
	<ulong: GdipGetFontUnit>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetFontUnit(GpFont *font, Unit *unit)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetGenericFontFamilyMonospace: nativeFamily [
	<ulong: GdipGetGenericFontFamilyMonospace>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetGenericFontFamilyMonospace(GpFontFamily **nativeFamily)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetGenericFontFamilySansSerif: nativeFamily [
	<ulong: GdipGetGenericFontFamilySansSerif>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetGenericFontFamilySansSerif(GpFontFamily **nativeFamily)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetGenericFontFamilySerif: nativeFamily [
	<ulong: GdipGetGenericFontFamilySerif>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetGenericFontFamilySerif(GpFontFamily **nativeFamily)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetHatchBackgroundColor: brush backcol: anARGB [
	<ulong: GdipGetHatchBackgroundColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetHatchBackgroundColor(GpHatch *brush, ARGB* backcol);
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetHatchForegroundColor: brush forecol: forecol [
	<ulong: GdipGetHatchForegroundColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetHatchForegroundColor(GpHatch *brush, ARGB* forecol);
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetHatchStyle: brush hatchstyle: hatchstyle [
	<ulong: GdipGetHatchStyle>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetHatchStyle(GpHatch *brush, GpHatchStyle *hatchstyle);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetHemfFromMetafile: metafile hEmf: hEmf [
	<ulong: GdipGetHemfFromMetafile>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetHemfFromMetafile(GpMetafile *metafile, HENHMETAFILE *hEmf);
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageAttributesAdjustedPalette: imageAttr colorPalette: colorPalette colorAdjustType: colorAdjustType [
	<ulong: GdipGetImageAttributesAdjustedPalette>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageAttributesAdjustedPalette(GpImageAttributes *imageAttr, ColorPalette * colorPalette, ColorAdjustType colorAdjustType)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageBounds: image srcRect: srcRect srcUnit: srcUnit [
	<ulong: GdipGetImageBounds>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageBounds(GpImage *image, GpRectF *srcRect, GpUnit *srcUnit)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageDecoders: numDecoders size: size decoders: decoders [
	<ulong: GdipGetImageDecoders>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageDecoders(UINT numDecoders, UINT size, ImageCodecInfo *decoders);
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageDecodersSize: numDecoders size: size [
	<ulong: GdipGetImageDecodersSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageDecodersSize(UINT *numDecoders, UINT *size);
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageDimension: image width: width height: height [
	<ulong: GdipGetImageDimension>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageDimension(GpImage *image, REAL *width, REAL *height)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageEncoders: numEncoders size: size encoders: encoders [
	<ulong: GdipGetImageEncoders>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageEncoders(UINT numEncoders, UINT size, ImageCodecInfo *encoders);
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageEncodersSize: numEncoders size: size [
	<ulong: GdipGetImageEncodersSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageEncodersSize(UINT *numEncoders, UINT *size);
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageFlags: image flags: flags [
	<ulong: GdipGetImageFlags>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageFlags(GpImage *image, UINT *flags)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageGraphicsContext: image graphics: graphics [
	<ulong: GdipGetImageGraphicsContext>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageGraphicsContext(GpImage *image, GpGraphics **graphics)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageHeight: image height: height [
	<ulong: GdipGetImageHeight>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageHeight(GpImage *image, UINT *height)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageHorizontalResolution: image resolution: resolution [
	<ulong: GdipGetImageHorizontalResolution>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageHorizontalResolution(GpImage *image, REAL *resolution)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImagePalette: image palette: palette size: size [
	<ulong: GdipGetImagePalette>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImagePalette(GpImage *image, ColorPalette *palette, INT size)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImagePaletteSize: image size: size [
	<ulong: GdipGetImagePaletteSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImagePaletteSize(GpImage *image, INT *size)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImagePixelFormat: image format: format [
	<ulong: GdipGetImagePixelFormat>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImagePixelFormat(GpImage *image, PixelFormat *format)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageRawFormat: image format: format [
	<ulong: GdipGetImageRawFormat>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageRawFormat(GpImage *image, GUID *format)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageThumbnail: image
thumbWidth: thumbWidth
thumbHeight: thumbHeight
thumbImage: thumbImage
callback: callback
callbackData: callbackData [
	<ulong: GdipGetImageThumbnail>
	^self invalidArgument
"
GpStatus WINGDIPAPI
GdipGetImageThumbnail(GpImage *image, UINT thumbWidth, UINT thumbHeight, GpImage **thumbImage, GetThumbnailImageAbort callback, VOID * callbackData)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageType: image type: type [
	<ulong: GdipGetImageType>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageType(GpImage *image, ImageType *type)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageVerticalResolution: image resolution: resolution [
	<ulong: GdipGetImageVerticalResolution>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageVerticalResolution(GpImage *image, REAL *resolution)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetImageWidth: image width: width [
	<ulong: GdipGetImageWidth>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetImageWidth(GpImage *image, UINT *width)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetInterpolationMode: graphics interpolationMode: interpolationMode [
	<ulong: GdipGetInterpolationMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetInterpolationMode(GpGraphics *graphics, InterpolationMode *interpolationMode)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipGetLineBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineBlend(GpLineGradient *brush, REAL *blend, REAL* positions, INT count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineBlendCount: brush count: count [
	<ulong: GdipGetLineBlendCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineBlendCount(GpLineGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineColors: brush colors: colors [
	<ulong: GdipGetLineColors>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineColors(GpLineGradient *brush, ARGB* colors)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection [
	<ulong: GdipGetLineGammaCorrection>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineGammaCorrection(GpLineGradient *brush, BOOL *useGammaCorrection)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLinePresetBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipGetLinePresetBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLinePresetBlend(GpLineGradient *brush, ARGB *blend, REAL* positions, INT count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLinePresetBlendCount: brush count: count [
	<ulong: GdipGetLinePresetBlendCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLinePresetBlendCount(GpLineGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineRect: brush rect: rect [
	<ulong: GdipGetLineRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineRect(GpLineGradient *brush, GpRectF *rect)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineRectI: brush rect: rect [
	<ulong: GdipGetLineRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineRectI(GpLineGradient *brush, GpRect *rect)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetLineSpacing: family style: style lineSpacing: lineSpacing [
	<ulong: GdipGetLineSpacing>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineSpacing(GDIPCONST GpFontFamily *family, INT style, UINT16 * LineSpacing)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineTransform: brush matrix: matrix [
	<ulong: GdipGetLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineTransform(GpLineGradient *brush, GpMatrix *matrix)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetLineWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipGetLineWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLineWrapMode(GpLineGradient *brush, GpWrapMode *wrapmode)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetLogFontA: font graphics: graphics logfontA: logfontA [
	<ulong: GdipGetLogFontA>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLogFontA(GpFont * font, GpGraphics *graphics, LOGFONTA * logfontA)
"]

{ #category : #fonts }
GDIPlusDLL >> GdipGetLogFontW: font graphics: graphics logfontW: logfontW [
	<ulong: GdipGetLogFontW>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetLogFontW(GpFont * font, GpGraphics *graphics, LOGFONTW * logfontW);
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipGetMatrixElements: matrix matrixOut: matrixOut [
	<ulong: GdipGetMatrixElements>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMatrixElements(GDIPCONST GpMatrix *matrix, REAL *matrixOut)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi [
	<ulong: GdipGetMetafileDownLevelRasterizationLimit>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMetafileDownLevelRasterizationLimit(GDIPCONST GpMetafile *metafile, UINT *metafileRasterizationLimitDpi);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetMetafileHeaderFromEmf: hEmf header: header [
	<ulong: GdipGetMetafileHeaderFromEmf>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMetafileHeaderFromEmf(HENHMETAFILE hEmf, MetafileHeader *header);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetMetafileHeaderFromFile: filename header: header [
	<ulong: GdipGetMetafileHeaderFromFile>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMetafileHeaderFromFile(GDIPCONST WCHAR* filename, MetafileHeader *header);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetMetafileHeaderFromMetafile: metafile header: header [
	<ulong: GdipGetMetafileHeaderFromMetafile>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMetafileHeaderFromMetafile(GpMetafile *metafile, MetafileHeader *header);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetMetafileHeaderFromStream: stream header: header [
	<ulong: GdipGetMetafileHeaderFromStream>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetMetafileHeaderFromStream(IStream *stream, MetafileHeader *header);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetNearestColor: graphics argb: argb [
	<ulong: GdipGetNearestColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetNearestColor(GpGraphics *graphics, ARGB* argb)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPageScale: graphics scale: scale [
	<ulong: GdipGetPageScale>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPageScale(GpGraphics *graphics, REAL *scale)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPageUnit: graphics unit: unit [
	<ulong: GdipGetPageUnit>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPageUnit(GpGraphics *graphics, GpUnit *unit)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathData: path pathData: pathData [
	<ulong: GdipGetPathData>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathData(GpPath *path, GpPathData* pathData)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathFillMode: path fillMode: fillmode [
	<ulong: GdipGetPathFillMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathFillMode(GpPath *path, GpFillMode *fillmode)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipGetPathGradientBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientBlend(GpPathGradient *brush, REAL *blend, REAL *positions, INT count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientBlendCount: brush count: count [
	<ulong: GdipGetPathGradientBlendCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientBlendCount(GpPathGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientCenterColor: brush colors: colors [
	<ulong: GdipGetPathGradientCenterColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetPathGradientCenterColor(GpPathGradient *brush, ARGB* colors)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientCenterPoint: brush points: points [
	<ulong: GdipGetPathGradientCenterPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetPathGradientCenterPoint(GpPathGradient *brush, GpPointF* points)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientCenterPointI: brush points: points [
	<ulong: GdipGetPathGradientCenterPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientCenterPointI(GpPathGradient *brush, GpPoint* points)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientFocusScales: brush xScale: xScale yScale: yScale [
	<ulong: GdipGetPathGradientFocusScales>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientFocusScales(GpPathGradient *brush, REAL* xScale, REAL* yScale)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection [
	<ulong: GdipGetPathGradientGammaCorrection>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientGammaCorrection(GpPathGradient *brush, BOOL *useGammaCorrection)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientPath: brush path: path [
	<ulong: GdipGetPathGradientPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientPath(GpPathGradient *brush, GpPath *path)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientPointCount: brush count: count [
	<ulong: GdipGetPathGradientPointCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientPointCount(GpPathGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientPresetBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipGetPathGradientPresetBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientPresetBlend(GpPathGradient *brush, ARGB *blend, REAL* positions, INT count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientPresetBlendCount: brush count: count [
	<ulong: GdipGetPathGradientPresetBlendCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetPathGradientPresetBlendCount(GpPathGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientRect: brush rect: rect [
	<ulong: GdipGetPathGradientRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientRect(GpPathGradient *brush, GpRectF *rect)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientRectI: brush rect: rect [
	<ulong: GdipGetPathGradientRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientRectI(GpPathGradient *brush, GpRect *rect)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientSurroundColorCount: brush count: count [
	<ulong: GdipGetPathGradientSurroundColorCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientSurroundColorCount(GpPathGradient *brush, INT *count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientSurroundColorsWithCount: brush color: color count: count [
	<ulong: GdipGetPathGradientSurroundColorsWithCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientSurroundColorsWithCount(GpPathGradient *brush, ARGB* color, INT* count)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientTransform: brush matrix: matrix [
	<ulong: GdipGetPathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetPathGradientTransform(GpPathGradient *brush, GpMatrix *matrix)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPathGradientWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipGetPathGradientWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathGradientWrapMode(GpPathGradient *brush, GpWrapMode *wrapmode)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathLastPoint: path lastPoint: lastPoint [
	<ulong: GdipGetPathLastPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathLastPoint(GpPath* path, GpPointF* lastPoint)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathPoints: gpPath points: points count: count [
	<ulong: GdipGetPathPoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathPoints(GpPath*, GpPointF* points, INT count)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathPointsI: gpPath points: points count: count [
	<ulong: GdipGetPathPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathPointsI(GpPath*, GpPoint* points, INT count)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathTypes: path types: types count: count [
	<ulong: GdipGetPathTypes>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathTypes(GpPath* path, BYTE* types, INT count)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathWorldBounds: path
bounds: bounds
matrix: matrix
pen: pen [
	<ulong: GdipGetPathWorldBounds>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathWorldBounds(GpPath* path, GpRectF* bounds, GDIPCONST GpMatrix *matrix, GDIPCONST GpPen *pen)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPathWorldBoundsI: path
bounds: bounds
matrix: matrix
pen: pen [
	<ulong: GdipGetPathWorldBoundsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPathWorldBoundsI(GpPath* path, GpRect* bounds, GDIPCONST GpMatrix *matrix, GDIPCONST GpPen *pen)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetPenBrushFill: pen brush: brush [
	<ulong: GdipGetPenBrushFill>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenBrushFill(GpPen *pen, GpBrush **brush)
"]

{ #category : #pen }
GDIPlusDLL >> GdipGetPenColor: pen argb: argb [
	<ulong: GdipGetPenColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenColor(GpPen *pen, ARGB *argb)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenCompoundArray: pen dash: dash count: count [
	<ulong: GdipGetPenCompoundArray>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenCompoundArray(GpPen *pen, REAL *dash, INT count)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenCompoundCount: pen count: count [
	<ulong: GdipGetPenCompoundCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenCompoundCount(GpPen *pen, INT *count)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenCustomEndCap: pen customCap: customCap [
	<ulong: GdipGetPenCustomEndCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenCustomEndCap(GpPen *pen, GpCustomLineCap** customCap)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenCustomStartCap: pen customCap: customCap [
	<ulong: GdipGetPenCustomStartCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenCustomStartCap(GpPen *pen, GpCustomLineCap** customCap)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenDashArray: pen dash: dash count: count [
	<ulong: GdipGetPenDashArray>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenDashArray(GpPen *pen, REAL *dash, INT count)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenDashCap197819: pen dashCap: dashCap [
	<ulong: GdipGetPenDashCap197819>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenDashCap197819(GpPen *pen, GpDashCap *dashCap)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenDashCount: pen count: count [
	<ulong: GdipGetPenDashCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenDashCount(GpPen *pen, INT *count)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenDashOffset: pen offset: offset [
	<ulong: GdipGetPenDashOffset>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenDashOffset(GpPen *pen, REAL *offset)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenDashStyle: pen dashstyle: dashstyle [
	<ulong: GdipGetPenDashStyle>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenDashStyle(GpPen *pen, GpDashStyle *dashstyle)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenEndCap: pen endCap: endCap [
	<ulong: GdipGetPenEndCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenEndCap(GpPen *pen, GpLineCap *endCap)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenFillType: pen type: type [
	<ulong: GdipGetPenFillType>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenFillType(GpPen *pen, GpPenType* type)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenLineJoin: pen lineJoin: lineJoin [
	<ulong: GdipGetPenLineJoin>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenLineJoin(GpPen *pen, GpLineJoin *lineJoin)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenMiterLimit: pen miterLimit: miterLimit [
	<ulong: GdipGetPenMiterLimit>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenMiterLimit(GpPen *pen, REAL *miterLimit)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenMode: pen penMode: penMode [
	<ulong: GdipGetPenMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenMode(GpPen *pen, GpPenAlignment *penMode)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenStartCap: pen startCap: startCap [
	<ulong: GdipGetPenStartCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenStartCap(GpPen *pen, GpLineCap *startCap)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenTransform: pen matrix: matrix [
	<ulong: GdipGetPenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenTransform(GpPen *pen, GpMatrix *matrix)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenUnit: pen unit: unit [
	<ulong: GdipGetPenUnit>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenUnit(GpPen *pen, GpUnit *unit)
"]

{ #category : #'pen functions' }
GDIPlusDLL >> GdipGetPenWidth: pen width: width [
	<ulong: GdipGetPenWidth>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPenWidth(GpPen *pen, REAL *width)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode [
	<ulong: GdipGetPixelOffsetMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPixelOffsetMode(GpGraphics *graphics, PixelOffsetMode *pixelOffsetMode)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetPointCount: path count: count [
	<ulong: GdipGetPointCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPointCount(GpPath* path, INT* count)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetPropertyCount: image numOfProperty: numOfProperty [
	<ulong: GdipGetPropertyCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPropertyCount(GpImage *image, UINT* numOfProperty)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetPropertyIdList: image numOfProperty: numOfProperty list: list [
	<ulong: GdipGetPropertyIdList>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPropertyIdList(GpImage *image, UINT numOfProperty, PROPID* list)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetPropertyItem: image
propId: propId
propSize: propSize
buffer: buffer [
	<ulong: GdipGetPropertyItem>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPropertyItem(GpImage *image, PROPID propId,UINT propSize, PropertyItem* buffer)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetPropertyItemSize: image propId: propId size: size [
	<ulong: GdipGetPropertyItemSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPropertyItemSize(GpImage *image, PROPID propId, UINT* size)
"]

{ #category : #images }
GDIPlusDLL >> GdipGetPropertySize: image totalBufferSize: totalBufferSize numProperties: numProperties [
	<ulong: GdipGetPropertySize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetPropertySize(GpImage *image, UINT* totalBufferSize, UINT* numProperties)
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionBounds: region graphics: graphics rect: aRectF [
	<ulong: GdipGetRegionBounds>
	^self invalidArgument

"
    GpStatus WINGDIPAPI GdipGetRegionBounds(
        GpRegion *region,
        GpGraphics *graphics,
        GpRectF *rect
    );
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionBoundsI: region graphics: graphics [
	<ulong: GdipGetRegionBoundsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionBoundsI(GpRegion *region, GpGraphics *graphics);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionBoundsI: region graphics: graphics rect: rect [
	<ulong: GdipGetRegionBoundsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionBoundsI(GpRegion *region, GpGraphics *graphics, GpRect *rect);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionData: region
buffer: buffer
bufferSize: bufferSize
sizeFilled: sizeFilled [
	<ulong: GdipGetRegionData>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionData(GpRegion *region, BYTE * buffer, UINT bufferSize, UINT * sizeFilled);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionDataSize: region bufferSize: bufferSize [
	<ulong: GdipGetRegionDataSize>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionDataSize(GpRegion *region, UINT * bufferSize);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionHRgn: region graphics: graphics hRgn: hRgn [
	<ulong: GdipGetRegionHRgn>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionHRgn(GpRegion *region, GpGraphics *graphics, HRGN *hRgn);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionScans: region
rects: rects
count: count
matrix: matrix [
	<ulong: GdipGetRegionScans>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionScans(GpRegion *region, GpRectF* rects, INT* count, GpMatrix* matrix);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionScansCount: region count: count matrix: matrix [
	<ulong: GdipGetRegionScansCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionScansCount(GpRegion *region, UINT* count, GpMatrix* matrix);
"]

{ #category : #regions }
GDIPlusDLL >> GdipGetRegionScansI: region
rects: rects
count: count
matrix: matrix [
	<ulong: GdipGetRegionScansI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRegionScansI(GpRegion *region, GpRect* rects, INT* count, GpMatrix* matrix);
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetRenderingOrigin: graphics x: x y: y [
	<ulong: GdipGetRenderingOrigin>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetRenderingOrigin(GpGraphics *graphics, INT *x, INT *y)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetSmoothingMode: graphics smoothingMode: smoothingMode [
	<ulong: GdipGetSmoothingMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetSmoothingMode(GpGraphics *graphics, SmoothingMode *smoothingMode)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetSolidFillColor: brush color: color [
	<ulong: GdipGetSolidFillColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetSolidFillColor(GpSolidFill *brush, ARGB *color);
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatAlign: format align: align [
	<ulong: GdipGetStringFormatAlign>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatAlign(GDIPCONST GpStringFormat *format, StringAlignment *align)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatDigitSubstitution: format language: language substitute: substitute [
	<ulong: GdipGetStringFormatDigitSubstitution>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatDigitSubstitution(GDIPCONST GpStringFormat *format, LANGID *language, StringDigitSubstitute *substitute)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatFlags: format flags: flags [
	<ulong: GdipGetStringFormatFlags>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipGetStringFormatFlags(GDIPCONST GpStringFormat *format, INT *flags)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix [
	<ulong: GdipGetStringFormatHotkeyPrefix>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatHotkeyPrefix(GDIPCONST GpStringFormat *format, INT *hotkeyPrefix)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatLineAlign: format align: align [
	<ulong: GdipGetStringFormatLineAlign>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatLineAlign(GDIPCONST GpStringFormat *format, StringAlignment *align)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatMeasurableCharacterRangeCount: format count: count [
	<ulong: GdipGetStringFormatMeasurableCharacterRangeCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatMeasurableCharacterRangeCount(GDIPCONST GpStringFormat *format, INT *count)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatTabStopCount: format count: count [
	<ulong: GdipGetStringFormatTabStopCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatTabStopCount(GDIPCONST GpStringFormat *format, INT * count)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatTabStops: format
count: count
firstTabOffset: firstTabOffset
tabStops: tabStops [
	<ulong: GdipGetStringFormatTabStops>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatTabStops(GDIPCONST GpStringFormat *format, INT count, REAL *firstTabOffset, REAL *tabStops)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipGetStringFormatTrimming: format trimming: trimming [
	<ulong: GdipGetStringFormatTrimming>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetStringFormatTrimming(GDIPCONST GpStringFormat *format, StringTrimming *trimming)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetTextContrast: graphics contrast: contrast [
	<ulong: GdipGetTextContrast>
	^self invalidArgument

"
GpStatus  WINGDIPAPI
GdipGetTextContrast(GpGraphics *graphics, UINT * contrast)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetTextRenderingHint: graphics mode: mode [
	<ulong: GdipGetTextRenderingHint>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetTextRenderingHint(GpGraphics *graphics, TextRenderingHint *mode)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetTextureImage: brush image: image [
	<ulong: GdipGetTextureImage>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetTextureImage(GpTexture *brush, GpImage **image)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipGetTextureTransform: brush matrix: matrix [
	<ulong: GdipGetTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI  GdipGetTextureTransform(GpTexture *brush, GpMatrix *matrix)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetTextureWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipGetTextureWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetTextureWrapMode(GpTexture *brush, GpWrapMode *wrapmode)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetVisibleClipBounds: graphics rect: rect [
	<ulong: GdipGetVisibleClipBounds>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetVisibleClipBounds(GpGraphics *graphics, GpRectF *rect)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetVisibleClipBoundsI: graphics rect: rect [
	<ulong: GdipGetVisibleClipBoundsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetVisibleClipBoundsI(GpGraphics *graphics, GpRect *rect)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGetWorldTransform: graphics matrix: matrix [
	<ulong: GdipGetWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGetWorldTransform(GpGraphics *graphics, GpMatrix *matrix)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipGraphicsClear: graphics color: color [
	<ulong: GdipGraphicsClear>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipGraphicsClear(GpGraphics *graphics, ARGB color)
"]

{ #category : #images }
GDIPlusDLL >> GdipImageForceValidation: image [
	<ulong: GdipImageForceValidation>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageForceValidation(GpImage *image) 
"]

{ #category : #images }
GDIPlusDLL >> GdipImageGetFrameCount: image dimensionID: aGUID count: count [
	<ulong: GdipImageGetFrameCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageGetFrameCount(GpImage *image, GDIPCONST GUID* dimensionID, UINT* count) 
"]

{ #category : #images }
GDIPlusDLL >> GdipImageGetFrameDimensionsCount: image count: count [
	<ulong: GdipImageGetFrameDimensionsCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageGetFrameDimensionsCount(GpImage* image, UINT* count) 
"]

{ #category : #images }
GDIPlusDLL >> GdipImageGetFrameDimensionsList: image dimensionIDs: dimensionIDs count: count [
	<ulong: GdipImageGetFrameDimensionsList>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageGetFrameDimensionsList(GpImage* image, GUID* dimensionIDs, UINT count) 
"]

{ #category : #images }
GDIPlusDLL >> GdipImageRotateFlip: image rfType: rfType [
	<ulong: GdipImageRotateFlip>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageRotateFlip(GpImage *image, RotateFlipType rfType) 
"]

{ #category : #images }
GDIPlusDLL >> GdipImageSelectActiveFrame: image dimensionID: dimensionID frameIndex: frameIndex [
	<ulong: GdipImageSelectActiveFrame>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipImageSelectActiveFrame(GpImage *image, GDIPCONST GUID* dimensionID, UINT frameIndex) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipInvertMatrix: matrix [
	<ulong: GdipInvertMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipInvertMatrix(GpMatrix *matrix) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsClipEmpty: graphics result: result [
	<ulong: GdipIsClipEmpty>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsClipEmpty(GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsEmptyRegion: region graphics: graphics result: result [
	<ulong: GdipIsEmptyRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsEmptyRegion(GpRegion *region, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsEqualRegion: region
region2: region2
graphics: graphics
result: result [
	<ulong: GdipIsEqualRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsEqualRegion(GpRegion *region, GpRegion *region2, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsInfiniteRegion: region graphics: graphics result: result [
	<ulong: GdipIsInfiniteRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsInfiniteRegion(GpRegion *region, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsMatrixEqual: matrix matrix2: matrix2 result: result [
	<ulong: GdipIsMatrixEqual>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsMatrixEqual(GDIPCONST GpMatrix *matrix, GDIPCONST GpMatrix *matrix2, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsMatrixIdentity: matrix result: result [
	<ulong: GdipIsMatrixIdentity>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsMatrixIdentity(GDIPCONST GpMatrix *matrix, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsMatrixInvertible: matrix result: result [
	<ulong: GdipIsMatrixInvertible>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsMatrixInvertible(GDIPCONST GpMatrix *matrix, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsOutlineVisiblePathPoint: path
x: x
y: y
pen: pen
graphics: graphics
result: result [
	<ulong: GdipIsOutlineVisiblePathPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsOutlineVisiblePathPoint(GpPath* path, REAL x, REAL y, GpPen *pen, GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsOutlineVisiblePathPointI: path
x: x
y: y
pen: pen
graphics: graphics
result: result [
	<ulong: GdipIsOutlineVisiblePathPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsOutlineVisiblePathPointI(GpPath* path, INT x, INT y, GpPen *pen, GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsStyleAvailable: family style: style isStyleAvailable: isStyleAvailable [
	<ulong: GdipIsStyleAvailable>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsStyleAvailable(GDIPCONST GpFontFamily *family, INT style, BOOL * IsStyleAvailable) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleClipEmpty: graphics result: result [
	<ulong: GdipIsVisibleClipEmpty>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleClipEmpty(GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisiblePathPoint: path
x: x
y: y
graphics: graphics
result: result [
	<ulong: GdipIsVisiblePathPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisiblePathPoint(GpPath* path, REAL x, REAL y, GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisiblePathPointI: path
x: x
y: y
graphics: graphics
result: result [
	<ulong: GdipIsVisiblePathPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisiblePathPointI(GpPath* path, INT x, INT y, GpGraphics *graphics, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisiblePoint: graphics
x: x
y: y
result: result [
	<ulong: GdipIsVisiblePoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisiblePoint(GpGraphics *graphics, REAL x, REAL y, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisiblePointI: graphics
x: x
y: y
result: result [
	<ulong: GdipIsVisiblePointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisiblePointI(GpGraphics *graphics, INT x, INT y, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRect: graphics
x: x
y: y
width: width
height: height
result: result [
	<ulong: GdipIsVisibleRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRect(GpGraphics *graphics, REAL x, REAL y, REAL width, REAL height, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRectI: graphics
x: x
y: y
width: width
height: height
result: result [
	<ulong: GdipIsVisibleRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRectI(GpGraphics *graphics, INT x, INT y, INT width, INT height, BOOL *result) 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRegionPoint: region
x: x
y: y
graphics: graphics
result: result [
	<ulong: GdipIsVisibleRegionPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRegionPoint(GpRegion *region, REAL x, REAL y, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRegionPointI: region
x: x
y: y
graphics: graphics
result: result [
	<ulong: GdipIsVisibleRegionPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRegionPointI(GpRegion *region, INT x, INT y, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRegionRect: region
x: x
y: y
width: width
height: height
graphics: graphics
result: result [
	<ulong: GdipIsVisibleRegionRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRegionRect(GpRegion *region, REAL x, REAL y, REAL width, REAL height, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #testing }
GDIPlusDLL >> GdipIsVisibleRegionRectI: region
x: x
y: y
width: width
height: height
graphics: graphics
result: result [
	<ulong: GdipIsVisibleRegionRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipIsVisibleRegionRectI(GpRegion *region, INT x, INT y, INT width, INT height, GpGraphics *graphics, BOOL *result); 
"]

{ #category : #images }
GDIPlusDLL >> GdipLoadImageFromFile: filename image: image [
	<ulong: GdipLoadImageFromFile>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipLoadImageFromFile(GDIPCONST WCHAR* filename, GpImage **image) 
"]

{ #category : #images }
GDIPlusDLL >> GdipLoadImageFromFileICM: filename image: image [
	<ulong: GdipLoadImageFromFileICM>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipLoadImageFromFileICM(GDIPCONST WCHAR* filename, GpImage **image) 
"]

{ #category : #images }
GDIPlusDLL >> GdipLoadImageFromStream: stream image: image [
	<ulong: GdipLoadImageFromStream>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipLoadImageFromStream(IStream* stream, GpImage **image) 
"]

{ #category : #images }
GDIPlusDLL >> GdipLoadImageFromStreamICM: stream image: image [
	<ulong: GdipLoadImageFromStreamICM>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipLoadImageFromStreamICM(IStream* stream, GpImage **image) 
"]

{ #category : #other }
GDIPlusDLL >> GdiplusShutdown: token [
	<ulong: GdiplusShutdown>
	^self invalidArgument

"
void GdiplusShutdown( ULONG_PTR token ); 
"]

{ #category : #other }
GDIPlusDLL >> GdiplusStartup: ptoken startupInput: gdiplusStartupInput startupOutput: gdiplusStartupOutput [
	<ulong: GdiplusStartup>
	^self invalidArgument

"
Status GdiplusStartup( ULONG_PTR token *token, const GdiplusStartupInput *input, GdiplusStartupOutput *output ); 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipMeasureCharacterRanges: graphics
string: unicodeString
length: length
font: font
layoutRect: layoutRect
stringFormat: stringFormat
regionCount: regionCount
regions: regions [
	<ulong: GdipMeasureCharacterRanges>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMeasureCharacterRanges(
	GpGraphics *graphics
	GDIPCONST WCHAR *string
	INT length
	GDIPCONST GpFont *font
	GDIPCONST RectF *layoutRect
	GDIPCONST GpStringFormat *stringFormat
	INT regionCount
	GpRegion **regions
); 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipMeasureDriverString: graphics
text: text
length: length
font: font
positions: positions
flags: flags
matrix: matrix
boundingBox: boundingBox [
	<ulong: GdipMeasureDriverString>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMeasureDriverString( GpGraphics *graphics, GDIPCONST UINT16 *text, INT length, GDIPCONST GpFont *font, GDIPCONST PointF *positions, INT flags, GDIPCONST GpMatrix *matrix, RectF *boundingBox ); 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipMeasureString: graphics
string: unicodeString
length: length
font: font
layoutRect: layoutRect
stringFormat: stringFormat
boundingBox: boundingBox
codepointsFitted: codepointsFitted
linesFilled: linesFilled [
	<ulong: GdipMeasureString>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMeasureString( GpGraphics *graphics, GDIPCONST WCHAR *string, INT length, GDIPCONST GpFont *font, GDIPCONST RectF *layoutRect, GDIPCONST GpStringFormat *stringFormat, RectF *boundingBox, INT *codepointsFitted, INT *linesFilled ); 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipMultiplyLineTransform: brush matrix: matrix order: order [
	<ulong: GdipMultiplyLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyLineTransform(GpLineGradient* brush, GDIPCONST GpMatrix *matrix, GpMatrixOrder order) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipMultiplyMatrix: matrix matrix2: matrix2 order: order [
	<ulong: GdipMultiplyMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyMatrix(GpMatrix *matrix, GpMatrix* matrix2, GpMatrixOrder order) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipMultiplyPathGradientTransform: brush matrix: matrix order: order [
	<ulong: GdipMultiplyPathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyPathGradientTransform(GpPathGradient* brush, GDIPCONST GpMatrix *matrix, GpMatrixOrder order) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipMultiplyPenTransform: pen matrix: matrix order: order [
	<ulong: GdipMultiplyPenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyPenTransform(GpPen *pen, GDIPCONST GpMatrix *matrix, GpMatrixOrder order) 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipMultiplyTextureTransform: brush matrix: matrix order: order [
	<ulong: GdipMultiplyTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyTextureTransform(GpTexture* brush, GDIPCONST GpMatrix *matrix, GpMatrixOrder order) 
"]

{ #category : #other }
GDIPlusDLL >> GdipMultiplyWorldTransform: graphics matrix: matrix order: order [
	<ulong: GdipMultiplyWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipMultiplyWorldTransform(GpGraphics *graphics, GDIPCONST GpMatrix *matrix, GpMatrixOrder order) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipNewInstalledFontCollection: fontCollection [
	<ulong: GdipNewInstalledFontCollection>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipNewInstalledFontCollection(GpFontCollection** fontCollection) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipNewPrivateFontCollection: fontCollection [
	<ulong: GdipNewPrivateFontCollection>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipNewPrivateFontCollection(GpFontCollection** fontCollection) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterCopyData: iterator
resultCount: resultCount
points: points
types: types
startIndex: startIndex
endIndex: endIndex [
	<ulong: GdipPathIterCopyData>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterCopyData(GpPathIterator* iterator, INT* resultCount, GpPointF* points, BYTE* types, INT startIndex, INT endIndex) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterEnumerate: iterator
resultCount: resultCount
points: points
types: types
count: count [
	<ulong: GdipPathIterEnumerate>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterEnumerate(GpPathIterator* iterator, INT* resultCount, GpPointF *points, BYTE *types, INT count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterGetCount: iterator count: count [
	<ulong: GdipPathIterGetCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterGetCount(GpPathIterator* iterator, INT* count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterGetSubpathCount: iterator count: count [
	<ulong: GdipPathIterGetSubpathCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterGetSubpathCount(GpPathIterator* iterator, INT* count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterHasCurve: iterator hasCurve: hasCurve [
	<ulong: GdipPathIterHasCurve>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterHasCurve(GpPathIterator* iterator, BOOL* hasCurve) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterIsValid: iterator valid: valid [
	<ulong: GdipPathIterIsValid>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterIsValid(GpPathIterator* iterator, BOOL* valid) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterNextMarker: iterator
resultCount: resultCount
startIndex: startIndex
endIndex: endIndex [
	<ulong: GdipPathIterNextMarker>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterNextMarker(GpPathIterator* iterator, INT *resultCount, INT* startIndex, INT* endIndex) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterNextMarkerPath: iterator resultCount: resultCount path: path [
	<ulong: GdipPathIterNextMarkerPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterNextMarkerPath(GpPathIterator* iterator, INT* resultCount, GpPath* path) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterNextPathType: iterator
resultCount: resultCount
pathType: pathType
startIndex: startIndex
endIndex: endIndex [
	<ulong: GdipPathIterNextPathType>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterNextPathType(GpPathIterator* iterator, INT* resultCount, BYTE* pathType, INT* startIndex, INT* endIndex) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterNextSubpath: iterator
resultCount: resultCount
startIndex: startIndex
endIndex: endIndex
isClosed: isClosed [
	<ulong: GdipPathIterNextSubpath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterNextSubpath(GpPathIterator* iterator, INT *resultCount, INT* startIndex, INT* endIndex, BOOL* isClosed) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterNextSubpathPath: iterator
resultCount: resultCount
path: path
isClosed: isClosed [
	<ulong: GdipPathIterNextSubpathPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterNextSubpathPath(GpPathIterator* iterator, INT* resultCount, GpPath* path, BOOL* isClosed) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipPathIterRewind: iterator [
	<ulong: GdipPathIterRewind>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPathIterRewind(GpPathIterator* iterator) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipPlayMetafileRecord: metafile
recordType: recordType
flags: flags
dataSize: dataSize
data: data [
	<ulong: GdipPlayMetafileRecord>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPlayMetafileRecord( GDIPCONST GpMetafile * metafile, EmfPlusRecordType recordType, UINT flags, UINT dataSize, GDIPCONST BYTE * data ) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipPrivateAddFontFile: fontCollection filename: filename [
	<ulong: GdipPrivateAddFontFile>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPrivateAddFontFile( GpFontCollection* fontCollection, GDIPCONST WCHAR* filename ) 
"]

{ #category : #fonts }
GDIPlusDLL >> GdipPrivateAddMemoryFont: fontCollection memory: memory length: length [
	<ulong: GdipPrivateAddMemoryFont>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipPrivateAddMemoryFont( GpFontCollection* fontCollection, GDIPCONST void* memory, INT length ) 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafile: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafile>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafile( HDC referenceHdc, EmfType type, GDIPCONST GpRectF * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafileFileName: fileName
referenceHdc: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafileFileName>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafileFileName( GDIPCONST WCHAR* fileName, HDC referenceHdc, EmfType type, GDIPCONST GpRectF * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafileFileNameI: fileName
referenceHdc: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafileFileNameI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafileFileNameI( GDIPCONST WCHAR* fileName, HDC referenceHdc, EmfType type, GDIPCONST GpRect * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafileI: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafileI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafileI( HDC referenceHdc, EmfType type, GDIPCONST GpRect * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafileStream: stream
referenceHdc: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafileStream>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafileStream( IStream * stream, HDC referenceHdc, EmfType type, GDIPCONST GpRectF * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #metafile }
GDIPlusDLL >> GdipRecordMetafileStreamI: stream
referenceHdc: referenceHdc
type: type
frameRect: frameRect
frameUnit: frameUnit
description: description
metafile: metafile [
	<ulong: GdipRecordMetafileStreamI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRecordMetafileStreamI( IStream * stream, HDC referenceHdc, EmfType type, GDIPCONST GpRect * frameRect, MetafileFrameUnit frameUnit, GDIPCONST WCHAR * description, GpMetafile ** metafile ); 
"]

{ #category : #other }
GDIPlusDLL >> GdipReleaseDC: graphics hdc: hdc [
	<ulong: GdipReleaseDC>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipReleaseDC(GpGraphics* graphics, HDC hdc) 
"]

{ #category : #other }
GDIPlusDLL >> GdipRemovePropertyItem: image propId: propId [
	<ulong: GdipRemovePropertyItem>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRemovePropertyItem(GpImage *image, PROPID propId) 
"]

{ #category : #other }
GDIPlusDLL >> GdipResetClip: graphics [
	<ulong: GdipResetClip>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetClip(GpGraphics *graphics) 
"]

{ #category : #images }
GDIPlusDLL >> GdipResetImageAttributes: imageattr type: type [
	<ulong: GdipResetImageAttributes>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetImageAttributes(GpImageAttributes *imageattr, ColorAdjustType type) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipResetLineTransform: brush [
	<ulong: GdipResetLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetLineTransform(GpLineGradient* brush) 
"]

{ #category : #other }
GDIPlusDLL >> GdipResetPageTransform: graphics [
	<ulong: GdipResetPageTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetPageTransform(GpGraphics *graphics) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipResetPath: path [
	<ulong: GdipResetPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetPath(GpPath* path) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipResetPathGradientTransform: brush [
	<ulong: GdipResetPathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetPathGradientTransform(GpPathGradient* brush) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipResetPenTransform: pen [
	<ulong: GdipResetPenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetPenTransform(GpPen *pen) 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipResetTextureTransform: brush [
	<ulong: GdipResetTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetTextureTransform(GpTexture* brush) 
"]

{ #category : #other }
GDIPlusDLL >> GdipResetWorldTransform: graphics [
	<ulong: GdipResetWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipResetWorldTransform(GpGraphics *graphics) 
"]

{ #category : #graphics }
GDIPlusDLL >> GdipRestoreGraphics: graphics state: state [
	<ulong: GdipRestoreGraphics>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRestoreGraphics(GpGraphics *graphics, GraphicsState state) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipReversePath: path [
	<ulong: GdipReversePath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipReversePath(GpPath* path) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipRotateLineTransform: brush angle: angle order: order [
	<ulong: GdipRotateLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotateLineTransform(GpLineGradient* brush, REAL angle, GpMatrixOrder order) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipRotateMatrix: matrix angle: angle order: order [
	<ulong: GdipRotateMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotateMatrix(GpMatrix *matrix, REAL angle, GpMatrixOrder order) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipRotatePathGradientTransform: brush angle: angle order: order [
	<ulong: GdipRotatePathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotatePathGradientTransform(GpPathGradient* brush, REAL angle, GpMatrixOrder order) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipRotatePenTransform: pen angle: angle order: order [
	<ulong: GdipRotatePenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotatePenTransform(GpPen *pen, REAL angle, GpMatrixOrder order) 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipRotateTextureTransform: brush angle: angle order: order [
	<ulong: GdipRotateTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotateTextureTransform(GpTexture* brush, REAL angle, GpMatrixOrder order) 
"]

{ #category : #other }
GDIPlusDLL >> GdipRotateWorldTransform: graphics angle: angle order: order [
	<ulong: GdipRotateWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipRotateWorldTransform(GpGraphics *graphics, REAL angle, GpMatrixOrder order) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipSaveAdd: image encoderParams: encoderParams [
	<ulong: GdipSaveAdd>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSaveAdd(GpImage *image, GDIPCONST EncoderParameters* encoderParams)
"]

{ #category : #images }
GDIPlusDLL >> GdipSaveAddImage: image newImage: newImage encoderParams: encoderParams [
	<ulong: GdipSaveAddImage>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSaveAddImage(GpImage *image, GpImage *newImage, GDIPCONST EncoderParameters *encoderParams)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipSaveGraphics: graphics state: state [
	<ulong: GdipSaveGraphics>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSaveGraphics(GpGraphics *graphics, GraphicsState *state)
"]

{ #category : #images }
GDIPlusDLL >> GdipSaveImageToFile: image
filename: filename
clsidEncoder: clsidEncoder
encoderParams: encoderParams [
	<ulong: GdipSaveImageToFile>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSaveImageToFile(GpImage *image, GDIPCONST WCHAR* filename, GDIPCONST CLSID* clsidEncoder, GDIPCONST EncoderParameters* encoderParams)
"]

{ #category : #images }
GDIPlusDLL >> GdipSaveImageToStream: image
stream: stream
clsidEncoder: clsidEncoder
encoderParams: encoderParams [
	<ulong: GdipSaveImageToStream>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSaveImageToStream(GpImage *image, IStream* stream, GDIPCONST CLSID* clsidEncoder, GDIPCONST EncoderParameters* encoderParams)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipScaleLineTransform: brush
sx: sx
sy: sy
order: order [
	<ulong: GdipScaleLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI  
GdipScaleLineTransform(GpLineGradient* brush, REAL sx, REAL sy, GpMatrixOrder order)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipScaleMatrix: matrix
scaleX: scaleX
scaleY: scaleY
order: order [
	<ulong: GdipScaleMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipScaleMatrix(GpMatrix *matrix, REAL scaleX, REAL scaleY, GpMatrixOrder order)
"]

{ #category : #paths }
GDIPlusDLL >> GdipScalePathGradientTransform: brush
sx: sx
sy: sy
order: order [
	<ulong: GdipScalePathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipScalePathGradientTransform(GpPathGradient* brush, REAL sx, REAL sy, GpMatrixOrder order)
"]

{ #category : #pen }
GDIPlusDLL >> GdipScalePenTransform: pen
sx: sx
sy: sy
order: order [
	<ulong: GdipScalePenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipScalePenTransform(GpPen *pen, REAL sx, REAL sy, GpMatrixOrder order)
"]

{ #category : #brushes }
GDIPlusDLL >> GdipScaleTextureTransform: brush
sx: sx
sy: sy
order: order [
	<ulong: GdipScaleTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipScaleTextureTransform(GpTexture* brush, REAL sx, REAL sy, GpMatrixOrder order)
"]

{ #category : #other }
GDIPlusDLL >> GdipScaleWorldTransform: graphics
sx: sx
sy: sy
order: order [
	<ulong: GdipScaleWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipScaleWorldTransform(GpGraphics *graphics, REAL sx, REAL sy,
GpMatrixOrder order)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipSetAdjustableArrowCapFillState: cap fillState: fillState [
	<ulong: GdipSetAdjustableArrowCapFillState>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetAdjustableArrowCapFillState(GpAdjustableArrowCap* cap, BOOL fillState)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipSetAdjustableArrowCapHeight: cap height: height [
	<ulong: GdipSetAdjustableArrowCapHeight>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetAdjustableArrowCapHeight(GpAdjustableArrowCap* cap, REAL height)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipSetAdjustableArrowCapMiddleInset: cap middleInset: middleInset [
	<ulong: GdipSetAdjustableArrowCapMiddleInset>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetAdjustableArrowCapMiddleInset(GpAdjustableArrowCap* cap, REAL middleInset)
"]

{ #category : #arrows }
GDIPlusDLL >> GdipSetAdjustableArrowCapWidth: cap width: width [
	<ulong: GdipSetAdjustableArrowCapWidth>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetAdjustableArrowCapWidth(GpAdjustableArrowCap* cap, REAL width)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipSetClipGraphics: graphics srcgraphics: srcgraphics combineMode: combineMode [
	<ulong: GdipSetClipGraphics>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetClipGraphics(GpGraphics *graphics, GpGraphics *srcgraphics, CombineMode combineMode)
"]

{ #category : #graphics }
GDIPlusDLL >> GdipSetClipHrgn: graphics hRgn: hRgn combineMode: combineMode [
	<ulong: GdipSetClipHrgn>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetClipHrgn(GpGraphics *graphics, HRGN hRgn, CombineMode combineMode)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetClipPath: graphics path: path combineMode: combineMode [
	<ulong: GdipSetClipPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetClipPath(GpGraphics *graphics, GpPath *path, CombineMode combineMode)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetClipRect: graphics
x: x
y: y
width: width
height: height
combineMode: combineMode [
	<ulong: GdipSetClipRect>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetClipRect(GpGraphics *graphics, REAL x, REAL y, REAL width, REAL height, CombineMode combineMode)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetClipRectI: graphics
x: x
y: y
width: width
height: height
combineMode: combineMode [
	<ulong: GdipSetClipRectI>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetClipRectI(GpGraphics *graphics, INT x, INT y, INT width, INT height, CombineMode combineMode)
"]

{ #category : #regions }
GDIPlusDLL >> GdipSetClipRegion: graphics region: region combineMode: combineMode [
	<ulong: GdipSetClipRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetClipRegion(GpGraphics *graphics, GpRegion *region, CombineMode combineMode)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetCompositingMode: graphics compositingMode: compositingMode [
	<ulong: GdipSetCompositingMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCompositingMode(GpGraphics *graphics, CompositingMode compositingMode)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetCompositingQuality: graphics compositingQuality: compositingQuality [
	<ulong: GdipSetCompositingQuality>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCompositingQuality(GpGraphics *graphics, CompositingQuality compositingQuality)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetCustomLineCapBaseCap: customCap baseCap: baseCap [
	<ulong: GdipSetCustomLineCapBaseCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCustomLineCapBaseCap(GpCustomLineCap* customCap, GpLineCap baseCap)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetCustomLineCapBaseInset: customCap inset: inset [
	<ulong: GdipSetCustomLineCapBaseInset>
	^self invalidArgument

"
GpStatus WINGDIPAPI  
GdipSetCustomLineCapBaseInset(GpCustomLineCap* customCap, REAL inset)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap [
	<ulong: GdipSetCustomLineCapStrokeCaps>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCustomLineCapStrokeCaps(GpCustomLineCap* customCap, GpLineCap startCap, GpLineCap endCap)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin [
	<ulong: GdipSetCustomLineCapStrokeJoin>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCustomLineCapStrokeJoin(GpCustomLineCap* customCap, GpLineJoin lineJoin)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetCustomLineCapWidthScale: customCap widthScale: widthScale [
	<ulong: GdipSetCustomLineCapWidthScale>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetCustomLineCapWidthScale(GpCustomLineCap* customCap, REAL widthScale)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetEffectParameters: effect params: params size: size [
	<ulong: GdipSetEffectParameters>
	^self invalidArgument

"
Status __stdcall 
GdipSetEffectParameters(CGpEffect *effect, const VOID *params, const UINT size)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetEmpty: region [
	<ulong: GdipSetEmpty>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetEmpty(GpRegion *region);
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesCachedBackground: imageattr enableFlag: enableFlag [
	<ulong: GdipSetImageAttributesCachedBackground>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesCachedBackground(GpImageAttributes *imageattr, BOOL enableFlag)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesColorKeys: imageattr
type: type
enableFlag: enableFlag
colorLow: colorLow
colorHigh: colorHigh [
	<ulong: GdipSetImageAttributesColorKeys>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesColorKeys(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, ARGB colorLow, ARGB colorHigh)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesColorMatrix: imageattr
type: type
enableFlag: enableFlag
colorMatrix: colorMatrix
grayMatrix: grayMatrix
flags: flags [
	<ulong: GdipSetImageAttributesColorMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesColorMatrix(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, GDIPCONST ColorMatrix* colorMatrix, GDIPCONST ColorMatrix* grayMatrix, ColorMatrixFlags flags)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesGamma: imageattr
type: type
enableFlag: enableFlag
gamma: gamma [
	<ulong: GdipSetImageAttributesGamma>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesGamma(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, REAL gamma)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesICMMode: imageAttr on: on [
	<ulong: GdipSetImageAttributesICMMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesICMMode(GpImageAttributes *imageAttr, BOOL on)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesNoOp: imageattr type: type enableFlag: enableFlag [
	<ulong: GdipSetImageAttributesNoOp>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesNoOp(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesOutputChannel: imageattr
type: type
enableFlag: enableFlag
channelFlags: channelFlags [
	<ulong: GdipSetImageAttributesOutputChannel>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetImageAttributesOutputChannel(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, ColorChannelFlags channelFlags) 
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesOutputChannelColorProfile: imageattr
type: type
enableFlag: enableFlag
colorProfileFilename: colorProfileFilename [
	<ulong: GdipSetImageAttributesOutputChannelColorProfile>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesOutputChannelColorProfile (GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, GDIPCONST WCHAR *colorProfileFilename)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesRemapTable: imageattr
type: type
enableFlag: enableFlag
mapSize: mapSize
map: map [
	<ulong: GdipSetImageAttributesRemapTable>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesRemapTable(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, UINT mapSize, GDIPCONST ColorMap *map)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesThreshold: imageattr
type: type
enableFlag: enableFlag
threshold: threshold [
	<ulong: GdipSetImageAttributesThreshold>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesThreshold(GpImageAttributes *imageattr, ColorAdjustType type, BOOL enableFlag, REAL threshold)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesToIdentity: imageattr type: type [
	<ulong: GdipSetImageAttributesToIdentity>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImageAttributesToIdentity(GpImageAttributes *imageattr, ColorAdjustType type)
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImageAttributesWrapMode: imageAttr
wrap: wrap
argb: argb
clamp: clamp [
	<ulong: GdipSetImageAttributesWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetImageAttributesWrapMode( GpImageAttributes *imageAttr, WrapMode wrap, ARGB argb, BOOL clamp ) 
"]

{ #category : #images }
GDIPlusDLL >> GdipSetImagePalette: image palette: palette [
	<ulong: GdipSetImagePalette>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetImagePalette(GpImage *image, GDIPCONST ColorPalette *palette)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetInfinite: region [
	<ulong: GdipSetInfinite>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetInfinite(GpRegion *region); 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetInterpolationMode: graphics interpolationMode: interpolationMode [
	<ulong: GdipSetInterpolationMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetInterpolationMode(GpGraphics *graphics, InterpolationMode interpolationMode)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipSetLineBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetLineBlend(GpLineGradient *brush, GDIPCONST REAL *blend, GDIPCONST REAL* positions, INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineColors: brush color1: color1 color2: color2 [
	<ulong: GdipSetLineColors>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetLineColors(GpLineGradient *brush, ARGB color1, ARGB color2) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection [
	<ulong: GdipSetLineGammaCorrection>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetLineGammaCorrection(GpLineGradient *brush, BOOL useGammaCorrection) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineLinearBlend: brush focus: focus scale: scale [
	<ulong: GdipSetLineLinearBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetLineLinearBlend(GpLineGradient *brush, REAL focus, REAL scale)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLinePresetBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipSetLinePresetBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetLinePresetBlend(GpLineGradient *brush, GDIPCONST ARGB *blend, GDIPCONST REAL* positions, INT count)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineSigmaBlend: brush focus: focus scale: scale [
	<ulong: GdipSetLineSigmaBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetLineSigmaBlend(GpLineGradient *brush, REAL focus, REAL scale)
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineTransform: brush matrix: matrix [
	<ulong: GdipSetLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetLineTransform(GpLineGradient *brush, GDIPCONST GpMatrix *matrix) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipSetLineWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipSetLineWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetLineWrapMode(GpLineGradient *brush, GpWrapMode wrapmode) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipSetMatrixElements: matrix
m11: m11
m12: m12
m21: m21
m22: m22
dx: dx
dy: dy [
	<ulong: GdipSetMatrixElements>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetMatrixElements(GpMatrix *matrix, REAL m11, REAL m12, REAL m21, REAL m22, REAL dx, REAL dy)
"]

{ #category : #metafile }
GDIPlusDLL >> GdipSetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi [
	<ulong: GdipSetMetafileDownLevelRasterizationLimit>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetMetafileDownLevelRasterizationLimit( GpMetafile * metafile, UINT metafileRasterizationLimitDpi ); 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetPageScale: graphics scale: scale [
	<ulong: GdipSetPageScale>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetPageScale(GpGraphics *graphics, REAL scale)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetPageUnit: graphics unit: unit [
	<ulong: GdipSetPageUnit>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPageUnit(GpGraphics *graphics, GpUnit unit) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathFillMode: path fillMode: fillmode [
	<ulong: GdipSetPathFillMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPathFillMode(GpPath *path, GpFillMode fillmode) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipSetPathGradientBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI  
GdipSetPathGradientBlend(GpPathGradient *brush, GDIPCONST REAL *blend, GDIPCONST REAL *positions, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientCenterColor: brush colors: colors [
	<ulong: GdipSetPathGradientCenterColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientCenterColor(GpPathGradient *brush, ARGB colors)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientCenterPoint: brush points: points [
	<ulong: GdipSetPathGradientCenterPoint>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientCenterPoint(GpPathGradient *brush, GDIPCONST GpPointF* points)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientCenterPointI: brush points: points [
	<ulong: GdipSetPathGradientCenterPointI>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientCenterPointI(GpPathGradient *brush, GDIPCONST GpPoint* points)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientFocusScales: brush xScale: xScale yScale: yScale [
	<ulong: GdipSetPathGradientFocusScales>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientFocusScales(GpPathGradient *brush, REAL xScale, REAL yScale)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection [
	<ulong: GdipSetPathGradientGammaCorrection>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientGammaCorrection(GpPathGradient *brush, BOOL useGammaCorrection)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientLinearBlend: brush focus: focus scale: scale [
	<ulong: GdipSetPathGradientLinearBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientLinearBlend(GpPathGradient *brush, REAL focus, REAL scale)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientPath: brush path: path [
	<ulong: GdipSetPathGradientPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPathGradientPath(GpPathGradient *brush, GDIPCONST GpPath *path) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientPresetBlend: brush
blend: blend
positions: positions
count: count [
	<ulong: GdipSetPathGradientPresetBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientPresetBlend(GpPathGradient *brush, GDIPCONST ARGB *blend, GDIPCONST REAL* positions, INT count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientSigmaBlend: brush focus: focus scale: scale [
	<ulong: GdipSetPathGradientSigmaBlend>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientSigmaBlend(GpPathGradient *brush, REAL focus, REAL scale)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientSurroundColorsWithCount: brush color: color count: count [
	<ulong: GdipSetPathGradientSurroundColorsWithCount>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientSurroundColorsWithCount(GpPathGradient *brush, GDIPCONST ARGB* color, INT* count)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientTransform: brush matrix: matrix [
	<ulong: GdipSetPathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientTransform(GpPathGradient *brush, GpMatrix *matrix)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathGradientWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipSetPathGradientWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPathGradientWrapMode(GpPathGradient *brush, GpWrapMode wrapmode)
"]

{ #category : #paths }
GDIPlusDLL >> GdipSetPathMarker: path [
	<ulong: GdipSetPathMarker>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPathMarker(GpPath* path) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenBrushFill: pen brush: brush [
	<ulong: GdipSetPenBrushFill>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenBrushFill(GpPen *pen, GpBrush *brush) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenColor: pen argb: argb [
	<ulong: GdipSetPenColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenColor(GpPen *pen, ARGB argb) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenCompoundArray: pen dash: dash count: count [
	<ulong: GdipSetPenCompoundArray>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPenCompoundArray(GpPen *pen, GDIPCONST REAL *dash, INT count)
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenCustomEndCap: pen customCap: customCap [
	<ulong: GdipSetPenCustomEndCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenCustomEndCap(GpPen *pen, GpCustomLineCap* customCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenCustomStartCap: pen customCap: customCap [
	<ulong: GdipSetPenCustomStartCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenCustomStartCap(GpPen *pen, GpCustomLineCap* customCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenDashArray: pen dash: dash count: count [
	<ulong: GdipSetPenDashArray>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPenDashArray(GpPen *pen, GDIPCONST REAL *dash, INT count)
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenDashCap197819: pen dashCap: dashCap [
	<ulong: GdipSetPenDashCap197819>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenDashCap197819(GpPen *pen, GpDashCap dashCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenDashOffset: pen offset: offset [
	<ulong: GdipSetPenDashOffset>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPenDashOffset(GpPen *pen, REAL offset)
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenDashStyle: pen dashstyle: dashstyle [
	<ulong: GdipSetPenDashStyle>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenDashStyle(GpPen *pen, GpDashStyle dashstyle) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenEndCap: pen endCap: endCap [
	<ulong: GdipSetPenEndCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenEndCap(GpPen *pen, GpLineCap endCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenLineCap197819: pen
startCap: startCap
endCap: endCap
dashCap: dashCap [
	<ulong: GdipSetPenLineCap197819>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenLineCap197819(GpPen *pen, GpLineCap startCap, GpLineCap endCap, GpDashCap dashCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenLineJoin: pen lineJoin: lineJoin [
	<ulong: GdipSetPenLineJoin>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenLineJoin(GpPen *pen, GpLineJoin lineJoin) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenMiterLimit: pen miterLimit: miterLimit [
	<ulong: GdipSetPenMiterLimit>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPenMiterLimit(GpPen *pen, REAL miterLimit)
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenMode: pen penMode: penMode [
	<ulong: GdipSetPenMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenMode(GpPen *pen, GpPenAlignment penMode) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenStartCap: pen startCap: startCap [
	<ulong: GdipSetPenStartCap>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenStartCap(GpPen *pen, GpLineCap startCap) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenTransform: pen matrix: matrix [
	<ulong: GdipSetPenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenTransform(GpPen *pen, GpMatrix *matrix) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenUnit: pen unit: unit [
	<ulong: GdipSetPenUnit>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPenUnit(GpPen *pen, GpUnit unit) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipSetPenWidth: pen width: width [
	<ulong: GdipSetPenWidth>
	^self invalidArgument

"
GpStatus WINGDIPAPI 
GdipSetPenWidth(GpPen *pen, REAL width)
"]

{ #category : #other }
GDIPlusDLL >> GdipSetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode [
	<ulong: GdipSetPixelOffsetMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPixelOffsetMode(GpGraphics* graphics, PixelOffsetMode pixelOffsetMode) 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetPropertyItem: image item: item [
	<ulong: GdipSetPropertyItem>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetPropertyItem(GpImage *image, GDIPCONST PropertyItem* item) 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetRenderingOrigin: graphics x: x y: y [
	<ulong: GdipSetRenderingOrigin>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetRenderingOrigin(GpGraphics *graphics, INT x, INT y) 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetSmoothingMode: graphics smoothingMode: smoothingMode [
	<ulong: GdipSetSmoothingMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetSmoothingMode(GpGraphics *graphics, SmoothingMode smoothingMode) 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetSolidFillColor: brush color: color [
	<ulong: GdipSetSolidFillColor>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetSolidFillColor(GpSolidFill *brush, ARGB color); 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatAlign: format align: align [
	<ulong: GdipSetStringFormatAlign>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatAlign(GpStringFormat *format, StringAlignment align) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatDigitSubstitution: format language: language substitute: substitute [
	<ulong: GdipSetStringFormatDigitSubstitution>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetStringFormatDigitSubstitution(GpStringFormat *format, LANGID language, StringDigitSubstitute substitute)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatFlags: format flags: flags [
	<ulong: GdipSetStringFormatFlags>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatFlags(GpStringFormat *format, INT flags) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix [
	<ulong: GdipSetStringFormatHotkeyPrefix>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatHotkeyPrefix(GpStringFormat *format, INT hotkeyPrefix) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatLineAlign: format align: align [
	<ulong: GdipSetStringFormatLineAlign>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatLineAlign(GpStringFormat *format, StringAlignment align) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatMeasurableCharacterRanges: format rangeCount: rangeCount ranges: ranges [
	<ulong: GdipSetStringFormatMeasurableCharacterRanges>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatMeasurableCharacterRanges( GpStringFormat *format, INT rangeCount, GDIPCONST CharacterRange *ranges ) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatTabStops: format
firstTabOffset: firstTabOffset
count: count
tabStops: tabStops [
	<ulong: GdipSetStringFormatTabStops>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipSetStringFormatTabStops(GpStringFormat *format, REAL firstTabOffset, INT count, GDIPCONST REAL *tabStops)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetStringFormatTrimming: format trimming: trimming [
	<ulong: GdipSetStringFormatTrimming>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetStringFormatTrimming( GpStringFormat *format, StringTrimming trimming ) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetTextContrast: graphics contrast: contrast [
	<ulong: GdipSetTextContrast>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetTextContrast(GpGraphics *graphics, UINT contrast) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipSetTextRenderingHint: graphics mode: mode [
	<ulong: GdipSetTextRenderingHint>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetTextRenderingHint(GpGraphics *graphics, TextRenderingHint mode) 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipSetTextureTransform: brush matrix: matrix [
	<ulong: GdipSetTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetTextureTransform(GpTexture *brush, GDIPCONST GpMatrix *matrix) 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipSetTextureWrapMode: brush wrapmode: wrapmode [
	<ulong: GdipSetTextureWrapMode>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetTextureWrapMode(GpTexture *brush, GpWrapMode wrapmode) 
"]

{ #category : #other }
GDIPlusDLL >> GdipSetWorldTransform: graphics matrix: matrix [
	<ulong: GdipSetWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipSetWorldTransform(GpGraphics *graphics, GpMatrix *matrix) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipShearMatrix: matrix
shearX: shearX
shearY: shearY
order: order [
	<ulong: GdipShearMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipShearMatrix(GpMatrix *matrix, REAL shearX, REAL shearY, GpMatrixOrder order)
"]

{ #category : #paths }
GDIPlusDLL >> GdipStartPathFigure: path [
	<ulong: GdipStartPathFigure>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipStartPathFigure(GpPath *path) 
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipStringFormatGetGenericDefault: format [
	<ulong: GdipStringFormatGetGenericDefault>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipStringFormatGetGenericDefault(GpStringFormat **format)
"]

{ #category : #'string functions' }
GDIPlusDLL >> GdipStringFormatGetGenericTypographic: format [
	<ulong: GdipStringFormatGetGenericTypographic>
	^self invalidArgument

"
GpStatus WINGDIPAPI
GdipStringFormatGetGenericTypographic(GpStringFormat **format)
"]

{ #category : #other }
GDIPlusDLL >> GdipTestControl: control param: param [
	<ulong: GdipTestControl>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTestControl( GpTestControlEnum control, void * param ); 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipTransformMatrixPoints: matrix pts: pts count: count [
	<ulong: GdipTransformMatrixPoints>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
GdipTransformMatrixPoints(GpMatrix *matrix, GpPointF *pts, INT count)
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipTransformMatrixPointsI: matrix pts: pts count: count [
	<ulong: GdipTransformMatrixPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTransformMatrixPointsI(GpMatrix *matrix, GpPoint *pts, INT count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipTransformPath: path matrix: matrix [
	<ulong: GdipTransformPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTransformPath(GpPath* path, GpMatrix* matrix) 
"]

{ #category : #other }
GDIPlusDLL >> GdipTransformPoints: graphics
destSpace: destSpace
srcSpace: srcSpace
points: points
count: count [
	<ulong: GdipTransformPoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTransformPoints(GpGraphics *graphics, GpCoordinateSpace destSpace, GpCoordinateSpace srcSpace, GpPointF *points, INT count) 
"]

{ #category : #other }
GDIPlusDLL >> GdipTransformPointsI: graphics
destSpace: destSpace
srcSpace: srcSpace
points: points
count: count [
	<ulong: GdipTransformPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTransformPointsI(GpGraphics *graphics, GpCoordinateSpace destSpace, GpCoordinateSpace srcSpace, GpPoint *points, INT count) 
"]

{ #category : #regions }
GDIPlusDLL >> GdipTransformRegion: region matrix: matrix [
	<ulong: GdipTransformRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTransformRegion(GpRegion *region, GpMatrix *matrix); 
"]

{ #category : #other }
GDIPlusDLL >> GdipTranslateClip: graphics dx: dx dy: dy [
	<ulong: GdipTranslateClip>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateClip(GpGraphics *graphics, REAL dx, REAL dy) 
"]

{ #category : #other }
GDIPlusDLL >> GdipTranslateClipI: graphics dx: dx dy: dy [
	<ulong: GdipTranslateClipI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateClipI(GpGraphics *graphics, INT dx, INT dy) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipTranslateLineTransform: brush
dx: dx
dy: dy
order: order [
	<ulong: GdipTranslateLineTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateLineTransform(GpLineGradient* brush, REAL dx, REAL dy, GpMatrixOrder order) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipTranslateMatrix: matrix
offsetX: offsetX
offsetY: offsetY
order: order [
	<ulong: GdipTranslateMatrix>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateMatrix(GpMatrix *matrix, REAL offsetX, REAL offsetY, GpMatrixOrder order) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipTranslatePathGradientTransform: brush
dx: dx
dy: dy
order: order [
	<ulong: GdipTranslatePathGradientTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslatePathGradientTransform(GpPathGradient* brush, REAL dx, REAL dy, GpMatrixOrder order) 
"]

{ #category : #pen }
GDIPlusDLL >> GdipTranslatePenTransform: pen
dx: dx
dy: dy
order: order [
	<ulong: GdipTranslatePenTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslatePenTransform(GpPen *pen, REAL dx, REAL dy, GpMatrixOrder order) 
"]

{ #category : #regions }
GDIPlusDLL >> GdipTranslateRegion: region dx: dx dy: dy [
	<ulong: GdipTranslateRegion>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateRegion(GpRegion *region, REAL dx, REAL dy); 
"]

{ #category : #regions }
GDIPlusDLL >> GdipTranslateRegionI: region dx: dx dy: dy [
	<ulong: GdipTranslateRegionI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateRegionI(GpRegion *region, INT dx, INT dy); 
"]

{ #category : #brushes }
GDIPlusDLL >> GdipTranslateTextureTransform: brush
dx: dx
dy: dy
order: order [
	<ulong: GdipTranslateTextureTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateTextureTransform(GpTexture* brush, REAL dx, REAL dy, GpMatrixOrder order) 
"]

{ #category : #other }
GDIPlusDLL >> GdipTranslateWorldTransform: graphics
dx: dx
dy: dy
order: order [
	<ulong: GdipTranslateWorldTransform>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipTranslateWorldTransform(GpGraphics *graphics, REAL dx, REAL dy, GpMatrixOrder order) 
"]

{ #category : #matrixes }
GDIPlusDLL >> GdipVectorTransformMatrixPoints: matrix pts: pts count: count [
	<ulong: GdipVectorTransformMatrixPoints>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipVectorTransformMatrixPoints(GpMatrix *matrix, GpPointF *pts, INT count) 
"]

{ #category : #'lines & curves' }
GDIPlusDLL >> GdipVectorTransformMatrixPointsI: matrix pts: pts count: count [
	<ulong: GdipVectorTransformMatrixPointsI>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipVectorTransformMatrixPointsI(GpMatrix *matrix, GpPoint *pts, INT count) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipWarpPath: path
matrix: matrix
points: points
count: count
srcx: srcx
srcy: srcy
srcwidth: srcwidth
srcheight: srcheight
warpMode: warpMode
flatness: flatness [
	<ulong: GdipWarpPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipWarpPath(GpPath *path, GpMatrix *matrix, GDIPCONST GpPointF *points, INT count, REAL srcx, REAL srcy, REAL srcwidth, REAL srcheight, WarpMode warpMode, REAL flatness) 
"]

{ #category : #paths }
GDIPlusDLL >> GdipWidenPath: nativePath
pen: pen
matrix: matrix
flatness: flatness [
	<ulong: GdipWidenPath>
	^self invalidArgument

"
GpStatus WINGDIPAPI GdipWidenPath( GpPath *nativePath, GpPen *pen, GpMatrix *matrix, REAL flatness ) 
"]

{ #category : #other }
GDIPlusDLL >> GdipWindingModeOutline: path matrix: matrix flatness: flatness [
	<ulong: GdipWindingModeOutline>
	^self invalidArgument

"
	GpStatus WINGDIPAPI
GdipWindingModeOutline(
	GpPath *path,
	GpMatrix *matrix,
	REAL flatness
)
"]

{ #category : #other }
GDIPlusDLL >> startUp [
	| token struct status |
	token := ExternalPointer external.
	struct := GdiplusStartupInput external.
	status := self
		GdiplusStartup: token asParameter
		startupInput: struct asParameter
		startupOutput: 0.
	status = 0 ifFalse: [^self winError].
	struct free.
	self propertyAt: #starUpToken put: token makeLocal asUnsignedInteger]

