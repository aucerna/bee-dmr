"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIDLL,
	#superclass : #ExternalLibrary,
	#type : #bytes,
	#category : #GDI
}

{ #category : #accessing }
GDIDLL class >> current [
	^GDILibrary]

{ #category : #parsing }
GDIDLL class >> h [
	^SmalltalkSession current devDirectory \ 'wingdi.h']

{ #category : #accessing }
GDIDLL class >> moduleName [
	^'GDI32']

{ #category : #'system startup' }
GDIDLL class >> startUp [
	self invalidateAddresses.
	current isNil ifTrue: [current := self new].
	current updateHandle.
	GDILibrary := current]

{ #category : #private }
GDIDLL class >> typedefTable [
	^#(
		('FONTENUMPROC' #pointer)
		('GOBJENUMPROC' #pointer)
		('BLENDFUNCTION' #ulong)
		('ABORTPROC' #pointer)
	)]

{ #category : #'printer services' }
GDIDLL >> AbortDoc: aDeviceContext [
	<long: AbortDoc>
	^self invalidCall

"
int AbortDoc(
  _In_ HDC hdc
);
"]

{ #category : #drawing }
GDIDLL >> AngleArc: hdc
X: centerx
Y: centery
dwRadius: r
eStartAngle: a1
eSweepAngle: a2 [
	<boolean: AngleArc>
	^self invalidCall

"
BOOL AngleArc(
  _In_ HDC   hdc,
  _In_ int   X,
  _In_ int   Y,
  _In_ DWORD dwRadius,
  _In_ FLOAT eStartAngle,
  _In_ FLOAT eSweepAngle
);
"]

{ #category : #drawing }
GDIDLL >> Arc: hdc
nLeftRect: x1
nTopRect: y1
nRightRect: x2
nBottomRect: y2
nXStartArc: x3
nYStartArc: y3
nXEndArc: x4
nYEndArc: y4 [
	<boolean: Arc>
	^self invalidCall

"
BOOL Arc(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect,
  _In_ int nXStartArc,
  _In_ int nYStartArc,
  _In_ int nXEndArc,
  _In_ int nYEndArc
);
"]

{ #category : #drawing }
GDIDLL >> BitBlt: hdcDest
nXDest: x1
nYDest: y1
nWidth: w
nHeight: h
hdcSrc: hdc
nXSrc: x2
nYSrc: y2
dwRop: anInteger [
	<boolean: BitBlt>
	^self invalidCall

"
BOOL BitBlt(
  _In_ HDC   hdcDest,
  _In_ int   nXDest,
  _In_ int   nYDest,
  _In_ int   nWidth,
  _In_ int   nHeight,
  _In_ HDC   hdcSrc,
  _In_ int   nXSrc,
  _In_ int   nYSrc,
  _In_ DWORD dwRop
);
"]

{ #category : #'device context' }
GDIDLL >> CancelDC: hdc [
	<boolean: CancelDC>
	^self invalidCall

"
BOOL CancelDC(
  _In_ HDC hdc
);
"]

{ #category : #'device context' }
GDIDLL >> ChoosePixelFormat: hdc ppfd: aPIXELFORMATDESCRIPTOR [
	<ulong: ChoosePixelFormat>
	^self invalidCall

"
int WINAPI ChoosePixelFormat(
         HDC                   hdc,
   const PIXELFORMATDESCRIPTOR *ppfd
);
"]

{ #category : #drawing }
GDIDLL >> Chord: hdc
nLeftRect: x1
nTopRect: y1
nRightRect: x2
nBottomRect: y2
nXRadial1: x3
nYRadial1: y3
nXRadial2: x4
nYRadial2: y4 [
	<boolean: Chord>
	^self invalidCall

"
BOOL Chord(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect,
  _In_ int nXRadial1,
  _In_ int nYRadial1,
  _In_ int nXRadial2,
  _In_ int nYRadial2
);
"]

{ #category : #metafiles }
GDIDLL >> CloseMetaFile: hdc [
	<pointer: CloseMetaFile>
	^self invalidCall

"
HMETAFILE CloseMetaFile(
  _In_ HDC hdc
);
"]

{ #category : #drawing }
GDIDLL >> CombineRgn: hrgnDest
hrgnSrc1: handle1
hrgnSrc2: handle2
fnCombineMode: anInteger [
	<long: CombineRgn>
	^self invalidCall

"
int CombineRgn(
  _In_ HRGN hrgnDest,
  _In_ HRGN hrgnSrc1,
  _In_ HRGN hrgnSrc2,
  _In_ int  fnCombineMode
);
"]

{ #category : #'enhanced metafiles' }
GDIDLL >> CopyEnhMetaFileW: hemfSrc lpszFile: lpszFile [
	<pointer: CopyEnhMetaFileW>
	^self invalidCall

"
HENHMETAFILE CopyEnhMetaFile(
  _In_ HENHMETAFILE hemfSrc,
  _In_ LPCTSTR      lpszFile
);
"]

{ #category : #metafiles }
GDIDLL >> CopyMetaFileW: hmfSrc lpszFile: lpszFile [
	<pointer: CopyMetaFileW>
	^self invalidCall

"
HMETAFILE CopyMetaFile(
  _In_ HMETAFILE hmfSrc,
  _In_ LPCTSTR   lpszFile
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateBitmap: nWidth
nHeight: height
cPlanes: planeCount
cBitsPerPel: bitCount
lpvBits: anExternalMemory [
	<pointer: CreateBitmap>
	^self invalidCall

"
HBITMAP CreateBitmap(
  _In_       int  nWidth,
  _In_       int  nHeight,
  _In_       UINT cPlanes,
  _In_       UINT cBitsPerPel,
  _In_ const VOID *lpvBits
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateBitmapIndirect: lpbm [
	<pointer: CreateBitmapIndirect>
	^self invalidCall

"
HBITMAP CreateBitmapIndirect(
  _In_ const BITMAP *lpbm
);
"]

{ #category : #'device context' }
GDIDLL >> CreateBrushIndirect: lplb [
	<pointer: CreateBrushIndirect>
	^self invalidCall

"
HBRUSH CreateBrushIndirect(
  _In_ const LOGBRUSH *lplb
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateCompatibleBitmap: hdc nWidth: width nHeight: heigth [
	<pointer: CreateCompatibleBitmap>
	^self invalidCall

"
HBITMAP CreateCompatibleBitmap(
  _In_ HDC hdc,
  _In_ int nWidth,
  _In_ int nHeight
);
"]

{ #category : #'device context' }
GDIDLL >> CreateCompatibleDC: hdc [
	<pointer: CreateCompatibleDC>
	^self invalidCall

"
HDC CreateCompatibleDC(
  _In_ HDC hdc
);
"]

{ #category : #'device context' }
GDIDLL >> createDCW: driver deviceName: device [
	^self
		CreateDCW: driver
		lpszDevice: device
		lpszOutput: 0
		lpInitData: 0]

{ #category : #'device context' }
GDIDLL >> CreateDCW: lpszDriver
lpszDevice: device
lpszOutput: zero
lpInitData: aDEVMODE [
	<pointer: CreateDCW>
	^self invalidCall

"
HDC CreateDC(
             LPCTSTR lpszDriver,
  _In_       LPCTSTR lpszDevice,
             LPCTSTR lpszOutput,
  _In_ const DEVMODE *lpInitData
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateDIBitmap: hdc
lpbmih: aBITMAPINFOHEADER
fdwInit: init
lpbInit: anExternalMemory
lpbmi: aBITMAPINFO
fuUsage: usage [
	<pointer: CreateDIBitmap>
	^self invalidCall

"
HBITMAP CreateDIBitmap(
  _In_       HDC              hdc,
  _In_ const BITMAPINFOHEADER *lpbmih,
  _In_       DWORD            fdwInit,
  _In_ const VOID             *lpbInit,
  _In_ const BITMAPINFO       *lpbmi,
  _In_       UINT             fuUsage
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateDIBSection: hdc
pbmi: aBITMAPINFO
iUsage: type
ppvBits: anExternalMemory
hSection: aFileHandle
dwOffset: anOffset [
	<pointer: CreateDIBSection>
	^self invalidCall

"
	HBITMAP CreateDIBSection(
	HDC hdc,                 // handle to DC
	CONST BITMAPINFO *pbmi,  // bitmap data
	UINT iUsage,             // data type indicator
	VOID **ppvBits,          // bit values
	HANDLE hSection,         // handle to file mapping object
	DWORD dwOffset     // offset to bitmap bit values
	);
"]

{ #category : #regions }
GDIDLL >> CreateEllipticRgn: nLeftRect
nTopRect: top
nRightRect: right
nBottomRect: bottom [
	<pointer: CreateEllipticRgn>
	^self invalidCall

"
HRGN CreateEllipticRgn(
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #bitmaps }
GDIDLL >> CreateEnhMetaFileW: hdcRef
lpFilename: lpFilename
lpRect: lpRect
lpDescription: lpDescription [
	<pointer: CreateEnhMetaFileW>
	^self invalidCall

"

HDC CreateEnhMetaFile(
  _In_       HDC     hdcRef,
  _In_       LPCTSTR lpFilename,
  _In_ const RECT    *lpRect,
  _In_       LPCTSTR lpDescription
);
"]

{ #category : #fonts }
GDIDLL >> CreateFontIndirectW: lplf [
	<pointer: CreateFontIndirectW>
	^self invalidCall

"
HFONT CreateFontIndirect(
  _In_  const LOGFONT *lplf
);
"]

{ #category : #pen }
GDIDLL >> CreateHatchBrush: fnStyle clrref: aCOLORREF [
	<pointer: CreateHatchBrush>
	^self invalidCall

"
HBRUSH CreateHatchBrush(
  _In_ int      fnStyle,
  _In_ COLORREF clrref
);
"]

{ #category : #'device context' }
GDIDLL >> CreateICW: lpszDriver
lpszDevice: aString
lpszOutput: zero
lpdvmInit: aDEVMODE [
	<pointer: CreateICW>
	^self invalidCall

"
HDC CreateIC(
  _In_  LPCTSTR lpszDriver,
  _In_  LPCTSTR lpszDevice,
  LPCTSTR lpszOutput,
  _In_  const DEVMODE *lpdvmInit
);
"]

{ #category : #metafiles }
GDIDLL >> CreateMetaFileW: lpszFile [
	<pointer: CreateMetaFileW>
	^self invalidCall

"
HDC CreateMetaFile(
  _In_ LPCTSTR lpszFile
);
"]

{ #category : #palette }
GDIDLL >> CreatePalette: lplgpl [
	<pointer: CreatePalette>
	^self invalidCall

"
HPALETTE CreatePalette(
  _In_ const LOGPALETTE *lplgpl
);
"]

{ #category : #pen }
GDIDLL >> CreatePatternBrush: hbmp [
	<pointer: CreatePatternBrush>
	^self invalidCall

"
HBRUSH CreatePatternBrush(
  _In_ HBITMAP hbmp
);
"]

{ #category : #pen }
GDIDLL >> CreatePen: fnPenStyle nWidth: width crColor: aCOLORREF [
	<pointer: CreatePen>
	^self invalidCall

"
HPEN CreatePen(
  _In_ int      fnPenStyle,
  _In_ int      nWidth,
  _In_ COLORREF crColor
);
"]

{ #category : #drawing }
GDIDLL >> CreatePolygonRgn: anLPPOINT cPoints: anInteger mode: fnPolyFillMode [
	<pointer: CreatePolygonRgn>
	^self invalidCall

"
HRGN CreatePolygonRgn(
  _In_ const POINT *lppt,
  _In_       int   cPoints,
  _In_       int   fnPolyFillMode);
"]

{ #category : #regions }
GDIDLL >> CreateRectRgn: nLeftRect
nTopRect: top
nRightRect: right
nBottomRect: bottom [
	<pointer: CreateRectRgn>
	^self invalidCall

"
HRGN CreateRectRgn(
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #pen }
GDIDLL >> CreateSolidBrush: crColor [
	<pointer: CreateSolidBrush>
	^self invalidCall

"
HBRUSH CreateSolidBrush(
  _In_ COLORREF crColor
);
"]

{ #category : #'device context' }
GDIDLL >> DeleteDC: hdc [
	<boolean: DeleteDC>
	^self invalidCall

"
BOOL DeleteDC(
  _In_ HDC hdc
);
"]

{ #category : #metafiles }
GDIDLL >> DeleteMetaFile: hMetaFile [
	<boolean: DeleteMetaFile>
	^self invalidCall

"
BOOL DeleteMetaFile(
  _In_ HMETAFILE hmf
);
"]

{ #category : #'device context' }
GDIDLL >> DeleteObject: hObject [
	<boolean: DeleteObject>
	^self invalidCall

"
BOOL DeleteObject(
  _In_ HGDIOBJ hObject
);
"]

{ #category : #'device context' }
GDIDLL >> DescribePixelFormat: hdc
iPixelFormat: format
nBytes: count
ppfd: aPIXELFORMATDESCRIPTOR [
	<boolean: DescribePixelFormat>
	^self invalidCall

"
int WINAPI DescribePixelFormat(
   HDC                     hdc,
   int                     iPixelFormat,
   UINT                    nBytes,
   LPPIXELFORMATDESCRIPTOR ppfd
);
"]

{ #category : #inquiries }
GDIDLL >> DpToLp: hdc lpPoints: aLPPOINT nCount: anInteger [
	<boolean: DPtoLP>
	^self invalidCall

"
BOOL DPtoLP(
  _In_    HDC     hdc,
  _Inout_ LPPOINT lpPoints,
  _In_    int     nCount
);
"]

{ #category : #inquiries }
GDIDLL >> dpToLp: hdc points: points [
	| buffer |
	buffer := BufferArray externalOn: points type: POINT.
	self
		DpToLp: hdc asParameter
		lpPoints: buffer asParameter
		nCount: points size.
	^buffer makeLocal asArray collect: #asPoint]

{ #category : #drawing }
GDIDLL >> DrawEscape: hdc
nEscape: anInteger
cbInput: anotherInteger
lpszInData: anExternalMemory [
	<long: DrawEscape>
	^self invalidCall

"
int DrawEscape(
  _In_ HDC    hdc,
  _In_ int    nEscape,
  _In_ int    cbInput,
  _In_ LPCSTR lpszInData
);
"]

{ #category : #drawing }
GDIDLL >> Ellipse: hdc
nLeftRect: left
nTopRect: top
nRightRect: right
nBottomRect: bottom [
	<boolean: Ellipse>
	^self invalidCall

"
BOOL Ellipse(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #'printer services' }
GDIDLL >> EndDoc: hdc [
	<long: EndDoc>
	^self invalidCall

"
int EndDoc(
  _In_ HDC hdc
);
"]

{ #category : #'printer services' }
GDIDLL >> EndPage: hdc [
	<long: EndPage>
	^self invalidCall

"
int EndPage(
  _In_ HDC hdc
);
"]

{ #category : #fonts }
GDIDLL >> EnumFontsW: hdc
lpFaceName: aString
lpFontFunc: aCallback
lParam: anExternalMemory [
	<long: EnumFontsW>
	^self invalidCall

"
int EnumFonts(
  _In_  HDC          hdc,
  _In_  LPCTSTR      lpFaceName,
  _In_  FONTENUMPROC lpFontFunc,
  _In_  LPARAM       lParam
);
"]

{ #category : #'device context' }
GDIDLL >> EnumObjects: hdc
nObjectType: integer
lpObjectFunc: callback
lParam: long [
	<long: EnumObjects>
	^self invalidCall

"
int EnumObjects(
  _In_ HDC          hdc,
  _In_ int          nObjectType,
  _In_ GOBJENUMPROC lpObjectFunc,
  _In_ LPARAM       lParam
);
"]

{ #category : #services }
GDIDLL >> Escape: hdc
nEscape: anInteger
cbInput: byteCount
lpvInData: aString
lpvOutData: anExternalMemory [
	<long: Escape>
	^self invalidCall

"
int Escape(
  _In_   HDC hdc,
  _In_   int nEscape,
  _In_   int cbInput,
  _In_   LPCSTR lpvInData,
  _Out_  LPVOID lpvOutData)
"]

{ #category : #clipping }
GDIDLL >> ExcludeClipRect: hdc
nLeftRect: left
nTopRect: top
nRightRect: right
nBottomRect: bottom [
	<long: ExcludeClipRect>
	^self invalidCall

"
int ExcludeClipRect(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #pen }
GDIDLL >> ExtCreatePen: dwPenStyle
dwWidth: dwWidth
lplb: aLOGBRUSH
dwStyleCount: dwStyleCount
lpStyle: lpStyle [
	<pointer: ExtCreatePen>
	^self invalidCall

"
HPEN ExtCreatePen(
  _In_       DWORD    dwPenStyle,
  _In_       DWORD    dwWidth,
  _In_ const LOGBRUSH *lplb,
  _In_       DWORD    dwStyleCount,
  _In_ const DWORD    *lpStyle
);
"]

{ #category : #drawing }
GDIDLL >> ExtFloodFill: hdc
nXStart: x
nYStart: y
crColor: color
fuFillType: type [
	<boolean: ExtFloodFill>
	^self invalidCall

"
BOOL ExtFloodFill(
  _In_  HDC hdc,
  _In_  int nXStart,
  _In_  int nYStart,
  _In_  COLORREF crColor,
  _In_  UINT fuFillType
);
"]

{ #category : #text }
GDIDLL >> ExtTextOutW: hDC
X: x
Y: y
fuOptions: integer
lprc: aRECT
lpString: aString
cbCount: byteCount
lpDx: lpArray [
	<boolean: ExtTextOutW>
	^self invalidCall

"
BOOL ExtTextOut(
  _In_  HDC hdc,
  _In_  int X,
  _In_  int Y,
  _In_  UINT fuOptions,
  _In_  const RECT *lprc,
  _In_  LPCTSTR lpString,
  _In_  UINT cbCount,
  _In_  const INT *lpDx)
"]

{ #category : #drawing }
GDIDLL >> GdiAlphaBlend: hdcDest
xoriginDest: x0
yoriginDest: y0
wDest: w0
hDest: h0
hdcSrc: src
xoriginSrc: x1
yoriginSrc: y1
wSrc: w1
hSrc: h1
ftn: blend [
	<boolean: GdiAlphaBlend>
	^self invalidCall

"
BOOL GdiAlphaBlend(
  _In_  HDC hdcDest,
  _In_  int xoriginDest,
  _In_  int yoriginDest,
  _In_  int wDest,
  _In_  int hDest,
  _In_  HDC hdcSrc,
  _In_  int xoriginSrc,
  _In_  int yoriginSrc,
  _In_  int wSrc,
  _In_  int hSrc,
  _In_  BLENDFUNCTION ftn
);
"]

{ #category : #bitmaps }
GDIDLL >> GetBitmapBits: hbmp cbBuffer: anInteger lpvBits: anExternalMemory [
	<long: GetBitmapBits>
	^self invalidCall

"
LONG GetBitmapBits(
  _In_   HBITMAP hbmp,
  _In_   LONG cbBuffer,
  _Out_  LPVOID lpvBits)
"]

{ #category : #pen }
GDIDLL >> GetBkMode: hdc [
	<long: GetBkMode>
	^self invalidCall

"
int GetBkMode(
  _In_ HDC hdc
);
"]

{ #category : #text }
GDIDLL >> GetCharABCWidths: hdc
uFirstChar: integer1
uLastChar: integer2
lpabc: anArray [
	<boolean: GetCharABCWidthsW>
	^self invalidCall

"
BOOL GetCharABCWidths(
  _In_   HDC hdc,
  _In_   UINT uFirstChar,
  _In_   UINT uLastChar,
  _Out_  LPABC lpabc);
"]

{ #category : #text }
GDIDLL >> getCharWidth32: hDC
iFirstChar: firstChar
iLastChar: lastChar
lpBuffer: anExternalMemory [
	<boolean: GetCharWidth32W>
	^self invalidCall

"
BOOL GetCharWidth32(
  _In_   HDC hdc,
  _In_   UINT iFirstChar,
  _In_   UINT iLastChar,
  _Out_  LPINT lpBuffer);
"]

{ #category : #clipping }
GDIDLL >> GetClipBox: hdc lprc: aRectangle [
	<long: GetClipBox>
	^self invalidCall

"
int GetClipBox(
  _In_   HDC hdc,
  _Out_  LPRECT lprc
);
"]

{ #category : #clipping }
GDIDLL >> GetClipRgn: hdc hrgn: region [
	<long: GetClipRgn>
	^self invalidCall

" 
int GetClipRgn(
  _In_ HDC  hdc,
  _In_ HRGN hrgn
);
"]

{ #category : #'device context' }
GDIDLL >> GetCurrentObject: hdc uObjectType: ulong [
	<pointer: GetCurrentObject>
	^self invalidCall

"
HGDIOBJ GetCurrentObject(
  _In_ HDC  hdc,
  _In_ UINT uObjectType
);
"]

{ #category : #inquiries }
GDIDLL >> GetCurrentPositionEx: hdc lpPoint: aPOINT [
	<boolean: GetCurrentPositionEx>
	^self invalidCall

"
BOOL GetCurrentPositionEx(
  _In_  HDC     hdc,
  _Out_ LPPOINT lpPoint
);
"]

{ #category : #'device context' }
GDIDLL >> GetDCBrushColor: hdc [
	<long: GetDCBrushColor>
	^self invalidCall

"
COLORREF GetDCBrushColor(
  _In_ HDC hdc
);
"]

{ #category : #'device context' }
GDIDLL >> GetDCPenColor: hdc [
	<long: GetDCPenColor>
	^self invalidCall

"
COLORREF GetDCPenColor(
  _In_ HDC hdc
);
"]

{ #category : #'device context' }
GDIDLL >> GetDeviceCaps: hdc index: anInteger [
	<long: GetDeviceCaps>
	^self invalidCall

"
int GetDeviceCaps(
  _In_ HDC hdc,
  _In_ int nIndex
);
"]

{ #category : #bitmaps }
GDIDLL >> GetDIBits: hdc
hbmp: aBitmap
uStartScan: scan
cScanLines: lines
lpvBits: aByteArray
lpbi: aBITMAPINFO
uUsage: flags [
	<long: GetDIBits>
	^self invalidCall

"
int GetDIBits(
  _In_     HDC hdc,
  _In_     HBITMAP hbmp,
  _In_     UINT uStartScan,
  _In_     UINT cScanLines,
  _Out_    LPVOID lpvBits,
  _Inout_  LPBITMAPINFO lpbi,
  _In_     UINT uUsage
);
"]

{ #category : #'enhanced metafiles' }
GDIDLL >> GetEnhMetaFile: lpszMetaFile [
	<ulong: GetEnhMetaFileW>
	^self invalidCall

"
HENHMETAFILE GetEnhMetaFile(
  _In_ LPCTSTR lpszMetaFile
);
"]

{ #category : #'enhanced metafiles' }
GDIDLL >> GetEnhMetaFileDescriptionW: hemf cchBuffer: cchBuffer lpszDescription: lpszDescription [
	<ulong: GetEnhMetaFileDescriptionW>
	^self invalidCall

"
UINT GetEnhMetaFileDescription(
  _In_   HENHMETAFILE hemf,
  _In_   UINT         cchBuffer,
  _Out_  LPTSTR       lpszDescription
);
"]

{ #category : #'enhanced metafiles' }
GDIDLL >> GetEnhMetaFileW: lpszMetaFile [
	<pointer: GetEnhMetaFileW>
	^self invalidCall

"
HENHMETAFILE GetEnhMetaFile(
  _In_ LPCTSTR lpszMetaFile
);
"]

{ #category : #fonts }
GDIDLL >> GetFontUnicodeRanges: hdc lpgs: aGLYPHSET [
	<ulong: GetFontUnicodeRanges>
	^self invalidCall

"
DWORD GetFontUnicodeRanges(
  _In_    HDC hdc,
  _Out_ LPGLYPHSET lpgs
);
"]

{ #category : #inquiries }
GDIDLL >> GetMapMode: hdc [
	<long: GetMapMode>
	^self invalidCall

"
int GetMapMode(
  _In_ HDC hdc
);
"]

{ #category : #metafiles }
GDIDLL >> GetMetaFileBitsEx: hmf nSize: nSize lpvData: lpvData [
	<ulong: GetMetaFileBitsEx>
	^self invalidCall

"
UINT GetMetaFileBitsEx(
  _In_  HMETAFILE hmf,
  _In_  UINT      nSize,
  _Out_ LPVOID    lpvData
);
"]

{ #category : #metafiles }
GDIDLL >> GetMetaFileW: lpszMetaFile [
	<pointer: GetMetaFileW>
	^self invalidCall

"
HENHMETAFILE GetMetaFile(
  _In_ LPCTSTR lpszMetaFile
);
"]

{ #category : #palette }
GDIDLL >> GetNearestPaletteIndex: hPalette color: aCOLORREF [
	<ulong: GetNearestPaletteIndex>
	^self invalidCall

"
UINT GetNearestPaletteIndex(
  _In_ HPALETTE hpal,
  _In_ COLORREF crColor
);
"]

{ #category : #inquiries }
GDIDLL >> GetObjectType: h [
	<ulong: GetObjectType>
	^self invalidCall

"
DWORD GetObjectType(
  _In_ HGDIOBJ h
);
"]

{ #category : #inquiries }
GDIDLL >> GetObjectW: hgdiobj cbBuffer: anInteger lpvObject: aWindowsStructure [
	<long: GetObjectW>
	^self invalidCall

"
int GetObject(
  _In_   HGDIOBJ hgdiobj,
  _In_   int     cbBuffer,
  _Out_  LPVOID  lpvObject
);
"]

{ #category : #palette }
GDIDLL >> getPaletteEntries: hPalette
iStartIndex: index
nEntries: anInteger
lppe: lpPaletteEntries [
	^self
		GetPaletteEntries: hPalette
		iStartIndex: (index bitAnd: 16rFFFF)
		nEntries: anInteger
		lppe: lpPaletteEntries]

{ #category : #palette }
GDIDLL >> GetPaletteEntries: hpal
iStartIndex: index
nEntries: anInteger
lppe: lpPaletteEntries [
	<ulong: GetPaletteEntries>
	^self invalidCall

"
UINT GetPaletteEntries(
  _In_  HPALETTE       hpal,
  _In_  UINT           iStartIndex,
  _In_  UINT           nEntries,
  _Out_ LPPALETTEENTRY lppe
);
"]

{ #category : #inquiries }
GDIDLL >> GetPixel: hdc x: anInt1 y: anInt2 [
	<ulong: GetPixel>
	^self invalidCall

"
COLORREF GetPixel(
  _In_ HDC hdc,
  _In_ int nXPos,
  _In_ int nYPos
);
"]

{ #category : #clipping }
GDIDLL >> GetRgnBox: hdc lprc: aRectangle [
	<long: GetRgnBox>
	^self invalidCall

"
int GetRgnBox(
  _In_  HRGN   hrgn,
  _Out_ LPRECT lprc
);
"]

{ #category : #pen }
GDIDLL >> GetROP2: hdc [
	<long: GetROP2>
	^self invalidCall

"
int GetROP2(
  _In_ HDC hdc
);"]

{ #category : #inquiries }
GDIDLL >> GetStockObject: fnObject [
	<pointer: GetStockObject>
	^self invalidCall

"
HGDIOBJ GetStockObject(
  _In_ int fnObject
);
"]

{ #category : #text }
GDIDLL >> GetTextAlign: hdc [
	<ulong: GetTextAlign>
	^self invalidCall

"
UINT GetTextAlign(
  _In_ HDC hdc
);
"]

{ #category : #text }
GDIDLL >> GetTextExtentPoint32W: hdc
lpString: aString
c: count
lpSize: anExternalInt32 [
	<boolean: GetTextExtentPoint32W>
	^self invalidCall

"
BOOL GetTextExtentPoint32(
  _In_  HDC     hdc,
  _In_  LPCTSTR lpString,
  _In_  int     c,
  _Out_ LPSIZE  lpSize
);
"]

{ #category : #text }
GDIDLL >> getTextFace: hdc [
	"
	GDIDLL current getTextFace: Display deviceContext
	"
	| length memory |
	length := self GetTextFaceW: hdc asParameter nCount: 0 lpFaceName: 0.
	memory := length externalCharacters.
	self
		GetTextFaceW: hdc asParameter
		nCount: length
		lpFaceName: memory asParameter.
	^memory makeUnicode reduced]

{ #category : #text }
GDIDLL >> GetTextFaceW: hdc nCount: length lpFaceName: aString [
	<long: GetTextFaceW>
	^self invalidCall

"
int GetTextFace(
  _In_  HDC    hdc,
  _In_  int    nCount,
  _Out_ LPTSTR lpFaceName
);
"]

{ #category : #text }
GDIDLL >> GetTextMetricsW: hdc lptm: aTEXTMETRIC [
	<boolean: GetTextMetricsW>
	^self invalidCall

"
BOOL GetTextMetrics(
  _In_   HDC          hdc,
  _Out_  LPTEXTMETRIC lptm
);
"]

{ #category : #inquiries }
GDIDLL >> GetViewportExtEx: hdc extent: lpSize [
	<boolean: GetViewportExtEx>
	^self invalidCall

"
BOOL GetViewportExtEx(
  _In_  HDC    hdc,
  _Out_ LPSIZE lpSize
);
"]

{ #category : #inquiries }
GDIDLL >> GetViewportOrgEx: hdc lpPoint: point [
	<boolean: GetViewportOrgEx>
	^self invalidCall

"
BOOL GetViewportOrgEx(
  _In_   HDC hdc,
  _Out_  LPPOINT lpPoint
);
"]

{ #category : #inquiries }
GDIDLL >> GetWindowExtEx: hdc lpSize: aSIZE [
	<boolean: GetWindowExtEx>
	^self invalidCall

"
BOOL GetWindowExtEx(
  _In_   HDC hdc,
  _Out_  LPSIZE lpSize
);
"]

{ #category : #inquiries }
GDIDLL >> GetWindowOrgEx: hdc lpPoint: point [
	<boolean: GetWindowOrgEx>
	^self invalidCall

"
BOOL GetWindowOrgEx(
  _In_   HDC hdc,
  _Out_  LPPOINT lpPoint
);
"]

{ #category : #regions }
GDIDLL >> IntersectClipRect: hdc
nLeftRect: left
nTopRect: top
nRightRect: right
nBottomRect: bottom [
	<ulong: IntersectClipRect>
	^self invalidCall

"
int IntersectClipRect(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #drawing }
GDIDLL >> LineTo: hdc nXEnd: x nYEnd: y [
	<boolean: LineTo>
	^self invalidCall

"
BOOL LineTo(
  _In_  HDC hdc,
  _In_  int nXEnd,
  _In_  int nYEnd
);
"]

{ #category : #inquiries }
GDIDLL >> LpToDp: hdc lpPoints: points nCount: anInteger [
	<boolean: LPtoDP>
	^self invalidCall

"
BOOL LPtoDP(
  _In_     HDC hdc,
  _Inout_  LPPOINT lpPoints,
  _In_     int nCount);
"]

{ #category : #inquiries }
GDIDLL >> lpToDp: hdc points: points [
	| buffer |
	buffer := BufferArray externalOn: points type: POINT.
	self
		LpToDp: hdc asParameter
		lpPoints: buffer asParameter
		nCount: points size.
	^buffer makeLocal asArray collect: #asPoint]

{ #category : #constants }
GDIDLL >> maxDrawingCoordinate [
	^16rFFFFFFFF]

{ #category : #drawing }
GDIDLL >> moveToEx: aDeviceContext location: aPoint [
	^self
		MoveToEx: aDeviceContext
		X: aPoint x
		Y: aPoint y
		lpPoint: 0]

{ #category : #pen }
GDIDLL >> MoveToEx: hdc
X: x
Y: y
lpPoint: aPoint [
	<boolean: MoveToEx>
	^self invalidCall

"
BOOL MoveToEx(
  _In_   HDC hdc,
  _In_   int X,
  _In_   int Y,
  _Out_  LPPOINT lpPoint
);
"]

{ #category : #'device context' }
GDIDLL >> OffsetViewportOrgEx: hdc
nXOffset: x
nYOffset: y
lpPoint: aPOINT [
	<boolean: OffsetViewportOrgEx>
	^self invalidCall

"
BOOL OffsetViewportOrgEx(
  _In_  HDC     hdc,
  _In_  int     nXOffset,
  _In_  int     nYOffset,
  _Out_ LPPOINT lpPoint
);
"]

{ #category : #drawing }
GDIDLL >> PatBlt: hdc
x: left
y: top
w: width
h: heght
rop: operation [
	<boolean: PatBlt>
	^self invalidCall

"
BOOL PatBlt(
  HDC   hdc,
  int   x,
  int   y,
  int   w,
  int   h,
  DWORD rop
);
"]

{ #category : #drawing }
GDIDLL >> Pie: hdc
left: x1
top: y1
right: x2
bottom: y2
xr1: x3
yr1: y3
xr2: x4
yr2: y4 [
	<boolean: Pie>
	^self invalidCall

"
BOOL Pie(
  HDC hdc,
  int left,
  int top,
  int right,
  int bottom,
  int xr1,
  int yr1,
  int xr2,
  int yr2
);
"]

{ #category : #metafiles }
GDIDLL >> PlayMetaFile: hdc with: hMetaFile [
	<boolean: PlayMetaFile>
	^self invalidCall

"
BOOL PlayMetaFile(
  _In_ HDC       hdc,
  _In_ HMETAFILE hmf
);
"]

{ #category : #drawing }
GDIDLL >> Polygon: hdc lpPoints: lpPoints nCount: anInteger [
	<boolean: Polygon>
	^self invalidCall

"
BOOL Polygon(
  _In_  HDC hdc,
  _In_  const POINT *lpPoints,
  _In_  int nCount);
"]

{ #category : #drawing }
GDIDLL >> Polyline: hdc lppt: aPOINT cPoints: anInteger [
	<boolean: Polyline>
	^self invalidCall

"
BOOL Polyline(
  _In_  HDC hdc,
  _In_  const POINT *lppt,
  _In_  int cPoints);
"]

{ #category : #palette }
GDIDLL >> RealizePalette: hdc [
	<ulong: RealizePalette>
	^self invalidCall

"
UINT RealizePalette(
  _In_ HDC hdc
);
"]

{ #category : #drawing }
GDIDLL >> Rectangle: hdc
nLeftRect: x1
nTopRect: y1
nRightRect: x2
nBottomRect: y2 [
	<boolean: Rectangle>
	^self invalidCall

"
BOOL Rectangle(
  _In_ HDC hdc,
  _In_ int nLeftRect,
  _In_ int nTopRect,
  _In_ int nRightRect,
  _In_ int nBottomRect
);
"]

{ #category : #drawing }
GDIDLL >> RectVisible: hdc lprc: aRECT [
	<boolean: RectVisible>
	^self invalidCall

"
BOOL RectVisible(
  _In_  HDC hdc,
  _In_  const RECT *lprc);
"]

{ #category : #drawing }
GDIDLL >> RestoreDC: hdc nSavedDC: anInteger [
	<boolean: RestoreDC>
	^self invalidCall

"
BOOL RestoreDC(
  _In_  HDC hdc,
  _In_  int nSavedDC);
"]

{ #category : #drawing }
GDIDLL >> RoundRect: hdc
nLeftRect: left
nTopRect: top
nRightRect: right
nBottomRect: bottom
nWidth: width
nHeight: height [
	<boolean: RoundRect>
	^self invalidCall

"
BOOL RoundRect(
  _In_  HDC hdc,
  _In_  int nLeftRect,
  _In_  int nTopRect,
  _In_  int nRightRect,
  _In_  int nBottomRect,
  _In_  int nWidth,
  _In_  int nHeight);
"]

{ #category : #'device context' }
GDIDLL >> SaveDC: hdc [
	<long: SaveDC>
	^self invalidCall

"
int SaveDC(
  _In_ HDC hdc
);
"]

{ #category : #drawing }
GDIDLL >> ScaleWindowExtEx: hdc
xn: numX
xd: denX
yn: numY
yd: denY
lpsz: aSIZE [
	<boolean: ScaleWindowExtEx>
	^self invalidCall

"
BOOL ScaleWindowExtEx(
  HDC    hdc,
  int    xn,
  int    xd,
  int    yn,
  int    yd,
  LPSIZE lpsz
);
"]

{ #category : #clipping }
GDIDLL >> SelectClipRgn: hDC hrgn: region [
	<long: SelectClipRgn>
	^self invalidCall

"
int SelectClipRgn(
  _In_ HDC  hdc,
  _In_ HRGN hrgn
);
"]

{ #category : #'device context' }
GDIDLL >> SelectObject: hdc hgdiobj: handle [
	<pointer: SelectObject>
	^self invalidCall

"
HGDIOBJ SelectObject(
  _In_  HDC hdc,
  _In_  HGDIOBJ hgdiobj
);
"]

{ #category : #'device context' }
GDIDLL >> selectObject: anObject into: aDeviceContext while: aBlock [
	| dc selected |
	anObject isNil ifTrue: [^aBlock value].
	dc := aDeviceContext asParameter.
	selected := self SelectObject: dc hgdiobj: anObject asParameter.
	^[aBlock value] ensure: [self SelectObject: dc hgdiobj: selected]]

{ #category : #palette }
GDIDLL >> SelectPalette: hdc hpal: palette bForceBackground: aBoolean [
	<pointer: SelectPalette>
	^self invalidCall

"
HPALETTE SelectPalette(
  _In_  HDC hdc,
  _In_  HPALETTE hpal,
  _In_  BOOL bForceBackground
);
"]

{ #category : #palette }
GDIDLL >> selectPalette: palette into: aDeviceContext [
	^self
		SelectPalette: aDeviceContext asParameter
		hpal: palette asParameter
		bForceBackground: false asParameter]

{ #category : #palette }
GDIDLL >> selectPalette: aDeviceContext with: palette [
	^self
		SelectPalette: aDeviceContext asParameter
		hpal: palette asParameter
		bForceBackground: false asParameter]

{ #category : #'device context' }
GDIDLL >> SetAbortProc: hdc proc: aCallback [
	<long: SetAbortProc>
	^self invalidCall

"
int SetAbortProc(
  HDC       hdc,
  ABORTPROC proc
);
"]

{ #category : #bitmaps }
GDIDLL >> SetBitmapBits: hbmp cb: anInteger pvBits: aByteArray [
	<long: SetBitmapBits>
	^self invalidCall

"
LONG SetBitmapBits(
  HBITMAP    hbm,
  DWORD      cb,
  const VOID *pvBits
);"]

{ #category : #pen }
GDIDLL >> SetBkColor: hdc crColor: aColor [
	<ulong: SetBkColor>
	^self invalidCall

"
COLORREF SetBkColor(
  _In_ HDC      hdc,
  _In_ COLORREF crColor
);
"]

{ #category : #pen }
GDIDLL >> SetBkMode: hdc iBkMode: aMode [
	<long: SetBkMode>
	^self invalidCall

"
int SetBkMode(
  _In_  HDC hdc,
  _In_  int iBkMode
);
"]

{ #category : #pen }
GDIDLL >> SetBrushOrgEx: hdc
nXOrg: x
nYOrg: y
lppt: aPOINT [
	<boolean: SetBrushOrgEx>
	^self invalidCall

"
BOOL SetBrushOrgEx(
  _In_   HDC hdc,
  _In_   int nXOrg,
  _In_   int nYOrg,
  _Out_  LPPOINT lppt);
"]

{ #category : #pen }
GDIDLL >> SetDCBrushColor: hdc crColor: aColor [
	<ulong: SetDCBrushColor>
	^self invalidCall

"
COLORREF SetDCBrushColor(
  _In_ HDC      hdc,
  _In_ COLORREF crColor
);
"]

{ #category : #pen }
GDIDLL >> SetDCPenColor: hdc crColor: aColor [
	<ulong: SetDCPenColor>
	^self invalidCall

"
COLORREF SetDCPenColor(
  _In_ HDC      hdc,
  _In_ COLORREF crColor
);
"]

{ #category : #bitmaps }
GDIDLL >> SetDIBits: hdc
hbmp: aBitmap
uStartScan: start
cScanLines: count
lpvBits: anExternalMemory
lpbmi: aBITMAPINFO
fuColorUse: integer [
	<long: SetDIBits>
	^self invalidCall

"
int SetDIBits(
  _In_  HDC hdc,
  _In_  HBITMAP hbmp,
  _In_  UINT uStartScan,
  _In_  UINT cScanLines,
  _In_  const VOID *lpvBits,
  _In_  const BITMAPINFO *lpbmi,
  _In_  UINT fuColorUse);
"]

{ #category : #bitmaps }
GDIDLL >> SetDIBitsToDevice: hdc
XDest: x
YDest: y
dwWidth: width
dwHeight: height
XSrc: x0
YSrc: y0
uStartScan: start
cScanLines: count
lpvBits: aByteArray
lpbmi: aBITMAPINFO
fuColorUse: integer [
	<long: SetDIBitsToDevice>
	^self invalidCall

"
int SetDIBitsToDevice(
  _In_  HDC hdc,
  _In_  int XDest,
  _In_  int YDest,
  _In_  DWORD dwWidth,
  _In_  DWORD dwHeight,
  _In_  int XSrc,
  _In_  int YSrc,
  _In_  UINT uStartScan,
  _In_  UINT cScanLines,
  _In_  const VOID *lpvBits,
  _In_  const BITMAPINFO *lpbmi,
  _In_  UINT fuColorUse);
"]

{ #category : #pen }
GDIDLL >> SetMapMode: hdc fnMapMode: mapMode [
	<long: SetMapMode>
	^self invalidCall

"
int SetMapMode(
  _In_  HDC hdc,
  _In_  int fnMapMode
);
"]

{ #category : #metafiles }
GDIDLL >> SetMetaFileBitsEx: nSize lpData: lpData [
	<pointer: SetMetaFileBitsEx>
	^self invalidCall

"
HMETAFILE SetMetaFileBitsEx(
  _In_       UINT nSize,
  _In_ const BYTE *lpData
);
"]

{ #category : #pen }
GDIDLL >> SetPixel: hdc
X: xPixel
Y: yPixel
crColor: color [
	<ulong: SetPixel>
	^self invalidCall

"
COLORREF SetPixel(
  _In_ HDC      hdc,
  _In_ int      X,
  _In_ int      Y,
  _In_ COLORREF crColor
);
"]

{ #category : #'device context' }
GDIDLL >> SetPixelFormat: hdc iPixelFormat: format ppfd: aPIXELFORMATDESCRIPTOR [
	<boolean: SetPixelFormat>
	^self invalidCall

"
BOOL WINAPI SetPixelFormat(
        HDC                   hdc,
        int                   iPixelFormat,
   		const PIXELFORMATDESCRIPTOR *ppfd
);
"]

{ #category : #pen }
GDIDLL >> SetPixelV: hdc
X: x
Y: y
crColor: color [
	<boolean: SetPixelV>
	^self invalidCall

"
BOOL SetPixelV(
  _In_  HDC hdc,
  _In_  int X,
  _In_  int Y,
  _In_  COLORREF crColor
);
"]

{ #category : #pen }
GDIDLL >> SetROP2: hdc fnDrawMode: aR2Constant [
	<long: SetROP2>
	^self invalidCall

"
int SetROP2(
  _In_  HDC hdc,
  _In_  int fnDrawMode
);
"]

{ #category : #text }
GDIDLL >> SetTextAlign: hdc align: flag [
	<ulong: SetTextAlign>
	^self invalidCall

"
UINT SetTextAlign(
  HDC  hdc,
  UINT align
);
"]

{ #category : #text }
GDIDLL >> SetTextColor: hdc color: aColor [
	<ulong: SetTextColor>
	^self invalidCall

"
COLORREF SetTextColor(
  HDC      hdc,
  COLORREF color
);
"]

{ #category : #'device context' }
GDIDLL >> SetViewportExtEx: hdc
nXExtent: x
nYExtent: y
lpSize: aSIZE [
	<boolean: SetViewportExtEx>
	^self invalidCall

"
BOOL SetViewportExtEx(
  _In_   HDC hdc,
  _In_   int nXExtent,
  _In_   int nYExtent,
  _Out_  LPSIZE lpSize
);
"]

{ #category : #'device context' }
GDIDLL >> SetViewportOrgEx: hdc
X: x
Y: y
lpPoint: point [
	<boolean: SetViewportOrgEx>
	^self invalidCall

"
BOOL SetViewportOrgEx(
  _In_   HDC hdc,
  _In_   int X,
  _In_   int Y,
  _Out_  LPPOINT lpPoint
);
"]

{ #category : #'device context' }
GDIDLL >> SetWindowExtEx: hdc
nXExtent: x
nYExtent: y
lpSize: aSIZE [
	<boolean: SetWindowExtEx>
	^self invalidCall

"
BOOL SetWindowExtEx(
  _In_   HDC hdc,
  _In_   int nXExtent,
  _In_   int nYExtent,
  _Out_  LPSIZE lpSize
);
"]

{ #category : #'device context' }
GDIDLL >> setWindowOrgEx: hdc point: aPoint [
	^self
		SetWindowOrgEx: hdc
		X: aPoint x
		Y: aPoint y
		lpPoint: 0]

{ #category : #'device context' }
GDIDLL >> SetWindowOrgEx: hdc
X: x
Y: y
lpPoint: point [
	<boolean: SetWindowOrgEx>
	^self invalidCall

"
BOOL SetWindowOrgEx(
  _In_   HDC hdc,
  _In_   int X,
  _In_   int Y,
  _Out_  LPPOINT lpPoint
);
"]

{ #category : #metafiles }
GDIDLL >> SetWinMetaFileBits: cbBuffer
lpbBuffer: lpbBuffer
hdcRef: hdcRef
lpmfp: lpmfp [
	<pointer: SetWinMetaFileBits>
	^self invalidCall

"
HENHMETAFILE SetWinMetaFileBits(
  _In_       UINT         cbBuffer,
  _In_ const BYTE         *lpbBuffer,
  _In_       HDC          hdcRef,
  _In_ const METAFILEPICT *lpmfp
);
"]

{ #category : #'printer services' }
GDIDLL >> StartDocW: hdc lpdi: aDOCINFO [
	<long: StartDocW>
	^self invalidCall

"
int StartDoc(
  _In_  HDC hdc,
  _In_  const DOCINFO *lpdi);
"]

{ #category : #'printer services' }
GDIDLL >> StartPage: hDC [
	<long: StartPage>
	^self invalidCall

"
int StartPage(
  _In_ HDC hDC
);
"]

{ #category : #drawing }
GDIDLL >> StretchBlt: hdcDest
nXOriginDest: x
nYOriginDest: y
nWidthDest: w
nHeightDest: h
hdcSrc: hdcSrc
nXOriginSrc: x0
nYOriginSrc: y0
nWidthSrc: w0
nHeightSrc: h0
dwRop: integer [
	<boolean: StretchBlt>
	^self invalidCall

"
BOOL StretchBlt(
  _In_  HDC hdcDest,
  _In_  int nXOriginDest,
  _In_  int nYOriginDest,
  _In_  int nWidthDest,
  _In_  int nHeightDest,
  _In_  HDC hdcSrc,
  _In_  int nXOriginSrc,
  _In_  int nYOriginSrc,
  _In_  int nWidthSrc,
  _In_  int nHeightSrc,
  _In_  DWORD dwRop);
"]

{ #category : #bitmaps }
GDIDLL >> stretchDIBits: hDC
destination: dRectangle
source: sRectangle
bits: bits
info: bmi
usage: colorUse
rop: rop [
	^self
		StretchDIBits: hDC
		xDest: dRectangle left
		yDest: dRectangle top
		nDestWidth: dRectangle width
		nDestHeight: dRectangle height
		xSrc: sRectangle left
		ySrc: sRectangle top
		nSrcWidth: sRectangle width
		nSrcHeight: sRectangle height
		lpBits: bits
		lpBitsInfo: bmi
		iUsage: colorUse
		dwRop: rop]

{ #category : #bitmaps }
GDIDLL >> StretchDIBits: hDC
xDest: xDest
yDest: yDest
nDestWidth: nDestWidth
nDestHeight: nDestHeight
xSrc: xSrc
ySrc: ySrc
nSrcWidth: nSrcWidth
nSrcHeight: nSrcHeight
lpBits: bits
lpBitsInfo: bmi
iUsage: colorUse
dwRop: rop [
	<long: StretchDIBits>
	^self invalidCall

"
int StretchDIBits(
  _In_       HDC        hdc,
  _In_       int        XDest,
  _In_       int        YDest,
  _In_       int        nDestWidth,
  _In_       int        nDestHeight,
  _In_       int        XSrc,
  _In_       int        YSrc,
  _In_       int        nSrcWidth,
  _In_       int        nSrcHeight,
  _In_ const VOID       *lpBits,
  _In_ const BITMAPINFO *lpBitsInfo,
  _In_       UINT       iUsage,
  _In_       DWORD      dwRop
);
"]

{ #category : #'device context' }
GDIDLL >> SwapBuffers: hdc [
	<boolean: SwapBuffers>
	^self invalidCall

"
BOOL WINAPI SwapBuffers(
   HDC hdc
);
"]

{ #category : #text }
GDIDLL >> TextOutW: hdc
nXStart: x
nYStart: y
lpString: aString
cchString: length [
	<boolean: TextOutW>
	^self invalidCall

"
BOOL TextOut(
  _In_  HDC hdc,
  _In_  int nXStart,
  _In_  int nYStart,
  _In_  LPCTSTR lpString,
  _In_  int cchString);
"]

