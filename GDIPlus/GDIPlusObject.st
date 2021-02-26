"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusObject,
	#superclass : #Object,
	#instVars : [
		'handle',
		'status'
	],
	#category : #GDIPlus
}

{ #category : #errors }
GDIPlusObject class >> checkStatus: gpStatus [
	gpStatus = Ok ifFalse: [self gdiPlusError: gpStatus]]

{ #category : #accessing }
GDIPlusObject class >> dll [
	^GDIPlusDLL current]

{ #category : #private }
GDIPlusObject class >> enumNamesWithPrefix: aString [
	^GDIPlusConstants keys select: [:e | e beginsWith: aString]]

{ #category : #enums }
GDIPlusObject class >> enumsCombineMode [
	^self enumsWithPrefix: 'CombineMode']

{ #category : #private }
GDIPlusObject class >> enumsFillMode [
	^self enumsWithPrefix: 'FillMode']

{ #category : #private }
GDIPlusObject class >> enumsHatchStyle [
	^self enumsWithPrefix: 'HatchStyle']

{ #category : #private }
GDIPlusObject class >> enumsLinearGradientMode [
	^self enumsWithPrefix: 'LinearGradientMode']

{ #category : #private }
GDIPlusObject class >> enumsLineCap [
	^self enumsWithPrefix: 'LineCap']

{ #category : #private }
GDIPlusObject class >> enumsLineJoin [
	^self enumsWithPrefix: 'LineJoin']

{ #category : #private }
GDIPlusObject class >> enumsPenAlignment [
	^self enumsWithPrefix: 'PenAlignment']

{ #category : #private }
GDIPlusObject class >> enumsStringAlignment [
	^self enumsWithPrefix: 'StringAlignment']

{ #category : #private }
GDIPlusObject class >> enumsStringTrimming [
	^self enumsWithPrefix: 'StringTrimming']

{ #category : #private }
GDIPlusObject class >> enumsWithPrefix: aString [
	^((self enumNamesWithPrefix: aString)
		collect: [:e | e -> (GDIPlusConstants at: e)])
		asSortedCollection: [:a :b | a value < b value]]

{ #category : #private }
GDIPlusObject class >> enumsWrapMode [
	^self enumsWithPrefix: 'WrapMode']

{ #category : #'instance creation' }
GDIPlusObject class >> fromHandle: handle [
	handle isNil ifTrue: [^nil].
	handle = 0 ifTrue: [^nil].
	handle isInteger ifFalse: [^self fromHandle: handle asUnsignedInteger].
	^self basicNew handle: handle asUnsigned]

{ #category : #private }
GDIPlusObject class >> gdiPlusConstants [
	^#(Aborted 9
	AccessDenied 12
	AliceBlue 4293982463
	AlphaMask 4278190080
	AlphaShift 24
	AntiqueWhite 4294634455
	Aqua 4278255615
	Aquamarine 4286578644
	Azure 4293984255
	Beige 4294309340
	Bisque 4294960324
	Black 4278190080
	BlanchedAlmond 4294962125
	Blue 4278190335
	BlueMask 255
	BlueShift 0
	BlueViolet 4287245282
	Brown 4289014314
	BrushTypeHatchFill 1
	BrushTypeLinearGradient 4
	BrushTypePathGradient 3
	BrushTypeSolidColor 0
	BrushTypeTextureFill 2
	BurlyWood 4292786311
	CadetBlue 4284456608
	Chartreuse 4286578432
	Chocolate 4291979550
	CodecIImageBytes '{025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC}'
	ColorAdjustTypeAny 6
	ColorAdjustTypeBitmap 1
	ColorAdjustTypeBrush 2
	ColorAdjustTypeCount 5
	ColorAdjustTypeDefault 0
	ColorAdjustTypePen 3
	ColorAdjustTypeText 4
	ColorChannelFlagsC 0
	ColorChannelFlagsK 3
	ColorChannelFlagsLast 4
	ColorChannelFlagsM 1
	ColorChannelFlagsY 2
	ColorMatrixFlagsAltGray 2
	ColorMatrixFlagsDefault 0
	ColorMatrixFlagsSkipGrays 1
	ColorModeARGB32 0
	ColorModeARGB64 1
	CombineModeComplement 5
	CombineModeExclude 4
	CombineModeIntersect 1
	CombineModeReplace 0
	CombineModeUnion 2
	CombineModeXor 3
	CompositingModeSourceCopy 1
	CompositingModeSourceOver 0
	CompositingQualityAssumeLinear 4
	CompositingQualityDefault 0
	CompositingQualityGammaCorrected 3
	CompositingQualityHighQuality 2
	CompositingQualityHighSpeed 1
	CompositingQualityInvalid 4294967295
	CoordinateSpaceDevice 2
	CoordinateSpacePage 1
	CoordinateSpaceWorld 0
	Coral 4294934352
	CornflowerBlue 4284782061
	Cornsilk 4294965468
	Crimson 4292613180
	CustomLineCapTypeAdjustableArrow 1
	CustomLineCapTypeDefault 0
	Cyan 4278255615
	DarkBlue 4278190219
	DarkCyan 4278225803
	DarkGoldenrod 4290283019
	DarkGray 4289309097
	DarkGreen 4278215680
	DarkKhaki 4290623339
	DarkMagenta 4287299723
	DarkOliveGreen 4283788079
	DarkOrange 4294937600
	DarkOrchid 4288230092
	DarkRed 4287299584
	DarkSalmon 4293498490
	DarkSeaGreen 4287609995
	DarkSlateBlue 4282924427
	DarkSlateGray 4281290575
	DarkTurquoise 4278243025
	DarkViolet 4287889619
	DashCapFlat 0
	DashCapRound 2
	DashCapTriangle 3
	DashStyleCustom 5
	DashStyleDash 1
	DashStyleDashDot 3
	DashStyleDashDotDot 4
	DashStyleDot 2
	DashStyleSolid 0
	DeepPink 4294907027
	DeepSkyBlue 4278239231
	DIB_RGB_COLORS 0
	DimGray 4285098345
	DodgerBlue 4280193279
	DriverStringOptionsCmapLookup 1
	DriverStringOptionsLimitSubpixel 8
	DriverStringOptionsRealizedAdvance 4
	DriverStringOptionsVertical 2
	EmfPlusRecordTotal 16439
	EmfPlusRecordTypeBeginContainer 16423
	EmfPlusRecordTypeBeginContainerNoParams 16424
	EmfPlusRecordTypeClear 16393
	EmfPlusRecordTypeComment 16387
	EmfPlusRecordTypeDrawArc 16402
	EmfPlusRecordTypeDrawBeziers 16409
	EmfPlusRecordTypeDrawClosedCurve 16407
	EmfPlusRecordTypeDrawCurve 16408
	EmfPlusRecordTypeDrawDriverString 16438
	EmfPlusRecordTypeDrawEllipse 16399
	EmfPlusRecordTypeDrawImage 16410
	EmfPlusRecordTypeDrawImagePoints 16411
	EmfPlusRecordTypeDrawLines 16397
	EmfPlusRecordTypeDrawPath 16405
	EmfPlusRecordTypeDrawPie 16401
	EmfPlusRecordTypeDrawRects 16395
	EmfPlusRecordTypeDrawString 16412
	EmfPlusRecordTypeEndContainer 16425
	EmfPlusRecordTypeEndOfFile 16386
	EmfPlusRecordTypeFillClosedCurve 16406
	EmfPlusRecordTypeFillEllipse 16398
	EmfPlusRecordTypeFillPath 16404
	EmfPlusRecordTypeFillPie 16400
	EmfPlusRecordTypeFillPolygon 16396
	EmfPlusRecordTypeFillRects 16394
	EmfPlusRecordTypeFillRegion 16403
	EmfPlusRecordTypeGetDC 16388
	EmfPlusRecordTypeHeader 16385
	EmfPlusRecordTypeInvalid 16384
	EmfPlusRecordTypeMax 16438
	EmfPlusRecordTypeMin 16385
	EmfPlusRecordTypeMultiFormatEnd 16391
	EmfPlusRecordTypeMultiFormatSection 16390
	EmfPlusRecordTypeMultiFormatStart 16389
	EmfPlusRecordTypeMultiplyWorldTransform 16428
	EmfPlusRecordTypeObject 16392
	EmfPlusRecordTypeOffsetClip 16437
	EmfPlusRecordTypeResetClip 16433
	EmfPlusRecordTypeResetWorldTransform 16427
	EmfPlusRecordTypeRestore 16422
	EmfPlusRecordTypeRotateWorldTransform 16431
	EmfPlusRecordTypeSave 16421
	EmfPlusRecordTypeScaleWorldTransform 16430
	EmfPlusRecordTypeSetAntiAliasMode 16414
	EmfPlusRecordTypeSetClipPath 16435
	EmfPlusRecordTypeSetClipRect 16434
	EmfPlusRecordTypeSetClipRegion 16436
	EmfPlusRecordTypeSetCompositingMode 16419
	EmfPlusRecordTypeSetCompositingQuality 16420
	EmfPlusRecordTypeSetInterpolationMode 16417
	EmfPlusRecordTypeSetPageTransform 16432
	EmfPlusRecordTypeSetPixelOffsetMode 16418
	EmfPlusRecordTypeSetRenderingOrigin 16413
	EmfPlusRecordTypeSetTextContrast 16416
	EmfPlusRecordTypeSetTextRenderingHint 16415
	EmfPlusRecordTypeSetWorldTransform 16426
	EmfPlusRecordTypeTranslateWorldTransform 16429
	EmfRecordTypeAbortPath 68
	EmfRecordTypeAlphaBlend 114
	EmfRecordTypeAngleArc 41
	EmfRecordTypeArc 45
	EmfRecordTypeArcTo 55
	EmfRecordTypeBeginPath 59
	EmfRecordTypeBitBlt 76
	EmfRecordTypeChord 46
	EmfRecordTypeCloseFigure 61
	EmfRecordTypeColorCorrectPalette 111
	EmfRecordTypeColorMatchToTargetW 121
	EmfRecordTypeCreateBrushIndirect 39
	EmfRecordTypeCreateColorSpace 99
	EmfRecordTypeCreateColorSpaceW 122
	EmfRecordTypeCreateDIBPatternBrushPt 94
	EmfRecordTypeCreateMonoBrush 93
	EmfRecordTypeCreatePalette 49
	EmfRecordTypeCreatePen 38
	EmfRecordTypeDeleteColorSpace 101
	EmfRecordTypeDeleteObject 40
	EmfRecordTypeDrawEscape 105
	EmfRecordTypeEllipse 42
	EmfRecordTypeEndPath 60
	EmfRecordTypeEOF 14
	EmfRecordTypeExcludeClipRect 29
	EmfRecordTypeExtCreateFontIndirect 82
	EmfRecordTypeExtCreatePen 95
	EmfRecordTypeExtEscape 106
	EmfRecordTypeExtFloodFill 53
	EmfRecordTypeExtSelectClipRgn 75
	EmfRecordTypeExtTextOutA 83
	EmfRecordTypeExtTextOutW 84
	EmfRecordTypeFillPath 62
	EmfRecordTypeFillRgn 71
	EmfRecordTypeFlattenPath 65
	EmfRecordTypeForceUFIMapping 109
	EmfRecordTypeFrameRgn 72
	EmfRecordTypeGdiComment 70
	EmfRecordTypeGLSBoundedRecord 103
	EmfRecordTypeGLSRecord 102
	EmfRecordTypeGradientFill 118
	EmfRecordTypeHeader 1
	EmfRecordTypeIntersectClipRect 30
	EmfRecordTypeInvertRgn 73
	EmfRecordTypeLineTo 54
	EmfRecordTypeMaskBlt 78
	EmfRecordTypeMax 122
	EmfRecordTypeMin 1
	EmfRecordTypeModifyWorldTransform 36
	EmfRecordTypeMoveToEx 27
	EmfRecordTypeNamedEscape 110
	EmfRecordTypeOffsetClipRgn 26
	EmfRecordTypePaintRgn 74
	EmfRecordTypePie 47
	EmfRecordTypePixelFormat 104
	EmfRecordTypePlgBlt 79
	EmfRecordTypePolyBezier 2
	EmfRecordTypePolyBezier16 85
	EmfRecordTypePolyBezierTo 5
	EmfRecordTypePolyBezierTo16 88
	EmfRecordTypePolyDraw 56
	EmfRecordTypePolyDraw16 92
	EmfRecordTypePolygon 3
	EmfRecordTypePolygon16 86
	EmfRecordTypePolyline 4
	EmfRecordTypePolyline16 87
	EmfRecordTypePolyLineTo 6
	EmfRecordTypePolylineTo16 89
	EmfRecordTypePolyPolygon 8
	EmfRecordTypePolyPolygon16 91
	EmfRecordTypePolyPolyline 7
	EmfRecordTypePolyPolyline16 90
	EmfRecordTypePolyTextOutA 96
	EmfRecordTypePolyTextOutW 97
	EmfRecordTypeRealizePalette 52
	EmfRecordTypeRectangle 43
	EmfRecordTypeReserved_069 69
	EmfRecordTypeReserved_117 117
	EmfRecordTypeResizePalette 51
	EmfRecordTypeRestoreDC 34
	EmfRecordTypeRoundRect 44
	EmfRecordTypeSaveDC 33
	EmfRecordTypeScaleViewportExtEx 31
	EmfRecordTypeScaleWindowExtEx 32
	EmfRecordTypeSelectClipPath 67
	EmfRecordTypeSelectObject 37
	EmfRecordTypeSelectPalette 48
	EmfRecordTypeSetArcDirection 57
	EmfRecordTypeSetBkColor 25
	EmfRecordTypeSetBkMode 18
	EmfRecordTypeSetBrushOrgEx 13
	EmfRecordTypeSetColorAdjustment 23
	EmfRecordTypeSetColorSpace 100
	EmfRecordTypeSetDIBitsToDevice 80
	EmfRecordTypeSetICMMode 98
	EmfRecordTypeSetICMProfileA 112
	EmfRecordTypeSetICMProfileW 113
	EmfRecordTypeSetLayout 115
	EmfRecordTypeSetLinkedUFIs 119
	EmfRecordTypeSetMapMode 17
	EmfRecordTypeSetMapperFlags 16
	EmfRecordTypeSetMetaRgn 28
	EmfRecordTypeSetMiterLimit 58
	EmfRecordTypeSetPaletteEntries 50
	EmfRecordTypeSetPixelV 15
	EmfRecordTypeSetPolyFillMode 19
	EmfRecordTypeSetROP2 20
	EmfRecordTypeSetStretchBltMode 21
	EmfRecordTypeSetTextAlign 22
	EmfRecordTypeSetTextColor 24
	EmfRecordTypeSetTextJustification 120
	EmfRecordTypeSetViewportExtEx 11
	EmfRecordTypeSetViewportOrgEx 12
	EmfRecordTypeSetWindowExtEx 9
	EmfRecordTypeSetWindowOrgEx 10
	EmfRecordTypeSetWorldTransform 35
	EmfRecordTypeSmallTextOut 108
	EmfRecordTypeStartDoc 107
	EmfRecordTypeStretchBlt 77
	EmfRecordTypeStretchDIBits 81
	EmfRecordTypeStrokeAndFillPath 63
	EmfRecordTypeStrokePath 64
	EmfRecordTypeTransparentBlt 116
	EmfRecordTypeWidenPath 66
	EmfToWmfBitsFlagsDefault 0
	EmfToWmfBitsFlagsEmbedEmf 1
	EmfToWmfBitsFlagsIncludePlaceable 2
	EmfToWmfBitsFlagsNoXORClip 4
	EmfTypeEmfOnly 3
	EmfTypeEmfPlusDual 5
	EmfTypeEmfPlusOnly 4
	EncoderChrominanceTable '{F2E455DC-09B3-4316-8260-676ADA32481C}'
	EncoderColorDepth '{66087055-AD66-4C7C-9A18-38A2310B8337}'
	EncoderCompression '{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}'
	EncoderLuminanceTable '{EDB33BCE-0266-4A77-B904-27216099E717}'
	EncoderParameterValueTypeASCII 2
	EncoderParameterValueTypeByte 1
	EncoderParameterValueTypeLong 4
	EncoderParameterValueTypeLongRange 6
	EncoderParameterValueTypeRational 5
	EncoderParameterValueTypeRationalRange 8
	EncoderParameterValueTypeShort 3
	EncoderParameterValueTypeUndefined 7
	EncoderQuality '{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}'
	EncoderRenderMethod '{6D42C53A-229A-4825-8BB7-5C99E2B9A8B8}'
	EncoderSaveFlag '{292266FC-AC40-47BF-8CFC-A85B89A655DE}'
	EncoderScanMethod '{3A4E2661-3109-4E56-8536-42C156E7DCFA}'
	EncoderTransformation '{8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}'
	EncoderValueColorTypeCMYK 0
	EncoderValueColorTypeYCCK 1
	EncoderValueCompressionCCITT3 3
	EncoderValueCompressionCCITT4 4
	EncoderValueCompressionLZW 2
	EncoderValueCompressionNone 6
	EncoderValueCompressionRle 5
	EncoderValueFlush 20
	EncoderValueFrameDimensionPage 23
	EncoderValueFrameDimensionResolution 22
	EncoderValueFrameDimensionTime 21
	EncoderValueLastFrame 19
	EncoderValueMultiFrame 18
	EncoderValueRenderNonProgressive 12
	EncoderValueRenderProgressive 11
	EncoderValueScanMethodInterlaced 7
	EncoderValueScanMethodNonInterlaced 8
	EncoderValueTransformFlipHorizontal 16
	EncoderValueTransformFlipVertical 17
	EncoderValueTransformRotate180 14
	EncoderValueTransformRotate270 15
	EncoderValueTransformRotate90 13
	EncoderValueVersionGif87 9
	EncoderValueVersionGif89 10
	EncoderVersion '{24D18C76-814A-41A4-BF53-1C219CCCF797}'
	FileNotFound 10
	FillModeAlternate 0
	FillModeWinding 1
	Firebrick 4289864226
	FloralWhite 4294966000
	FlushIntentionFlush 0
	FlushIntentionSync 1
	FontFamilyNotFound 14
	FontStyleBold 1
	FontStyleBoldItalic 3
	FontStyleItalic 2
	FontStyleNotFound 15
	FontStyleRegular 0
	FontStyleStrikeout 8
	FontStyleUnderline 4
	ForestGreen 4280453922
	FormatIDImageInformation '{E5836CBE-5EEF-0F1D-ACDE-AE4C43B608CE}'
	FormatIDJpegAppHeaders '{1C4AFDCD-6177-43CF-ABC7-5F51AF39EE85}'
	FrameDimensionPage '{7462DC86-6180-4C7E-8E3F-EE7333A7A483}'
	FrameDimensionResolution '{84236F7B-3BD3-428F-8DAB-4EA1439CA315}'
	FrameDimensionTime '{6AEDBD6D-3FB5-418A-83A6-7F45229DC872}'
	Fuchsia 4294902015
	Gainsboro 4292664540
	GenericError 1
	GenericFontFamilyMonospace 2
	GenericFontFamilySansSerif 1
	GenericFontFamilySerif 0
	GhostWhite 4294506751
	Gold 4294956800
	Goldenrod 4292519200
	Gray 4286611584
	Green 4278222848
	GreenMask 65280
	GreenShift 8
	GreenYellow 4289593135
	HatchStyle05Percent 6
	HatchStyle10Percent 7
	HatchStyle20Percent 8
	HatchStyle25Percent 9
	HatchStyle30Percent 10
	HatchStyle40Percent 11
	HatchStyle50Percent 12
	HatchStyle60Percent 13
	HatchStyle70Percent 14
	HatchStyle75Percent 15
	HatchStyle80Percent 16
	HatchStyle90Percent 17
	HatchStyleBackwardDiagonal 3
	HatchStyleCross 4
	HatchStyleDarkDownwardDiagonal 20
	HatchStyleDarkHorizontal 29
	HatchStyleDarkUpwardDiagonal 21
	HatchStyleDarkVertical 28
	HatchStyleDashedDownwardDiagonal 30
	HatchStyleDashedHorizontal 32
	HatchStyleDashedUpwardDiagonal 31
	HatchStyleDashedVertical 33
	HatchStyleDiagonalBrick 38
	HatchStyleDiagonalCross 5
	HatchStyleDivot 42
	HatchStyleDottedDiamond 44
	HatchStyleDottedGrid 43
	HatchStyleForwardDiagonal 2
	HatchStyleHorizontal 0
	HatchStyleHorizontalBrick 39
	HatchStyleLargeCheckerBoard 50
	HatchStyleLargeConfetti 35
	HatchStyleLargeGrid 4
	HatchStyleLightDownwardDiagonal 18
	HatchStyleLightHorizontal 25
	HatchStyleLightUpwardDiagonal 19
	HatchStyleLightVertical 24
	HatchStyleMax 52
	HatchStyleMin 0
	HatchStyleNarrowHorizontal 27
	HatchStyleNarrowVertical 26
	HatchStyleOutlinedDiamond 51
	HatchStylePlaid 41
	HatchStyleShingle 45
	HatchStyleSmallCheckerBoard 49
	HatchStyleSmallConfetti 34
	HatchStyleSmallGrid 48
	HatchStyleSolidDiamond 52
	HatchStyleSphere 47
	HatchStyleTotal 53
	HatchStyleTrellis 46
	HatchStyleVertical 1
	HatchStyleWave 37
	HatchStyleWeave 40
	HatchStyleWideDownwardDiagonal 22
	HatchStyleWideUpwardDiagonal 23
	HatchStyleZigZag 36
	Honeydew 4293984240
	HotkeyPrefixHide 2
	HotkeyPrefixNone 0
	HotkeyPrefixShow 1
	HotPink 4294928820
	ImageCodecFlagsBlockingDecode 32
	ImageCodecFlagsBuiltin 65536
	ImageCodecFlagsDecoder 2
	ImageCodecFlagsEncoder 1
	ImageCodecFlagsSeekableEncode 16
	ImageCodecFlagsSupportBitmap 4
	ImageCodecFlagsSupportVector 8
	ImageCodecFlagsSystem 131072
	ImageCodecFlagsUser 262144
	ImageFlagsCaching 131072
	ImageFlagsColorSpaceCMYK 32
	ImageFlagsColorSpaceGRAY 64
	ImageFlagsColorSpaceRGB 16
	ImageFlagsColorSpaceYCBCR 128
	ImageFlagsColorSpaceYCCK 256
	ImageFlagsHasAlpha 2
	ImageFlagsHasRealDPI 4096
	ImageFlagsHasRealPixelSize 8192
	ImageFlagsHasTranslucent 4
	ImageFlagsNone 0
	ImageFlagsPartiallyScalable 8
	ImageFlagsReadOnly 65536
	ImageFlagsScalable 1
	ImageFormatBMP '{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatEMF '{B96B3CAC-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatEXIF '{B96B3CB2-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatGIF '{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatIcon '{B96B3CB5-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatJPEG '{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatMemoryBMP '{B96B3CAA-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatPNG '{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatTIFF '{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatUndefined '{B96B3CA9-0728-11D3-9D7B-0000F81EF32E}'
	ImageFormatWMF '{B96B3CAD-0728-11D3-9D7B-0000F81EF32E}'
	ImageLockModeRead 1
	ImageLockModeUserInputBuf 4
	ImageLockModeWrite 2
	ImageTypeBitmap 1
	ImageTypeMetafile 2
	ImageTypeUnknown 0
	IndianRed 4291648604
	Indigo 4283105410
	InsufficientBuffer 5
	InterpolationModeBicubic 4
	InterpolationModeBilinear 3
	InterpolationModeDefault 0
	InterpolationModeHighQuality 2
	InterpolationModeHighQualityBicubic 7
	InterpolationModeHighQualityBilinear 6
	InterpolationModeInvalid 4294967295
	InterpolationModeLowQuality 1
	InterpolationModeNearestNeighbor 5
	InvalidParameter 2
	IPictureGUID '{7BF80980-BF32-101A-8BBB-00AA00300CAB}'
	Ivory 4294967280
	Khaki 4293977740
	Lavender 4293322490
	LavenderBlush 4294963445
	LawnGreen 4286381056
	LemonChiffon 4294965965
	LightBlue 4289583334
	LightCoral 4293951616
	LightCyan 4292935679
	LightGoldenrodYellow 4294638290
	LightGray 4292072403
	LightGreen 4287688336
	LightPink 4294948545
	LightSalmon 4294942842
	LightSeaGreen 4280332970
	LightSkyBlue 4287090426
	LightSlateGray 4286023833
	LightSteelBlue 4289774814
	LightYellow 4294967264
	Lime 4278255360
	LimeGreen 4281519410
	LinearGradientModeBackwardDiagonal 3
	LinearGradientModeForwardDiagonal 2
	LinearGradientModeHorizontal 0
	LinearGradientModeVertical 1
	LineCapAnchorMask 240
	LineCapArrowAnchor 20
	LineCapCustom 255
	LineCapDiamondAnchor 19
	LineCapFlat 0
	LineCapNoAnchor 16
	LineCapRound 2
	LineCapRoundAnchor 18
	LineCapSquare 1
	LineCapSquareAnchor 17
	LineCapTriangle 3
	LineJoinBevel 1
	LineJoinMiter 0
	LineJoinMiterClipped 3
	LineJoinRound 2
	Linen 4294635750
	LusNotInitialized 18
	Magenta 4294902015
	Maroon 4286578688
	MatrixOrderAppend 1
	MatrixOrderPrepend 0
	MediumAquamarine 4284927402
	MediumBlue 4278190285
	MediumOrchid 4290401747
	MediumPurple 4287852763
	MediumSeaGreen 4282168177
	MediumSlateBlue 4286277870
	MediumSpringGreen 4278254234
	MediumTurquoise 4282962380
	MediumVioletRed 4291237253
	MetafileFrameUnitDocument 5
	MetafileFrameUnitGdi 7
	MetafileFrameUnitInch 4
	MetafileFrameUnitMillimeter 6
	MetafileFrameUnitPixel 2
	MetafileFrameUnitPoint 3
	MetafileTypeEmf 3
	MetafileTypeEmfPlusDual 5
	MetafileTypeEmfPlusOnly 4
	MetafileTypeInvalid 0
	MetafileTypeWmf 1
	MetafileTypeWmfPlaceable 2
	MidnightBlue 4279834992
	MintCream 4294311930
	MistyRose 4294960353
	Moccasin 4294960309
	NavajoWhite 4294958765
	Navy 4278190208
	NotImplemented 6
	NotTrueTypeFont 16
	ObjectBusy 4
	ObjectTypeBrush 1
	ObjectTypeCustomLineCap 9
	ObjectTypeFont 6
	ObjectTypeImage 5
	ObjectTypeImageAttributes 8
	ObjectTypeInvalid 0
	ObjectTypeMax 9
	ObjectTypeMin 1
	ObjectTypePath 3
	ObjectTypePen 2
	ObjectTypeRegion 4
	ObjectTypeStringFormat 7
	Ok 0
	OldLace 4294833638
	Olive 4286611456
	OliveDrab 4285238819
	Orange 4294944000
	OrangeRed 4294919424
	Orchid 4292505814
	OutOfMemory 3
	PaleGoldenrod 4293847210
	PaleGreen 4288215960
	PaletteFlagsGrayScale 2
	PaletteFlagsHalftone 4
	PaletteFlagsHasAlpha 1
	PaleTurquoise 4289720046
	PaleVioletRed 4292571283
	PapayaWhip 4294963157
	PathPointTypeBezier 3
	PathPointTypeBezier3 3
	PathPointTypeCloseSubpath 128
	PathPointTypeDashMode 16
	PathPointTypeLine 1
	PathPointTypePathMarker 32
	PathPointTypePathTypeMask 7
	PathPointTypeStart 0
	PeachPuff 4294957753
	PenAlignmentCenter 0
	PenAlignmentInset 1
	PenTypeHatchFill 1
	PenTypeLinearGradient 4
	PenTypePathGradient 3
	PenTypeSolidColor 0
	PenTypeTextureFill 2
	PenTypeUnknown 4294967295
	Peru 4291659071
	Pink 4294951115
	PixelFormat16bppARGB1555 397319
	PixelFormat16bppGrayScale 1052676
	PixelFormat16bppRGB555 135173
	PixelFormat16bppRGB565 135174
	PixelFormat1bppIndexed 196865
	PixelFormat24bppRGB 137224
	PixelFormat32bppARGB 2498570
	PixelFormat32bppPARGB 925707
	PixelFormat32bppRGB 139273
	PixelFormat48bppRGB 1060876
	PixelFormat4bppIndexed 197634
	PixelFormat64bppARGB 3424269
	PixelFormat64bppPARGB 29622286
	PixelFormat8bppIndexed 198659
	PixelFormatAlpha 262144
	PixelFormatCanonical 2097152
	PixelFormatDontCare 0
	PixelFormatExtended 1048576
	PixelFormatGDI 131072
	PixelFormatIndexed 65536
	PixelFormatMax 15
	PixelFormatPAlpha 524288
	PixelFormatUndefined 0
	PixelOffsetModeDefault 0
	PixelOffsetModeHalf 4
	PixelOffsetModeHighQuality 2
	PixelOffsetModeHighSpeed 1
	PixelOffsetModeInvalid 4294967295
	PixelOffsetModeNone 3
	Plum 4292714717
	PowderBlue 4289781990
	PropertyNotFound 19
	PropertyNotSupported 20
	PropertyTagArtist 315
	PropertyTagBitsPerSample 258
	PropertyTagCellHeight 265
	PropertyTagCellWidth 264
	PropertyTagChrominanceTable 20625
	PropertyTagColorMap 320
	PropertyTagColorTransferFunction 20506
	PropertyTagCompression 259
	PropertyTagCopyright 33432
	PropertyTagDateTime 306
	PropertyTagDocumentName 269
	PropertyTagDotRange 336
	PropertyTagEquipMake 271
	PropertyTagEquipModel 272
	PropertyTagExifAperture 37378
	PropertyTagExifBrightness 37379
	PropertyTagExifCfaPattern 41730
	PropertyTagExifColorSpace 40961
	PropertyTagExifCompBPP 37122
	PropertyTagExifCompConfig 37121
	PropertyTagExifDTDigitized 36868
	PropertyTagExifDTDigSS 37522
	PropertyTagExifDTOrig 36867
	PropertyTagExifDTOrigSS 37521
	PropertyTagExifDTSubsec 37520
	PropertyTagExifExposureBias 37380
	PropertyTagExifExposureIndex 41493
	PropertyTagExifExposureProg 34850
	PropertyTagExifExposureTime 33434
	PropertyTagExifFileSource 41728
	PropertyTagExifFlash 37385
	PropertyTagExifFlashEnergy 41483
	PropertyTagExifFNumber 33437
	PropertyTagExifFocalLength 37386
	PropertyTagExifFocalResUnit 41488
	PropertyTagExifFocalXRes 41486
	PropertyTagExifFocalYRes 41487
	PropertyTagExifFPXVer 40960
	PropertyTagExifIFD 34665
	PropertyTagExifInterop 40965
	PropertyTagExifISOSpeed 34855
	PropertyTagExifLightSource 37384
	PropertyTagExifMakerNote 37500
	PropertyTagExifMaxAperture 37381
	PropertyTagExifMeteringMode 37383
	PropertyTagExifOECF 34856
	PropertyTagExifPixXDim 40962
	PropertyTagExifPixYDim 40963
	PropertyTagExifRelatedWav 40964
	PropertyTagExifSceneType 41729
	PropertyTagExifSensingMethod 41495
	PropertyTagExifShutterSpeed 37377
	PropertyTagExifSpatialFR 41484
	PropertyTagExifSpectralSense 34852
	PropertyTagExifSubjectDist 37382
	PropertyTagExifSubjectLoc 41492
	PropertyTagExifUserComment 37510
	PropertyTagExifVer 36864
	PropertyTagExtraSamples 338
	PropertyTagFillOrder 266
	PropertyTagFrameDelay 20736
	PropertyTagFreeByteCounts 289
	PropertyTagFreeOffset 288
	PropertyTagGamma 769
	PropertyTagGpsAltitude 6
	PropertyTagGpsAltitudeRef 5
	PropertyTagGpsDestBear 24
	PropertyTagGpsDestBearRef 23
	PropertyTagGpsDestDist 26
	PropertyTagGpsDestDistRef 25
	PropertyTagGpsDestLat 20
	PropertyTagGpsDestLatRef 19
	PropertyTagGpsDestLong 22
	PropertyTagGpsDestLongRef 21
	PropertyTagGpsGpsDop 11
	PropertyTagGpsGpsMeasureMode 10
	PropertyTagGpsGpsSatellites 8
	PropertyTagGpsGpsStatus 9
	PropertyTagGpsGpsTime 7
	PropertyTagGpsImgDir 17
	PropertyTagGpsImgDirRef 16
	PropertyTagGpsLatitude 2
	PropertyTagGpsLatitudeRef 1
	PropertyTagGpsLongitude 4
	PropertyTagGpsLongitudeRef 3
	PropertyTagGpsMapDatum 18
	PropertyTagGpsSpeed 13
	PropertyTagGpsSpeedRef 12
	PropertyTagGpsTrack 15
	PropertyTagGpsTrackRef 14
	PropertyTagGpsVer 0
	PropertyTagGrayResponseCurve 291
	PropertyTagGrayResponseUnit 290
	PropertyTagGridSize 20497
	PropertyTagHalftoneDegree 20492
	PropertyTagHalftoneHints 321
	PropertyTagHalftoneLPI 20490
	PropertyTagHalftoneLPIUnit 20491
	PropertyTagHalftoneMisc 20494
	PropertyTagHalftoneScreen 20495
	PropertyTagHalftoneShape 20493
	PropertyTagHostComputer 316
	PropertyTagICCProfile 34675
	PropertyTagICCProfileDescriptor 770
	PropertyTagImageDescription 270
	PropertyTagImageHeight 257
	PropertyTagImageTitle 800
	PropertyTagImageWidth 256
	PropertyTagInkNames 333
	PropertyTagInkSet 332
	PropertyTagJPEGACTables 521
	PropertyTagJPEGDCTables 520
	PropertyTagJPEGInterFormat 513
	PropertyTagJPEGInterLength 514
	PropertyTagJPEGLosslessPredictors 517
	PropertyTagJPEGQTables 519
	PropertyTagJPEGQuality 20496
	PropertyTagJPEGRestartInterval 515
	PropertyTagJPEointTransforms 518
	PropertyTagJPEroc 512
	PropertyTagLoopCount 20737
	PropertyTagLuminanceTable 20624
	PropertyTagMaxSampleValue 281
	PropertyTagMinSampleValue 280
	PropertyTagNewSubfileType 254
	PropertyTagNumberOfInks 334
	PropertyTagOrientation 274
	PropertyTagPageName 285
	PropertyTagPageNumber 297
	PropertyTagPaletteHistogram 20755
	PropertyTagPhotometricInterp 262
	PropertyTagPixelPerUnitX 20753
	PropertyTagPixelPerUnitY 20754
	PropertyTagPixelUnit 20752
	PropertyTagPlanarConfig 284
	PropertyTagPredictor 317
	PropertyTagPrimaryChromaticities 319
	PropertyTagPrintFlags 20485
	PropertyTagPrintFlagsBleedWidth 20488
	PropertyTagPrintFlagsBleedWidthScale 20489
	PropertyTagPrintFlagsCrop 20487
	PropertyTagPrintFlagsVersion 20486
	PropertyTagREFBlackWhite 532
	PropertyTagResolutionUnit 296
	PropertyTagResolutionXLengthUnit 20483
	PropertyTagResolutionXUnit 20481
	PropertyTagResolutionYLengthUnit 20484
	PropertyTagResolutionYUnit 20482
	PropertyTagRowsPerStrip 278
	PropertyTagSampleFormat 339
	PropertyTagSamplesPerPixel 277
	PropertyTagsIFD 34853
	PropertyTagSMaxSampleValue 341
	PropertyTagSMinSampleValue 340
	PropertyTagSoftwareUsed 305
	PropertyTagSRGBRenderingIntent 771
	PropertyTagStripBytesCount 279
	PropertyTagStripOffsets 273
	PropertyTagSubfileType 255
	PropertyTagT4Option 292
	PropertyTagT6Option 293
	PropertyTagTargetPrinter 337
	PropertyTagThreshHolding 263
	PropertyTagThumbnailArtist 20532
	PropertyTagThumbnailBitsPerSample 20514
	PropertyTagThumbnailColorDepth 20501
	PropertyTagThumbnailCompressedSize 20505
	PropertyTagThumbnailCompression 20515
	PropertyTagThumbnailCopyRight 20539
	PropertyTagThumbnailData 20507
	PropertyTagThumbnailDateTime 20531
	PropertyTagThumbnailEquipMake 20518
	PropertyTagThumbnailEquipModel 20519
	PropertyTagThumbnailFormat 20498
	PropertyTagThumbnailHeight 20500
	PropertyTagThumbnailImageDescription 20517
	PropertyTagThumbnailImageHeight 20513
	PropertyTagThumbnailImageWidth 20512
	PropertyTagThumbnailOrientation 20521
	PropertyTagThumbnailPhotometricInterp 20516
	PropertyTagThumbnailPlanarConfig 20527
	PropertyTagThumbnailPlanes 20502
	PropertyTagThumbnailPrimaryChromaticities 20534
	PropertyTagThumbnailRawBytes 20503
	PropertyTagThumbnailRefBlackWhite 20538
	PropertyTagThumbnailResolutionUnit 20528
	PropertyTagThumbnailResolutionX 20525
	PropertyTagThumbnailResolutionY 20526
	PropertyTagThumbnailRowsPerStrip 20523
	PropertyTagThumbnailSamplesPerPixel 20522
	PropertyTagThumbnailSize 20504
	PropertyTagThumbnailSoftwareUsed 20530
	PropertyTagThumbnailStripBytesCount 20524
	PropertyTagThumbnailStripOffsets 20520
	PropertyTagThumbnailTransferFunction 20529
	PropertyTagThumbnailWhitePoint 20533
	PropertyTagThumbnailWidth 20499
	PropertyTagThumbnailYCbCrCoefficients 20535
	PropertyTagThumbnailYCbCrPositioning 20537
	PropertyTagThumbnailYCbCrSubsampling 20536
	PropertyTagTileByteCounts 325
	PropertyTagTileLength 323
	PropertyTagTileOffset 324
	PropertyTagTileWidth 322
	PropertyTagTransferFuncition 301
	PropertyTagTransferRange 342
	PropertyTagTypeASCII 2
	PropertyTagTypeByte 1
	PropertyTagTypeLong 4
	PropertyTagTypeRational 5
	PropertyTagTypeShort 3
	PropertyTagTypeSLONG 9
	PropertyTagTypeSRational 10
	PropertyTagTypeUndefined 7
	PropertyTagWhitePoint 318
	PropertyTagXPosition 286
	PropertyTagXResolution 282
	PropertyTagYCbCrCoefficients 529
	PropertyTagYCbCrPositioning 531
	PropertyTagYCbCrSubsampling 530
	PropertyTagYPosition 287
	PropertyTagYResolution 283
	Purple 4286578816
	QualityModeDefault 0
	QualityModeHigh 2
	QualityModeInvalid 4294967295
	QualityModeLow 1
	Red 4294901760
	RedMask 16711680
	RedShift 16
	RosyBrown 4290547599
	Rotate180FlipNone 2
	Rotate180FlipX 6
	Rotate180FlipXY 0
	Rotate180FlipY 4
	Rotate270FlipNone 3
	Rotate270FlipX 7
	Rotate270FlipXY 1
	Rotate270FlipY 5
	Rotate90FlipNone 1
	Rotate90FlipX 5
	Rotate90FlipXY 3
	Rotate90FlipY 7
	RotateNoneFlipNone 0
	RotateNoneFlipX 4
	RotateNoneFlipXY 2
	RotateNoneFlipY 6
	RoyalBlue 4282477025
	SaddleBrown 4287317267
	Salmon 4294606962
	SandyBrown 4294222944
	SeaGreen 4281240407
	SeaShell 4294964718
	Sienna 4288696877
	Silver 4290822336
	SkyBlue 4287090411
	SlateBlue 4285160141
	SlateGray 4285563024
	SmoothingModeAntiAlias 4
	SmoothingModeDefault 0
	SmoothingModeHighQuality 2
	SmoothingModeHighSpeed 1
	SmoothingModeInvalid 4294967295
	SmoothingModeNone 3
	Snow 4294966010
	SpringGreen 4278255487
	SteelBlue 4282811060
	StringAlignmentCenter 1
	StringAlignmentFar 2
	StringAlignmentNear 0
	StringDigitSubstituteNational 2
	StringDigitSubstituteNone 1
	StringDigitSubstituteTraditional 3
	StringDigitSubstituteUser 0
	StringFormatFlagsDirectionRightToLeft 1
	StringFormatFlagsDirectionVertical 2
	StringFormatFlagsDisplayFormatControl 32
	StringFormatFlagsLineLimit 8192
	StringFormatFlagsMeasureTrailingSpaces 2048
	StringFormatFlagsNoClip 16384
	StringFormatFlagsNoFitBlackBox 4
	StringFormatFlagsNoFontFallback 1024
	StringFormatFlagsNoWrap 4096
	StringTrimmingCharacter 1
	StringTrimmingEllipsisCharacter 3
	StringTrimmingEllipsisPath 5
	StringTrimmingEllipsisWord 4
	StringTrimmingNone 0
	StringTrimmingWord 2
	Tan 4291998860
	Teal 4278222976
	TextRenderingHintAntiAlias 4
	TextRenderingHintAntiAliasGridFit 3
	TextRenderingHintClearTypeGridFit 5
	TextRenderingHintSingleBitPerPixel 2
	TextRenderingHintSingleBitPerPixelGridFit 1
	TextRenderingHintSystemDefault 0
	Thistle 4292394968
	Tomato 4294927175
	Transparent 16777215
	Turquoise 4282441936
	UnitDisplay 1
	UnitDocument 5
	UnitInch 4
	UnitMillimeter 6
	UnitPixel 2
	UnitPoint 3
	UnitWorld 0
	UnknownImageFormat 13
	UnsupportedlusVersion 17
	ValueOverflow 11
	Violet 4293821166
	WarpModeBilinear 1
	WarpModePerspective 0
	Wheat 4294303411
	White 4294967295
	WhiteSmoke 4294309365
	Win32Error 7
	WmfRecordTypeAbortDoc 65618
	WmfRecordTypeAnimatePalette 66614
	WmfRecordTypeArc 67607
	WmfRecordTypeBitBlt 67874
	WmfRecordTypeChord 67632
	WmfRecordTypeCreateBitmap 67326
	WmfRecordTypeCreateBitmapIndirect 66301
	WmfRecordTypeCreateBrush 65784
	WmfRecordTypeCreateBrushIndirect 66300
	WmfRecordTypeCreateFontIndirect 66299
	WmfRecordTypeCreatePalette 65783
	WmfRecordTypeCreatePatternBrush 66041
	WmfRecordTypeCreatePenIndirect 66298
	WmfRecordTypeCreateRegion 67327
	WmfRecordTypeDeleteObject 66032
	WmfRecordTypeDIBBitBlt 67904
	WmfRecordTypeDIBCreatePatternBrush 65858
	WmfRecordTypeDIBStretchBlt 68417
	WmfRecordTypeDrawText 67119
	WmfRecordTypeEllipse 66584
	WmfRecordTypeEndDoc 65630
	WmfRecordTypeEndPage 65616
	WmfRecordTypeEscape 67110
	WmfRecordTypeExcludeClipRect 66581
	WmfRecordTypeExtFloodFill 66888
	WmfRecordTypeExtTextOut 68146
	WmfRecordTypeFillRegion 66088
	WmfRecordTypeFloodFill 66585
	WmfRecordTypeFrameRegion 66601
	WmfRecordTypeIntersectClipRect 66582
	WmfRecordTypeInvertRegion 65834
	WmfRecordTypeLineTo 66067
	WmfRecordTypeMoveTo 66068
	WmfRecordTypeOffsetClipRgn 66080
	WmfRecordTypeOffsetViewportOrg 66065
	WmfRecordTypeOffsetWindowOrg 66063
	WmfRecordTypePaintRegion 65835
	WmfRecordTypePatBlt 67101
	WmfRecordTypePie 67610
	WmfRecordTypePolygon 66340
	WmfRecordTypePolyline 66341
	WmfRecordTypePolyPolygon 66872
	WmfRecordTypeRealizePalette 65589
	WmfRecordTypeRectangle 66587
	WmfRecordTypeResetDC 65868
	WmfRecordTypeResizePalette 65849
	WmfRecordTypeRestoreDC 65831
	WmfRecordTypeRoundRect 67100
	WmfRecordTypeSaveDC 65566
	WmfRecordTypeScaleViewportExt 66578
	WmfRecordTypeScaleWindowExt 66576
	WmfRecordTypeSelectClipRegion 65836
	WmfRecordTypeSelectObject 65837
	WmfRecordTypeSelectPalette 66100
	WmfRecordTypeSetBkColor 66049
	WmfRecordTypeSetBkMode 65794
	WmfRecordTypeSetDIBToDev 68915
	WmfRecordTypeSetLayout 65865
	WmfRecordTypeSetMapMode 65795
	WmfRecordTypeSetMapperFlags 66097
	WmfRecordTypeSetPalEntries 65591
	WmfRecordTypeSetPixel 66591
	WmfRecordTypeSetPolyFillMode 65798
	WmfRecordTypeSetRelAbs 65797
	WmfRecordTypeSetROP2 65796
	WmfRecordTypeSetStretchBltMode 65799
	WmfRecordTypeSetTextAlign 65838
	WmfRecordTypeSetTextCharExtra 65800
	WmfRecordTypeSetTextColor 66057
	WmfRecordTypeSetTextJustification 66058
	WmfRecordTypeSetViewportExt 66062
	WmfRecordTypeSetViewportOrg 66061
	WmfRecordTypeSetWindowExt 66060
	WmfRecordTypeSetWindowOrg 66059
	WmfRecordTypeStartDoc 65869
	WmfRecordTypeStartPage 65615
	WmfRecordTypeStretchBlt 68387
	WmfRecordTypeStretchDIB 69443
	WmfRecordTypeTextOut 66849
	WrapModeClamp 4
	WrapModeTile 0
	WrapModeTileFlipX 1
	WrapModeTileFlipXY 3
	WrapModeTileFlipy 2
	WrongState 8
	Yellow 4294967040
	YellowGreen 4288335154)]

{ #category : #errors }
GDIPlusObject class >> gdiPlusError: status [
	"
	GDIPlusObject gdiPlusError: 3
	"
	^GDIPlusError signalStatus: status type: self]

{ #category : #initialization }
GDIPlusObject class >> initialize [
	"
	GDIPlusObject initialize
	"
	super initialize.
	self initializeConstants]

{ #category : #initialization }
GDIPlusObject class >> initializeConstants [
	self initializeGDIPlusConstants]

{ #category : #initialization }
GDIPlusObject class >> initializeGDIPlusConstants [
	self
		initializeGDIPlusConstants1;
		initializeGDIPlusConstants2;
		initializeGDIPlusConstants3;
		initializeGDIPlusConstants4]

{ #category : #initialization }
GDIPlusObject class >> initializeGDIPlusConstants1 [
	GDIPlusConstants
		at: 'Aborted' put: 9;
		at: 'AccessDenied' put: 12;
		at: 'AliceBlue' put: 4293982463;
		at: 'AlphaMask' put: 4278190080;
		at: 'AlphaShift' put: 24;
		at: 'AntiqueWhite' put: 4294634455;
		at: 'Aqua' put: 4278255615;
		at: 'Aquamarine' put: 4286578644;
		at: 'Azure' put: 4293984255;
		at: 'Beige' put: 4294309340;
		at: 'Bisque' put: 4294960324;
		at: 'Black' put: 4278190080;
		at: 'BlanchedAlmond' put: 4294962125;
		at: 'Blue' put: 4278190335;
		at: 'BlueMask' put: 255;
		at: 'BlueShift' put: 0;
		at: 'BlueViolet' put: 4287245282;
		at: 'Brown' put: 4289014314;
		at: 'BrushTypeHatchFill' put: 1;
		at: 'BrushTypeLinearGradient' put: 4;
		at: 'BrushTypePathGradient' put: 3;
		at: 'BrushTypeSolidColor' put: 0;
		at: 'BrushTypeTextureFill' put: 2;
		at: 'BurlyWood' put: 4292786311;
		at: 'CadetBlue' put: 4284456608;
		at: 'Chartreuse' put: 4286578432;
		at: 'Chocolate' put: 4291979550;
		at: 'CodecIImageBytes' put: '{025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC}';
		at: 'ColorAdjustTypeAny' put: 6;
		at: 'ColorAdjustTypeBitmap' put: 1;
		at: 'ColorAdjustTypeBrush' put: 2;
		at: 'ColorAdjustTypeCount' put: 5;
		at: 'ColorAdjustTypeDefault' put: 0;
		at: 'ColorAdjustTypePen' put: 3;
		at: 'ColorAdjustTypeText' put: 4;
		at: 'ColorChannelFlagsC' put: 0;
		at: 'ColorChannelFlagsK' put: 3;
		at: 'ColorChannelFlagsLast' put: 4;
		at: 'ColorChannelFlagsM' put: 1;
		at: 'ColorChannelFlagsY' put: 2;
		at: 'ColorMatrixFlagsAltGray' put: 2;
		at: 'ColorMatrixFlagsDefault' put: 0;
		at: 'ColorMatrixFlagsSkipGrays' put: 1;
		at: 'ColorModeARGB32' put: 0;
		at: 'ColorModeARGB64' put: 1;
		at: 'CombineModeComplement' put: 5;
		at: 'CombineModeExclude' put: 4;
		at: 'CombineModeIntersect' put: 1;
		at: 'CombineModeReplace' put: 0;
		at: 'CombineModeUnion' put: 2;
		at: 'CombineModeXor' put: 3;
		at: 'CompositingModeSourceCopy' put: 1;
		at: 'CompositingModeSourceOver' put: 0;
		at: 'CompositingQualityAssumeLinear' put: 4;
		at: 'CompositingQualityDefault' put: 0;
		at: 'CompositingQualityGammaCorrected' put: 3;
		at: 'CompositingQualityHighQuality' put: 2;
		at: 'CompositingQualityHighSpeed' put: 1;
		at: 'CompositingQualityInvalid' put: 4294967295;
		at: 'CoordinateSpaceDevice' put: 2;
		at: 'CoordinateSpacePage' put: 1;
		at: 'CoordinateSpaceWorld' put: 0;
		at: 'Coral' put: 4294934352;
		at: 'CornflowerBlue' put: 4284782061;
		at: 'Cornsilk' put: 4294965468;
		at: 'Crimson' put: 4292613180;
		at: 'CustomLineCapTypeAdjustableArrow' put: 1;
		at: 'CustomLineCapTypeDefault' put: 0;
		at: 'Cyan' put: 4278255615;
		at: 'DarkBlue' put: 4278190219;
		at: 'DarkCyan' put: 4278225803;
		at: 'DarkGoldenrod' put: 4290283019;
		at: 'DarkGray' put: 4289309097;
		at: 'DarkGreen' put: 4278215680;
		at: 'DarkKhaki' put: 4290623339;
		at: 'DarkMagenta' put: 4287299723;
		at: 'DarkOliveGreen' put: 4283788079;
		at: 'DarkOrange' put: 4294937600;
		at: 'DarkOrchid' put: 4288230092;
		at: 'DarkRed' put: 4287299584;
		at: 'DarkSalmon' put: 4293498490;
		at: 'DarkSeaGreen' put: 4287609995;
		at: 'DarkSlateBlue' put: 4282924427;
		at: 'DarkSlateGray' put: 4281290575;
		at: 'DarkTurquoise' put: 4278243025;
		at: 'DarkViolet' put: 4287889619;
		at: 'DashCapFlat' put: 0;
		at: 'DashCapRound' put: 2;
		at: 'DashCapTriangle' put: 3;
		at: 'DashStyleCustom' put: 5;
		at: 'DashStyleDash' put: 1;
		at: 'DashStyleDashDot' put: 3;
		at: 'DashStyleDashDotDot' put: 4;
		at: 'DashStyleDot' put: 2;
		at: 'DashStyleSolid' put: 0;
		at: 'DeepPink' put: 4294907027;
		at: 'DeepSkyBlue' put: 4278239231]

{ #category : #initialization }
GDIPlusObject class >> initializeGDIPlusConstants2 [
	GDIPlusConstants
		at: 'DimGray' put: 4285098345;
		at: 'DodgerBlue' put: 4280193279;
		at: 'DriverStringOptionsCmapLookup' put: 1;
		at: 'DriverStringOptionsLimitSubpixel' put: 8;
		at: 'DriverStringOptionsRealizedAdvance' put: 4;
		at: 'DriverStringOptionsVertical' put: 2;
		at: 'EmfPlusRecordTotal' put: 16439;
		at: 'EmfPlusRecordTypeBeginContainer' put: 16423;
		at: 'EmfPlusRecordTypeBeginContainerNoParams' put: 16424;
		at: 'EmfPlusRecordTypeClear' put: 16393;
		at: 'EmfPlusRecordTypeComment' put: 16387;
		at: 'EmfPlusRecordTypeDrawArc' put: 16402;
		at: 'EmfPlusRecordTypeDrawBeziers' put: 16409;
		at: 'EmfPlusRecordTypeDrawClosedCurve' put: 16407;
		at: 'EmfPlusRecordTypeDrawCurve' put: 16408;
		at: 'EmfPlusRecordTypeDrawDriverString' put: 16438;
		at: 'EmfPlusRecordTypeDrawEllipse' put: 16399;
		at: 'EmfPlusRecordTypeDrawImage' put: 16410;
		at: 'EmfPlusRecordTypeDrawImagePoints' put: 16411;
		at: 'EmfPlusRecordTypeDrawLines' put: 16397;
		at: 'EmfPlusRecordTypeDrawPath' put: 16405;
		at: 'EmfPlusRecordTypeDrawPie' put: 16401;
		at: 'EmfPlusRecordTypeDrawRects' put: 16395;
		at: 'EmfPlusRecordTypeDrawString' put: 16412;
		at: 'EmfPlusRecordTypeEndContainer' put: 16425;
		at: 'EmfPlusRecordTypeEndOfFile' put: 16386;
		at: 'EmfPlusRecordTypeFillClosedCurve' put: 16406;
		at: 'EmfPlusRecordTypeFillEllipse' put: 16398;
		at: 'EmfPlusRecordTypeFillPath' put: 16404;
		at: 'EmfPlusRecordTypeFillPie' put: 16400;
		at: 'EmfPlusRecordTypeFillPolygon' put: 16396;
		at: 'EmfPlusRecordTypeFillRects' put: 16394;
		at: 'EmfPlusRecordTypeFillRegion' put: 16403;
		at: 'EmfPlusRecordTypeGetDC' put: 16388;
		at: 'EmfPlusRecordTypeHeader' put: 16385;
		at: 'EmfPlusRecordTypeInvalid' put: 16384;
		at: 'EmfPlusRecordTypeMax' put: 16438;
		at: 'EmfPlusRecordTypeMin' put: 16385;
		at: 'EmfPlusRecordTypeMultiFormatEnd' put: 16391;
		at: 'EmfPlusRecordTypeMultiFormatSection' put: 16390;
		at: 'EmfPlusRecordTypeMultiFormatStart' put: 16389;
		at: 'EmfPlusRecordTypeMultiplyWorldTransform' put: 16428;
		at: 'EmfPlusRecordTypeObject' put: 16392;
		at: 'EmfPlusRecordTypeOffsetClip' put: 16437;
		at: 'EmfPlusRecordTypeResetClip' put: 16433;
		at: 'EmfPlusRecordTypeResetWorldTransform' put: 16427;
		at: 'EmfPlusRecordTypeRestore' put: 16422;
		at: 'EmfPlusRecordTypeRotateWorldTransform' put: 16431;
		at: 'EmfPlusRecordTypeSave' put: 16421;
		at: 'EmfPlusRecordTypeScaleWorldTransform' put: 16430;
		at: 'EmfPlusRecordTypeSetAntiAliasMode' put: 16414;
		at: 'EmfPlusRecordTypeSetClipPath' put: 16435;
		at: 'EmfPlusRecordTypeSetClipRect' put: 16434;
		at: 'EmfPlusRecordTypeSetClipRegion' put: 16436;
		at: 'EmfPlusRecordTypeSetCompositingMode' put: 16419;
		at: 'EmfPlusRecordTypeSetCompositingQuality' put: 16420;
		at: 'EmfPlusRecordTypeSetInterpolationMode' put: 16417;
		at: 'EmfPlusRecordTypeSetPageTransform' put: 16432;
		at: 'EmfPlusRecordTypeSetPixelOffsetMode' put: 16418;
		at: 'EmfPlusRecordTypeSetRenderingOrigin' put: 16413;
		at: 'EmfPlusRecordTypeSetTextContrast' put: 16416;
		at: 'EmfPlusRecordTypeSetTextRenderingHint' put: 16415;
		at: 'EmfPlusRecordTypeSetWorldTransform' put: 16426;
		at: 'EmfPlusRecordTypeTranslateWorldTransform' put: 16429;
		at: 'EmfRecordTypeAbortPath' put: 68;
		at: 'EmfRecordTypeAlphaBlend' put: 114;
		at: 'EmfRecordTypeAngleArc' put: 41;
		at: 'EmfRecordTypeArc' put: 45;
		at: 'EmfRecordTypeArcTo' put: 55;
		at: 'EmfRecordTypeBeginPath' put: 59;
		at: 'EmfRecordTypeBitBlt' put: 76;
		at: 'EmfRecordTypeChord' put: 46;
		at: 'EmfRecordTypeCloseFigure' put: 61;
		at: 'EmfRecordTypeColorCorrectPalette' put: 111;
		at: 'EmfRecordTypeColorMatchToTargetW' put: 121;
		at: 'EmfRecordTypeCreateBrushIndirect' put: 39;
		at: 'EmfRecordTypeCreateColorSpace' put: 99;
		at: 'EmfRecordTypeCreateColorSpaceW' put: 122;
		at: 'EmfRecordTypeCreateDIBPatternBrushPt' put: 94;
		at: 'EmfRecordTypeCreateMonoBrush' put: 93;
		at: 'EmfRecordTypeCreatePalette' put: 49;
		at: 'EmfRecordTypeCreatePen' put: 38;
		at: 'EmfRecordTypeDeleteColorSpace' put: 101;
		at: 'EmfRecordTypeDeleteObject' put: 40;
		at: 'EmfRecordTypeDrawEscape' put: 105;
		at: 'EmfRecordTypeEllipse' put: 42;
		at: 'EmfRecordTypeEndPath' put: 60;
		at: 'EmfRecordTypeEOF' put: 14;
		at: 'EmfRecordTypeExcludeClipRect' put: 29;
		at: 'EmfRecordTypeExtCreateFontIndirect' put: 82;
		at: 'EmfRecordTypeExtCreatePen' put: 95;
		at: 'EmfRecordTypeExtEscape' put: 106;
		at: 'EmfRecordTypeExtFloodFill' put: 53;
		at: 'EmfRecordTypeExtSelectClipRgn' put: 75;
		at: 'EmfRecordTypeExtTextOutA' put: 83;
		at: 'EmfRecordTypeExtTextOutW' put: 84;
		at: 'EmfRecordTypeFillPath' put: 62;
		at: 'EmfRecordTypeFillRgn' put: 71;
		at: 'EmfRecordTypeFlattenPath' put: 65;
		at: 'EmfRecordTypeForceUFIMapping' put: 109;
		at: 'EmfRecordTypeFrameRgn' put: 72;
		at: 'EmfRecordTypeGdiComment' put: 70;
		at: 'EmfRecordTypeGLSBoundedRecord' put: 103;
		at: 'EmfRecordTypeGLSRecord' put: 102;
		at: 'EmfRecordTypeGradientFill' put: 118;
		at: 'EmfRecordTypeHeader' put: 1;
		at: 'EmfRecordTypeIntersectClipRect' put: 30;
		at: 'EmfRecordTypeInvertRgn' put: 73;
		at: 'EmfRecordTypeLineTo' put: 54;
		at: 'EmfRecordTypeMaskBlt' put: 78;
		at: 'EmfRecordTypeMax' put: 122;
		at: 'EmfRecordTypeMin' put: 1;
		at: 'EmfRecordTypeModifyWorldTransform' put: 36;
		at: 'EmfRecordTypeMoveToEx' put: 27;
		at: 'EmfRecordTypeNamedEscape' put: 110;
		at: 'EmfRecordTypeOffsetClipRgn' put: 26;
		at: 'EmfRecordTypePaintRgn' put: 74;
		at: 'EmfRecordTypePie' put: 47;
		at: 'EmfRecordTypePixelFormat' put: 104;
		at: 'EmfRecordTypePlgBlt' put: 79;
		at: 'EmfRecordTypePolyBezier' put: 2;
		at: 'EmfRecordTypePolyBezier16' put: 85;
		at: 'EmfRecordTypePolyBezierTo' put: 5;
		at: 'EmfRecordTypePolyBezierTo16' put: 88;
		at: 'EmfRecordTypePolyDraw' put: 56;
		at: 'EmfRecordTypePolyDraw16' put: 92;
		at: 'EmfRecordTypePolygon' put: 3;
		at: 'EmfRecordTypePolygon16' put: 86;
		at: 'EmfRecordTypePolyline' put: 4;
		at: 'EmfRecordTypePolyline16' put: 87;
		at: 'EmfRecordTypePolyLineTo' put: 6;
		at: 'EmfRecordTypePolylineTo16' put: 89;
		at: 'EmfRecordTypePolyPolygon' put: 8;
		at: 'EmfRecordTypePolyPolygon16' put: 91;
		at: 'EmfRecordTypePolyPolyline' put: 7;
		at: 'EmfRecordTypePolyPolyline16' put: 90;
		at: 'EmfRecordTypePolyTextOutA' put: 96;
		at: 'EmfRecordTypePolyTextOutW' put: 97;
		at: 'EmfRecordTypeRealizePalette' put: 52;
		at: 'EmfRecordTypeRectangle' put: 43;
		at: 'EmfRecordTypeReserved_069' put: 69;
		at: 'EmfRecordTypeReserved_117' put: 117;
		at: 'EmfRecordTypeResizePalette' put: 51;
		at: 'EmfRecordTypeRestoreDC' put: 34;
		at: 'EmfRecordTypeRoundRect' put: 44;
		at: 'EmfRecordTypeSaveDC' put: 33;
		at: 'EmfRecordTypeScaleViewportExtEx' put: 31;
		at: 'EmfRecordTypeScaleWindowExtEx' put: 32;
		at: 'EmfRecordTypeSelectClipPath' put: 67;
		at: 'EmfRecordTypeSelectObject' put: 37;
		at: 'EmfRecordTypeSelectPalette' put: 48;
		at: 'EmfRecordTypeSetArcDirection' put: 57;
		at: 'EmfRecordTypeSetBkColor' put: 25;
		at: 'EmfRecordTypeSetBkMode' put: 18;
		at: 'EmfRecordTypeSetBrushOrgEx' put: 13;
		at: 'EmfRecordTypeSetColorAdjustment' put: 23;
		at: 'EmfRecordTypeSetColorSpace' put: 100;
		at: 'EmfRecordTypeSetDIBitsToDevice' put: 80;
		at: 'EmfRecordTypeSetICMMode' put: 98;
		at: 'EmfRecordTypeSetICMProfileA' put: 112;
		at: 'EmfRecordTypeSetICMProfileW' put: 113;
		at: 'EmfRecordTypeSetLayout' put: 115;
		at: 'EmfRecordTypeSetLinkedUFIs' put: 119;
		at: 'EmfRecordTypeSetMapMode' put: 17;
		at: 'EmfRecordTypeSetMapperFlags' put: 16;
		at: 'EmfRecordTypeSetMetaRgn' put: 28;
		at: 'EmfRecordTypeSetMiterLimit' put: 58;
		at: 'EmfRecordTypeSetPaletteEntries' put: 50;
		at: 'EmfRecordTypeSetPixelV' put: 15;
		at: 'EmfRecordTypeSetPolyFillMode' put: 19;
		at: 'EmfRecordTypeSetROP2' put: 20;
		at: 'EmfRecordTypeSetStretchBltMode' put: 21;
		at: 'EmfRecordTypeSetTextAlign' put: 22;
		at: 'EmfRecordTypeSetTextColor' put: 24;
		at: 'EmfRecordTypeSetTextJustification' put: 120;
		at: 'EmfRecordTypeSetViewportExtEx' put: 11;
		at: 'EmfRecordTypeSetViewportOrgEx' put: 12;
		at: 'EmfRecordTypeSetWindowExtEx' put: 9;
		at: 'EmfRecordTypeSetWindowOrgEx' put: 10;
		at: 'EmfRecordTypeSetWorldTransform' put: 35;
		at: 'EmfRecordTypeSmallTextOut' put: 108;
		at: 'EmfRecordTypeStartDoc' put: 107;
		at: 'EmfRecordTypeStretchBlt' put: 77;
		at: 'EmfRecordTypeStretchDIBits' put: 81;
		at: 'EmfRecordTypeStrokeAndFillPath' put: 63;
		at: 'EmfRecordTypeStrokePath' put: 64;
		at: 'EmfRecordTypeTransparentBlt' put: 116;
		at: 'EmfRecordTypeWidenPath' put: 66;
		at: 'EmfToWmfBitsFlagsDefault' put: 0;
		at: 'EmfToWmfBitsFlagsEmbedEmf' put: 1;
		at: 'EmfToWmfBitsFlagsIncludePlaceable' put: 2;
		at: 'EmfToWmfBitsFlagsNoXORClip' put: 4;
		at: 'EmfTypeEmfOnly' put: 3;
		at: 'EmfTypeEmfPlusDual' put: 5;
		at: 'EmfTypeEmfPlusOnly' put: 4;
		at: 'EncoderChrominanceTable'
		put: '{F2E455DC-09B3-4316-8260-676ADA32481C}';
		at: 'EncoderColorDepth' put: '{66087055-AD66-4C7C-9A18-38A2310B8337}';
		at: 'EncoderCompression' put: '{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}';
		at: 'EncoderLuminanceTable' put: '{EDB33BCE-0266-4A77-B904-27216099E717}';
		at: 'EncoderParameterValueTypeASCII' put: 2;
		at: 'EncoderParameterValueTypeByte' put: 1;
		at: 'EncoderParameterValueTypeLong' put: 4;
		at: 'EncoderParameterValueTypeLongRange' put: 6;
		at: 'EncoderParameterValueTypeRational' put: 5;
		at: 'EncoderParameterValueTypeRationalRange' put: 8;
		at: 'EncoderParameterValueTypeShort' put: 3;
		at: 'EncoderParameterValueTypeUndefined' put: 7;
		at: 'EncoderQuality' put: '{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}';
		at: 'EncoderRenderMethod' put: '{6D42C53A-229A-4825-8BB7-5C99E2B9A8B8}';
		at: 'EncoderSaveFlag' put: '{292266FC-AC40-47BF-8CFC-A85B89A655DE}';
		at: 'EncoderScanMethod' put: '{3A4E2661-3109-4E56-8536-42C156E7DCFA}';
		at: 'EncoderTransformation' put: '{8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}';
		at: 'EncoderValueColorTypeCMYK' put: 0;
		at: 'EncoderValueColorTypeYCCK' put: 1;
		at: 'EncoderValueCompressionCCITT3' put: 3;
		at: 'EncoderValueCompressionCCITT4' put: 4;
		at: 'EncoderValueCompressionLZW' put: 2;
		at: 'EncoderValueCompressionNone' put: 6;
		at: 'EncoderValueCompressionRle' put: 5;
		at: 'EncoderValueFlush' put: 20;
		at: 'EncoderValueFrameDimensionPage' put: 23;
		at: 'EncoderValueFrameDimensionResolution' put: 22;
		at: 'EncoderValueFrameDimensionTime' put: 21;
		at: 'EncoderValueLastFrame' put: 19;
		at: 'EncoderValueMultiFrame' put: 18;
		at: 'EncoderValueRenderNonProgressive' put: 12;
		at: 'EncoderValueRenderProgressive' put: 11;
		at: 'EncoderValueScanMethodInterlaced' put: 7;
		at: 'EncoderValueScanMethodNonInterlaced' put: 8;
		at: 'EncoderValueTransformFlipHorizontal' put: 16;
		at: 'EncoderValueTransformFlipVertical' put: 17;
		at: 'EncoderValueTransformRotate180' put: 14;
		at: 'EncoderValueTransformRotate270' put: 15;
		at: 'EncoderValueTransformRotate90' put: 13;
		at: 'EncoderValueVersionGif87' put: 9;
		at: 'EncoderValueVersionGif89' put: 10;
		at: 'EncoderVersion' put: '{24D18C76-814A-41A4-BF53-1C219CCCF797}';
		at: 'FileNotFound' put: 10;
		at: 'FillModeAlternate' put: 0;
		at: 'FillModeWinding' put: 1;
		at: 'Firebrick' put: 4289864226;
		at: 'FloralWhite' put: 4294966000;
		at: 'FlushIntentionFlush' put: 0;
		at: 'FlushIntentionSync' put: 1;
		at: 'FontFamilyNotFound' put: 14;
		at: 'FontStyleBold' put: 1;
		at: 'FontStyleBoldItalic' put: 3;
		at: 'FontStyleItalic' put: 2;
		at: 'FontStyleNotFound' put: 15;
		at: 'FontStyleRegular' put: 0;
		at: 'FontStyleStrikeout' put: 8;
		at: 'FontStyleUnderline' put: 4;
		at: 'ForestGreen' put: 4280453922;
		at: 'FormatIDImageInformation'
		put: '{E5836CBE-5EEF-0F1D-ACDE-AE4C43B608CE}';
		at: 'FormatIDJpegAppHeaders'
		put: '{1C4AFDCD-6177-43CF-ABC7-5F51AF39EE85}';
		at: 'FrameDimensionPage' put: '{7462DC86-6180-4C7E-8E3F-EE7333A7A483}';
		at: 'FrameDimensionResolution'
		put: '{84236F7B-3BD3-428F-8DAB-4EA1439CA315}';
		at: 'FrameDimensionTime' put: '{6AEDBD6D-3FB5-418A-83A6-7F45229DC872}';
		at: 'Fuchsia' put: 4294902015;
		at: 'Gainsboro' put: 4292664540;
		at: 'GenericError' put: 1;
		at: 'GenericFontFamilyMonospace' put: 2;
		at: 'GenericFontFamilySansSerif' put: 1;
		at: 'GenericFontFamilySerif' put: 0;
		at: 'GhostWhite' put: 4294506751;
		at: 'Gold' put: 4294956800;
		at: 'Goldenrod' put: 4292519200;
		at: 'Gray' put: 4286611584;
		at: 'Green' put: 4278222848;
		at: 'GreenMask' put: 65280;
		at: 'GreenShift' put: 8;
		at: 'GreenYellow' put: 4289593135;
		at: 'HatchStyle05Percent' put: 6;
		at: 'HatchStyle10Percent' put: 7;
		at: 'HatchStyle20Percent' put: 8;
		at: 'HatchStyle25Percent' put: 9;
		at: 'HatchStyle30Percent' put: 10;
		at: 'HatchStyle40Percent' put: 11;
		at: 'HatchStyle50Percent' put: 12;
		at: 'HatchStyle60Percent' put: 13;
		at: 'HatchStyle70Percent' put: 14;
		at: 'HatchStyle75Percent' put: 15;
		at: 'HatchStyle80Percent' put: 16;
		at: 'HatchStyle90Percent' put: 17;
		at: 'HatchStyleBackwardDiagonal' put: 3;
		at: 'HatchStyleCross' put: 4;
		at: 'HatchStyleDarkDownwardDiagonal' put: 20;
		at: 'HatchStyleDarkHorizontal' put: 29;
		at: 'HatchStyleDarkUpwardDiagonal' put: 21;
		at: 'HatchStyleDarkVertical' put: 28;
		at: 'HatchStyleDashedDownwardDiagonal' put: 30;
		at: 'HatchStyleDashedHorizontal' put: 32;
		at: 'HatchStyleDashedUpwardDiagonal' put: 31;
		at: 'HatchStyleDashedVertical' put: 33;
		at: 'HatchStyleDiagonalBrick' put: 38;
		at: 'HatchStyleDiagonalCross' put: 5;
		at: 'HatchStyleDivot' put: 42;
		at: 'HatchStyleDottedDiamond' put: 44;
		at: 'HatchStyleDottedGrid' put: 43;
		at: 'HatchStyleForwardDiagonal' put: 2;
		at: 'HatchStyleHorizontal' put: 0;
		at: 'HatchStyleHorizontalBrick' put: 39;
		at: 'HatchStyleLargeCheckerBoard' put: 50;
		at: 'HatchStyleLargeConfetti' put: 35;
		at: 'HatchStyleLargeGrid' put: 4;
		at: 'HatchStyleLightDownwardDiagonal' put: 18;
		at: 'HatchStyleLightHorizontal' put: 25;
		at: 'HatchStyleLightUpwardDiagonal' put: 19;
		at: 'HatchStyleLightVertical' put: 24;
		at: 'HatchStyleMax' put: 52;
		at: 'HatchStyleMin' put: 0;
		at: 'HatchStyleNarrowHorizontal' put: 27;
		at: 'HatchStyleNarrowVertical' put: 26;
		at: 'HatchStyleOutlinedDiamond' put: 51;
		at: 'HatchStylePlaid' put: 41;
		at: 'HatchStyleShingle' put: 45;
		at: 'HatchStyleSmallCheckerBoard' put: 49;
		at: 'HatchStyleSmallConfetti' put: 34;
		at: 'HatchStyleSmallGrid' put: 48;
		at: 'HatchStyleSolidDiamond' put: 52;
		at: 'HatchStyleSphere' put: 47;
		at: 'HatchStyleTotal' put: 53;
		at: 'HatchStyleTrellis' put: 46;
		at: 'HatchStyleVertical' put: 1;
		at: 'HatchStyleWave' put: 37;
		at: 'HatchStyleWeave' put: 40;
		at: 'HatchStyleWideDownwardDiagonal' put: 22;
		at: 'HatchStyleWideUpwardDiagonal' put: 23;
		at: 'HatchStyleZigZag' put: 36;
		at: 'Honeydew' put: 4293984240;
		at: 'HotkeyPrefixHide' put: 2;
		at: 'HotkeyPrefixNone' put: 0;
		at: 'HotkeyPrefixShow' put: 1;
		at: 'HotPink' put: 4294928820;
		at: 'ImageCodecFlagsBlockingDecode' put: 32;
		at: 'ImageCodecFlagsBuiltin' put: 65536;
		at: 'ImageCodecFlagsDecoder' put: 2;
		at: 'ImageCodecFlagsEncoder' put: 1;
		at: 'ImageCodecFlagsSeekableEncode' put: 16;
		at: 'ImageCodecFlagsSupportBitmap' put: 4;
		at: 'ImageCodecFlagsSupportVector' put: 8;
		at: 'ImageCodecFlagsSystem' put: 131072;
		at: 'ImageCodecFlagsUser' put: 262144;
		at: 'ImageFlagsCaching' put: 131072;
		at: 'ImageFlagsColorSpaceCMYK' put: 32;
		at: 'ImageFlagsColorSpaceGRAY' put: 64;
		at: 'ImageFlagsColorSpaceRGB' put: 16;
		at: 'ImageFlagsColorSpaceYCBCR' put: 128;
		at: 'ImageFlagsColorSpaceYCCK' put: 256;
		at: 'ImageFlagsHasAlpha' put: 2;
		at: 'ImageFlagsHasRealDPI' put: 4096;
		at: 'ImageFlagsHasRealPixelSize' put: 8192;
		at: 'ImageFlagsHasTranslucent' put: 4;
		at: 'ImageFlagsNone' put: 0;
		at: 'ImageFlagsPartiallyScalable' put: 8;
		at: 'ImageFlagsReadOnly' put: 65536;
		at: 'ImageFlagsScalable' put: 1;
		at: 'ImageFormatBMP' put: '{B96B3CAB-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatEMF' put: '{B96B3CAC-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatEXIF' put: '{B96B3CB2-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatGIF' put: '{B96B3CB0-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatIcon' put: '{B96B3CB5-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatJPEG' put: '{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatMemoryBMP' put: '{B96B3CAA-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatPNG' put: '{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatTIFF' put: '{B96B3CB1-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatUndefined' put: '{B96B3CA9-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageFormatWMF' put: '{B96B3CAD-0728-11D3-9D7B-0000F81EF32E}';
		at: 'ImageLockModeRead' put: 1;
		at: 'ImageLockModeUserInputBuf' put: 4;
		at: 'ImageLockModeWrite' put: 2;
		at: 'ImageTypeBitmap' put: 1;
		at: 'ImageTypeMetafile' put: 2;
		at: 'ImageTypeUnknown' put: 0;
		at: 'IndianRed' put: 4291648604;
		at: 'Indigo' put: 4283105410;
		at: 'InsufficientBuffer' put: 5;
		at: 'InterpolationModeBicubic' put: 4;
		at: 'InterpolationModeBilinear' put: 3;
		at: 'InterpolationModeDefault' put: 0;
		at: 'InterpolationModeHighQuality' put: 2;
		at: 'InterpolationModeHighQualityBicubic' put: 7;
		at: 'InterpolationModeHighQualityBilinear' put: 6;
		at: 'InterpolationModeInvalid' put: 4294967295;
		at: 'InterpolationModeLowQuality' put: 1;
		at: 'InterpolationModeNearestNeighbor' put: 5;
		at: 'InvalidParameter' put: 2;
		at: 'IPictureGUID' put: '{7BF80980-BF32-101A-8BBB-00AA00300CAB}';
		at: 'Ivory' put: 4294967280;
		at: 'Khaki' put: 4293977740]

{ #category : #initialization }
GDIPlusObject class >> initializeGDIPlusConstants3 [
	GDIPlusConstants
		at: 'Lavender' put: 4293322490;
		at: 'LavenderBlush' put: 4294963445;
		at: 'LawnGreen' put: 4286381056;
		at: 'LemonChiffon' put: 4294965965;
		at: 'LightBlue' put: 4289583334;
		at: 'LightCoral' put: 4293951616;
		at: 'LightCyan' put: 4292935679;
		at: 'LightGoldenrodYellow' put: 4294638290;
		at: 'LightGray' put: 4292072403;
		at: 'LightGreen' put: 4287688336;
		at: 'LightPink' put: 4294948545;
		at: 'LightSalmon' put: 4294942842;
		at: 'LightSeaGreen' put: 4280332970;
		at: 'LightSkyBlue' put: 4287090426;
		at: 'LightSlateGray' put: 4286023833;
		at: 'LightSteelBlue' put: 4289774814;
		at: 'LightYellow' put: 4294967264;
		at: 'Lime' put: 4278255360;
		at: 'LimeGreen' put: 4281519410;
		at: 'LinearGradientModeBackwardDiagonal' put: 3;
		at: 'LinearGradientModeForwardDiagonal' put: 2;
		at: 'LinearGradientModeHorizontal' put: 0;
		at: 'LinearGradientModeVertical' put: 1;
		at: 'LineCapAnchorMask' put: 240;
		at: 'LineCapArrowAnchor' put: 20;
		at: 'LineCapCustom' put: 255;
		at: 'LineCapDiamondAnchor' put: 19;
		at: 'LineCapFlat' put: 0;
		at: 'LineCapNoAnchor' put: 16;
		at: 'LineCapRound' put: 2;
		at: 'LineCapRoundAnchor' put: 18;
		at: 'LineCapSquare' put: 1;
		at: 'LineCapSquareAnchor' put: 17;
		at: 'LineCapTriangle' put: 3;
		at: 'LineJoinBevel' put: 1;
		at: 'LineJoinMiter' put: 0;
		at: 'LineJoinMiterClipped' put: 3;
		at: 'LineJoinRound' put: 2;
		at: 'Linen' put: 4294635750;
		at: 'LusNotInitialized' put: 18;
		at: 'Magenta' put: 4294902015;
		at: 'Maroon' put: 4286578688;
		at: 'MatrixOrderAppend' put: 1;
		at: 'MatrixOrderPrepend' put: 0;
		at: 'MediumAquamarine' put: 4284927402;
		at: 'MediumBlue' put: 4278190285;
		at: 'MediumOrchid' put: 4290401747;
		at: 'MediumPurple' put: 4287852763;
		at: 'MediumSeaGreen' put: 4282168177;
		at: 'MediumSlateBlue' put: 4286277870;
		at: 'MediumSpringGreen' put: 4278254234;
		at: 'MediumTurquoise' put: 4282962380;
		at: 'MediumVioletRed' put: 4291237253;
		at: 'MetafileFrameUnitDocument' put: 5;
		at: 'MetafileFrameUnitGdi' put: 7;
		at: 'MetafileFrameUnitInch' put: 4;
		at: 'MetafileFrameUnitMillimeter' put: 6;
		at: 'MetafileFrameUnitPixel' put: 2;
		at: 'MetafileFrameUnitPoint' put: 3;
		at: 'MetafileTypeEmf' put: 3;
		at: 'MetafileTypeEmfPlusDual' put: 5;
		at: 'MetafileTypeEmfPlusOnly' put: 4;
		at: 'MetafileTypeInvalid' put: 0;
		at: 'MetafileTypeWmf' put: 1;
		at: 'MetafileTypeWmfPlaceable' put: 2;
		at: 'MidnightBlue' put: 4279834992;
		at: 'MintCream' put: 4294311930;
		at: 'MistyRose' put: 4294960353;
		at: 'Moccasin' put: 4294960309;
		at: 'NavajoWhite' put: 4294958765;
		at: 'Navy' put: 4278190208;
		at: 'NotImplemented' put: 6;
		at: 'NotTrueTypeFont' put: 16;
		at: 'ObjectBusy' put: 4;
		at: 'ObjectTypeBrush' put: 1;
		at: 'ObjectTypeCustomLineCap' put: 9;
		at: 'ObjectTypeFont' put: 6;
		at: 'ObjectTypeImage' put: 5;
		at: 'ObjectTypeImageAttributes' put: 8;
		at: 'ObjectTypeInvalid' put: 0;
		at: 'ObjectTypeMax' put: 9;
		at: 'ObjectTypeMin' put: 1;
		at: 'ObjectTypePath' put: 3;
		at: 'ObjectTypePen' put: 2;
		at: 'ObjectTypeRegion' put: 4;
		at: 'ObjectTypeStringFormat' put: 7;
		at: 'Ok' put: 0;
		at: 'OldLace' put: 4294833638;
		at: 'Olive' put: 4286611456;
		at: 'OliveDrab' put: 4285238819;
		at: 'Orange' put: 4294944000;
		at: 'OrangeRed' put: 4294919424;
		at: 'Orchid' put: 4292505814;
		at: 'OutOfMemory' put: 3;
		at: 'PaleGoldenrod' put: 4293847210;
		at: 'PaleGreen' put: 4288215960;
		at: 'PaletteFlagsGrayScale' put: 2;
		at: 'PaletteFlagsHalftone' put: 4;
		at: 'PaletteFlagsHasAlpha' put: 1;
		at: 'PaleTurquoise' put: 4289720046;
		at: 'PaleVioletRed' put: 4292571283;
		at: 'PapayaWhip' put: 4294963157;
		at: 'PathPointTypeBezier' put: 3;
		at: 'PathPointTypeBezier3' put: 3;
		at: 'PathPointTypeCloseSubpath' put: 128;
		at: 'PathPointTypeDashMode' put: 16;
		at: 'PathPointTypeLine' put: 1;
		at: 'PathPointTypePathMarker' put: 32;
		at: 'PathPointTypePathTypeMask' put: 7;
		at: 'PathPointTypeStart' put: 0;
		at: 'PeachPuff' put: 4294957753;
		at: 'PenAlignmentCenter' put: 0;
		at: 'PenAlignmentInset' put: 1;
		at: 'PenTypeHatchFill' put: 1;
		at: 'PenTypeLinearGradient' put: 4;
		at: 'PenTypePathGradient' put: 3;
		at: 'PenTypeSolidColor' put: 0;
		at: 'PenTypeTextureFill' put: 2;
		at: 'PenTypeUnknown' put: 4294967295;
		at: 'Peru' put: 4291659071;
		at: 'Pink' put: 4294951115;
		at: 'PixelFormat16bppARGB1555' put: 397319;
		at: 'PixelFormat16bppGrayScale' put: 1052676;
		at: 'PixelFormat16bppRGB555' put: 135173;
		at: 'PixelFormat16bppRGB565' put: 135174;
		at: 'PixelFormat1bppIndexed' put: 196865;
		at: 'PixelFormat24bppRGB' put: 137224;
		at: 'PixelFormat32bppARGB' put: 2498570;
		at: 'PixelFormat32bppPARGB' put: 925707;
		at: 'PixelFormat32bppRGB' put: 139273;
		at: 'PixelFormat48bppRGB' put: 1060876;
		at: 'PixelFormat4bppIndexed' put: 197634;
		at: 'PixelFormat64bppARGB' put: 3424269;
		at: 'PixelFormat64bppPARGB' put: 29622286;
		at: 'PixelFormat8bppIndexed' put: 198659;
		at: 'PixelFormatAlpha' put: 262144;
		at: 'PixelFormatCanonical' put: 2097152;
		at: 'PixelFormatDontCare' put: 0;
		at: 'PixelFormatExtended' put: 1048576;
		at: 'PixelFormatGDI' put: 131072;
		at: 'PixelFormatIndexed' put: 65536;
		at: 'PixelFormatMax' put: 15;
		at: 'PixelFormatPAlpha' put: 524288;
		at: 'PixelFormatUndefined' put: 0;
		at: 'PixelOffsetModeDefault' put: 0;
		at: 'PixelOffsetModeHalf' put: 4;
		at: 'PixelOffsetModeHighQuality' put: 2;
		at: 'PixelOffsetModeHighSpeed' put: 1;
		at: 'PixelOffsetModeInvalid' put: 4294967295;
		at: 'PixelOffsetModeNone' put: 3]

{ #category : #initialization }
GDIPlusObject class >> initializeGDIPlusConstants4 [
	GDIPlusConstants
		at: 'Plum' put: 4292714717;
		at: 'PowderBlue' put: 4289781990;
		at: 'PropertyNotFound' put: 19;
		at: 'PropertyNotSupported' put: 20;
		at: 'PropertyTagArtist' put: 315;
		at: 'PropertyTagBitsPerSample' put: 258;
		at: 'PropertyTagCellHeight' put: 265;
		at: 'PropertyTagCellWidth' put: 264;
		at: 'PropertyTagChrominanceTable' put: 20625;
		at: 'PropertyTagColorMap' put: 320;
		at: 'PropertyTagColorTransferFunction' put: 20506;
		at: 'PropertyTagCompression' put: 259;
		at: 'PropertyTagCopyright' put: 33432;
		at: 'PropertyTagDateTime' put: 306;
		at: 'PropertyTagDocumentName' put: 269;
		at: 'PropertyTagDotRange' put: 336;
		at: 'PropertyTagEquipMake' put: 271;
		at: 'PropertyTagEquipModel' put: 272;
		at: 'PropertyTagExifAperture' put: 37378;
		at: 'PropertyTagExifBrightness' put: 37379;
		at: 'PropertyTagExifCfaPattern' put: 41730;
		at: 'PropertyTagExifColorSpace' put: 40961;
		at: 'PropertyTagExifCompBPP' put: 37122;
		at: 'PropertyTagExifCompConfig' put: 37121;
		at: 'PropertyTagExifDTDigitized' put: 36868;
		at: 'PropertyTagExifDTDigSS' put: 37522;
		at: 'PropertyTagExifDTOrig' put: 36867;
		at: 'PropertyTagExifDTOrigSS' put: 37521;
		at: 'PropertyTagExifDTSubsec' put: 37520;
		at: 'PropertyTagExifExposureBias' put: 37380;
		at: 'PropertyTagExifExposureIndex' put: 41493;
		at: 'PropertyTagExifExposureProg' put: 34850;
		at: 'PropertyTagExifExposureTime' put: 33434;
		at: 'PropertyTagExifFileSource' put: 41728;
		at: 'PropertyTagExifFlash' put: 37385;
		at: 'PropertyTagExifFlashEnergy' put: 41483;
		at: 'PropertyTagExifFNumber' put: 33437;
		at: 'PropertyTagExifFocalLength' put: 37386;
		at: 'PropertyTagExifFocalResUnit' put: 41488;
		at: 'PropertyTagExifFocalXRes' put: 41486;
		at: 'PropertyTagExifFocalYRes' put: 41487;
		at: 'PropertyTagExifFPXVer' put: 40960;
		at: 'PropertyTagExifIFD' put: 34665;
		at: 'PropertyTagExifInterop' put: 40965;
		at: 'PropertyTagExifISOSpeed' put: 34855;
		at: 'PropertyTagExifLightSource' put: 37384;
		at: 'PropertyTagExifMakerNote' put: 37500;
		at: 'PropertyTagExifMaxAperture' put: 37381;
		at: 'PropertyTagExifMeteringMode' put: 37383;
		at: 'PropertyTagExifOECF' put: 34856;
		at: 'PropertyTagExifPixXDim' put: 40962;
		at: 'PropertyTagExifPixYDim' put: 40963;
		at: 'PropertyTagExifRelatedWav' put: 40964;
		at: 'PropertyTagExifSceneType' put: 41729;
		at: 'PropertyTagExifSensingMethod' put: 41495;
		at: 'PropertyTagExifShutterSpeed' put: 37377;
		at: 'PropertyTagExifSpatialFR' put: 41484;
		at: 'PropertyTagExifSpectralSense' put: 34852;
		at: 'PropertyTagExifSubjectDist' put: 37382;
		at: 'PropertyTagExifSubjectLoc' put: 41492;
		at: 'PropertyTagExifUserComment' put: 37510;
		at: 'PropertyTagExifVer' put: 36864;
		at: 'PropertyTagExtraSamples' put: 338;
		at: 'PropertyTagFillOrder' put: 266;
		at: 'PropertyTagFrameDelay' put: 20736;
		at: 'PropertyTagFreeByteCounts' put: 289;
		at: 'PropertyTagFreeOffset' put: 288;
		at: 'PropertyTagGamma' put: 769;
		at: 'PropertyTagGpsAltitude' put: 6;
		at: 'PropertyTagGpsAltitudeRef' put: 5;
		at: 'PropertyTagGpsDestBear' put: 24;
		at: 'PropertyTagGpsDestBearRef' put: 23;
		at: 'PropertyTagGpsDestDist' put: 26;
		at: 'PropertyTagGpsDestDistRef' put: 25;
		at: 'PropertyTagGpsDestLat' put: 20;
		at: 'PropertyTagGpsDestLatRef' put: 19;
		at: 'PropertyTagGpsDestLong' put: 22;
		at: 'PropertyTagGpsDestLongRef' put: 21;
		at: 'PropertyTagGpsGpsDop' put: 11;
		at: 'PropertyTagGpsGpsMeasureMode' put: 10;
		at: 'PropertyTagGpsGpsSatellites' put: 8;
		at: 'PropertyTagGpsGpsStatus' put: 9;
		at: 'PropertyTagGpsGpsTime' put: 7;
		at: 'PropertyTagGpsImgDir' put: 17;
		at: 'PropertyTagGpsImgDirRef' put: 16;
		at: 'PropertyTagGpsLatitude' put: 2;
		at: 'PropertyTagGpsLatitudeRef' put: 1;
		at: 'PropertyTagGpsLongitude' put: 4;
		at: 'PropertyTagGpsLongitudeRef' put: 3;
		at: 'PropertyTagGpsMapDatum' put: 18;
		at: 'PropertyTagGpsSpeed' put: 13;
		at: 'PropertyTagGpsSpeedRef' put: 12;
		at: 'PropertyTagGpsTrack' put: 15;
		at: 'PropertyTagGpsTrackRef' put: 14;
		at: 'PropertyTagGpsVer' put: 0;
		at: 'PropertyTagGrayResponseCurve' put: 291;
		at: 'PropertyTagGrayResponseUnit' put: 290;
		at: 'PropertyTagGridSize' put: 20497;
		at: 'PropertyTagHalftoneDegree' put: 20492;
		at: 'PropertyTagHalftoneHints' put: 321;
		at: 'PropertyTagHalftoneLPI' put: 20490;
		at: 'PropertyTagHalftoneLPIUnit' put: 20491;
		at: 'PropertyTagHalftoneMisc' put: 20494;
		at: 'PropertyTagHalftoneScreen' put: 20495;
		at: 'PropertyTagHalftoneShape' put: 20493;
		at: 'PropertyTagHostComputer' put: 316;
		at: 'PropertyTagICCProfile' put: 34675;
		at: 'PropertyTagICCProfileDescriptor' put: 770;
		at: 'PropertyTagImageDescription' put: 270;
		at: 'PropertyTagImageHeight' put: 257;
		at: 'PropertyTagImageTitle' put: 800;
		at: 'PropertyTagImageWidth' put: 256;
		at: 'PropertyTagInkNames' put: 333;
		at: 'PropertyTagInkSet' put: 332;
		at: 'PropertyTagJPEGACTables' put: 521;
		at: 'PropertyTagJPEGDCTables' put: 520;
		at: 'PropertyTagJPEGInterFormat' put: 513;
		at: 'PropertyTagJPEGInterLength' put: 514;
		at: 'PropertyTagJPEGLosslessPredictors' put: 517;
		at: 'PropertyTagJPEGQTables' put: 519;
		at: 'PropertyTagJPEGQuality' put: 20496;
		at: 'PropertyTagJPEGRestartInterval' put: 515;
		at: 'PropertyTagJPEointTransforms' put: 518;
		at: 'PropertyTagJPEroc' put: 512;
		at: 'PropertyTagLoopCount' put: 20737;
		at: 'PropertyTagLuminanceTable' put: 20624;
		at: 'PropertyTagMaxSampleValue' put: 281;
		at: 'PropertyTagMinSampleValue' put: 280;
		at: 'PropertyTagNewSubfileType' put: 254;
		at: 'PropertyTagNumberOfInks' put: 334;
		at: 'PropertyTagOrientation' put: 274;
		at: 'PropertyTagPageName' put: 285;
		at: 'PropertyTagPageNumber' put: 297;
		at: 'PropertyTagPaletteHistogram' put: 20755;
		at: 'PropertyTagPhotometricInterp' put: 262;
		at: 'PropertyTagPixelPerUnitX' put: 20753;
		at: 'PropertyTagPixelPerUnitY' put: 20754;
		at: 'PropertyTagPixelUnit' put: 20752;
		at: 'PropertyTagPlanarConfig' put: 284;
		at: 'PropertyTagPredictor' put: 317;
		at: 'PropertyTagPrimaryChromaticities' put: 319;
		at: 'PropertyTagPrintFlags' put: 20485;
		at: 'PropertyTagPrintFlagsBleedWidth' put: 20488;
		at: 'PropertyTagPrintFlagsBleedWidthScale' put: 20489;
		at: 'PropertyTagPrintFlagsCrop' put: 20487;
		at: 'PropertyTagPrintFlagsVersion' put: 20486;
		at: 'PropertyTagREFBlackWhite' put: 532;
		at: 'PropertyTagResolutionUnit' put: 296;
		at: 'PropertyTagResolutionXLengthUnit' put: 20483;
		at: 'PropertyTagResolutionXUnit' put: 20481;
		at: 'PropertyTagResolutionYLengthUnit' put: 20484;
		at: 'PropertyTagResolutionYUnit' put: 20482;
		at: 'PropertyTagRowsPerStrip' put: 278;
		at: 'PropertyTagSampleFormat' put: 339;
		at: 'PropertyTagSamplesPerPixel' put: 277;
		at: 'PropertyTagsIFD' put: 34853;
		at: 'PropertyTagSMaxSampleValue' put: 341;
		at: 'PropertyTagSMinSampleValue' put: 340;
		at: 'PropertyTagSoftwareUsed' put: 305;
		at: 'PropertyTagSRGBRenderingIntent' put: 771;
		at: 'PropertyTagStripBytesCount' put: 279;
		at: 'PropertyTagStripOffsets' put: 273;
		at: 'PropertyTagSubfileType' put: 255;
		at: 'PropertyTagT4Option' put: 292;
		at: 'PropertyTagT6Option' put: 293;
		at: 'PropertyTagTargetPrinter' put: 337;
		at: 'PropertyTagThreshHolding' put: 263;
		at: 'PropertyTagThumbnailArtist' put: 20532;
		at: 'PropertyTagThumbnailBitsPerSample' put: 20514;
		at: 'PropertyTagThumbnailColorDepth' put: 20501;
		at: 'PropertyTagThumbnailCompressedSize' put: 20505;
		at: 'PropertyTagThumbnailCompression' put: 20515;
		at: 'PropertyTagThumbnailCopyRight' put: 20539;
		at: 'PropertyTagThumbnailData' put: 20507;
		at: 'PropertyTagThumbnailDateTime' put: 20531;
		at: 'PropertyTagThumbnailEquipMake' put: 20518;
		at: 'PropertyTagThumbnailEquipModel' put: 20519;
		at: 'PropertyTagThumbnailFormat' put: 20498;
		at: 'PropertyTagThumbnailHeight' put: 20500;
		at: 'PropertyTagThumbnailImageDescription' put: 20517;
		at: 'PropertyTagThumbnailImageHeight' put: 20513;
		at: 'PropertyTagThumbnailImageWidth' put: 20512;
		at: 'PropertyTagThumbnailOrientation' put: 20521;
		at: 'PropertyTagThumbnailPhotometricInterp' put: 20516;
		at: 'PropertyTagThumbnailPlanarConfig' put: 20527;
		at: 'PropertyTagThumbnailPlanes' put: 20502;
		at: 'PropertyTagThumbnailPrimaryChromaticities' put: 20534;
		at: 'PropertyTagThumbnailRawBytes' put: 20503;
		at: 'PropertyTagThumbnailRefBlackWhite' put: 20538;
		at: 'PropertyTagThumbnailResolutionUnit' put: 20528;
		at: 'PropertyTagThumbnailResolutionX' put: 20525;
		at: 'PropertyTagThumbnailResolutionY' put: 20526;
		at: 'PropertyTagThumbnailRowsPerStrip' put: 20523;
		at: 'PropertyTagThumbnailSamplesPerPixel' put: 20522;
		at: 'PropertyTagThumbnailSize' put: 20504;
		at: 'PropertyTagThumbnailSoftwareUsed' put: 20530;
		at: 'PropertyTagThumbnailStripBytesCount' put: 20524;
		at: 'PropertyTagThumbnailStripOffsets' put: 20520;
		at: 'PropertyTagThumbnailTransferFunction' put: 20529;
		at: 'PropertyTagThumbnailWhitePoint' put: 20533;
		at: 'PropertyTagThumbnailWidth' put: 20499;
		at: 'PropertyTagThumbnailYCbCrCoefficients' put: 20535;
		at: 'PropertyTagThumbnailYCbCrPositioning' put: 20537;
		at: 'PropertyTagThumbnailYCbCrSubsampling' put: 20536;
		at: 'PropertyTagTileByteCounts' put: 325;
		at: 'PropertyTagTileLength' put: 323;
		at: 'PropertyTagTileOffset' put: 324;
		at: 'PropertyTagTileWidth' put: 322;
		at: 'PropertyTagTransferFuncition' put: 301;
		at: 'PropertyTagTransferRange' put: 342;
		at: 'PropertyTagTypeASCII' put: 2;
		at: 'PropertyTagTypeByte' put: 1;
		at: 'PropertyTagTypeLong' put: 4;
		at: 'PropertyTagTypeRational' put: 5;
		at: 'PropertyTagTypeShort' put: 3;
		at: 'PropertyTagTypeSLONG' put: 9;
		at: 'PropertyTagTypeSRational' put: 10;
		at: 'PropertyTagTypeUndefined' put: 7;
		at: 'PropertyTagWhitePoint' put: 318;
		at: 'PropertyTagXPosition' put: 286;
		at: 'PropertyTagXResolution' put: 282;
		at: 'PropertyTagYCbCrCoefficients' put: 529;
		at: 'PropertyTagYCbCrPositioning' put: 531;
		at: 'PropertyTagYCbCrSubsampling' put: 530;
		at: 'PropertyTagYPosition' put: 287;
		at: 'PropertyTagYResolution' put: 283;
		at: 'Purple' put: 4286578816;
		at: 'QualityModeDefault' put: 0;
		at: 'QualityModeHigh' put: 2;
		at: 'QualityModeInvalid' put: 4294967295;
		at: 'QualityModeLow' put: 1;
		at: 'Red' put: 4294901760;
		at: 'RedMask' put: 16711680;
		at: 'RedShift' put: 16;
		at: 'RosyBrown' put: 4290547599;
		at: 'Rotate180FlipNone' put: 2;
		at: 'Rotate180FlipX' put: 6;
		at: 'Rotate180FlipXY' put: 0;
		at: 'Rotate180FlipY' put: 4;
		at: 'Rotate270FlipNone' put: 3;
		at: 'Rotate270FlipX' put: 7;
		at: 'Rotate270FlipXY' put: 1;
		at: 'Rotate270FlipY' put: 5;
		at: 'Rotate90FlipNone' put: 1;
		at: 'Rotate90FlipX' put: 5;
		at: 'Rotate90FlipXY' put: 3;
		at: 'Rotate90FlipY' put: 7;
		at: 'RotateNoneFlipNone' put: 0;
		at: 'RotateNoneFlipX' put: 4;
		at: 'RotateNoneFlipXY' put: 2;
		at: 'RotateNoneFlipY' put: 6;
		at: 'RoyalBlue' put: 4282477025;
		at: 'SaddleBrown' put: 4287317267;
		at: 'Salmon' put: 4294606962;
		at: 'SandyBrown' put: 4294222944;
		at: 'SeaGreen' put: 4281240407;
		at: 'SeaShell' put: 4294964718;
		at: 'Sienna' put: 4288696877;
		at: 'Silver' put: 4290822336;
		at: 'SkyBlue' put: 4287090411;
		at: 'SlateBlue' put: 4285160141;
		at: 'SlateGray' put: 4285563024;
		at: 'SmoothingModeAntiAlias' put: 4;
		at: 'SmoothingModeDefault' put: 0;
		at: 'SmoothingModeHighQuality' put: 2;
		at: 'SmoothingModeHighSpeed' put: 1;
		at: 'SmoothingModeInvalid' put: 4294967295;
		at: 'SmoothingModeNone' put: 3;
		at: 'Snow' put: 4294966010;
		at: 'SpringGreen' put: 4278255487;
		at: 'SteelBlue' put: 4282811060;
		at: 'StringAlignmentCenter' put: 1;
		at: 'StringAlignmentFar' put: 2;
		at: 'StringAlignmentNear' put: 0;
		at: 'StringDigitSubstituteNational' put: 2;
		at: 'StringDigitSubstituteNone' put: 1;
		at: 'StringDigitSubstituteTraditional' put: 3;
		at: 'StringDigitSubstituteUser' put: 0;
		at: 'StringFormatFlagsDirectionRightToLeft' put: 1;
		at: 'StringFormatFlagsDirectionVertical' put: 2;
		at: 'StringFormatFlagsDisplayFormatControl' put: 32;
		at: 'StringFormatFlagsLineLimit' put: 8192;
		at: 'StringFormatFlagsMeasureTrailingSpaces' put: 2048;
		at: 'StringFormatFlagsNoClip' put: 16384;
		at: 'StringFormatFlagsNoFitBlackBox' put: 4;
		at: 'StringFormatFlagsNoFontFallback' put: 1024;
		at: 'StringFormatFlagsNoWrap' put: 4096;
		at: 'StringTrimmingCharacter' put: 1;
		at: 'StringTrimmingEllipsisCharacter' put: 3;
		at: 'StringTrimmingEllipsisPath' put: 5;
		at: 'StringTrimmingEllipsisWord' put: 4;
		at: 'StringTrimmingNone' put: 0;
		at: 'StringTrimmingWord' put: 2;
		at: 'Tan' put: 4291998860;
		at: 'Teal' put: 4278222976;
		at: 'TextRenderingHintAntiAlias' put: 4;
		at: 'TextRenderingHintAntiAliasGridFit' put: 3;
		at: 'TextRenderingHintClearTypeGridFit' put: 5;
		at: 'TextRenderingHintSingleBitPerPixel' put: 2;
		at: 'TextRenderingHintSingleBitPerPixelGridFit' put: 1;
		at: 'TextRenderingHintSystemDefault' put: 0;
		at: 'Thistle' put: 4292394968;
		at: 'Tomato' put: 4294927175;
		at: 'Transparent' put: 16777215;
		at: 'Turquoise' put: 4282441936;
		at: 'UnitDisplay' put: 1;
		at: 'UnitDocument' put: 5;
		at: 'UnitInch' put: 4;
		at: 'UnitMillimeter' put: 6;
		at: 'UnitPixel' put: 2;
		at: 'UnitPoint' put: 3;
		at: 'UnitWorld' put: 0;
		at: 'UnknownImageFormat' put: 13;
		at: 'UnsupportedlusVersion' put: 17;
		at: 'ValueOverflow' put: 11;
		at: 'Violet' put: 4293821166;
		at: 'WarpModeBilinear' put: 1;
		at: 'WarpModePerspective' put: 0;
		at: 'Wheat' put: 4294303411;
		at: 'White' put: 4294967295;
		at: 'WhiteSmoke' put: 4294309365;
		at: 'Win32Error' put: 7;
		at: 'WmfRecordTypeAbortDoc' put: 65618;
		at: 'WmfRecordTypeAnimatePalette' put: 66614;
		at: 'WmfRecordTypeArc' put: 67607;
		at: 'WmfRecordTypeBitBlt' put: 67874;
		at: 'WmfRecordTypeChord' put: 67632;
		at: 'WmfRecordTypeCreateBitmap' put: 67326;
		at: 'WmfRecordTypeCreateBitmapIndirect' put: 66301;
		at: 'WmfRecordTypeCreateBrush' put: 65784;
		at: 'WmfRecordTypeCreateBrushIndirect' put: 66300;
		at: 'WmfRecordTypeCreateFontIndirect' put: 66299;
		at: 'WmfRecordTypeCreatePalette' put: 65783;
		at: 'WmfRecordTypeCreatePatternBrush' put: 66041;
		at: 'WmfRecordTypeCreatePenIndirect' put: 66298;
		at: 'WmfRecordTypeCreateRegion' put: 67327;
		at: 'WmfRecordTypeDeleteObject' put: 66032;
		at: 'WmfRecordTypeDIBBitBlt' put: 67904;
		at: 'WmfRecordTypeDIBCreatePatternBrush' put: 65858;
		at: 'WmfRecordTypeDIBStretchBlt' put: 68417;
		at: 'WmfRecordTypeDrawText' put: 67119;
		at: 'WmfRecordTypeEllipse' put: 66584;
		at: 'WmfRecordTypeEndDoc' put: 65630;
		at: 'WmfRecordTypeEndPage' put: 65616;
		at: 'WmfRecordTypeEscape' put: 67110;
		at: 'WmfRecordTypeExcludeClipRect' put: 66581;
		at: 'WmfRecordTypeExtFloodFill' put: 66888;
		at: 'WmfRecordTypeExtTextOut' put: 68146;
		at: 'WmfRecordTypeFillRegion' put: 66088;
		at: 'WmfRecordTypeFloodFill' put: 66585;
		at: 'WmfRecordTypeFrameRegion' put: 66601;
		at: 'WmfRecordTypeIntersectClipRect' put: 66582;
		at: 'WmfRecordTypeInvertRegion' put: 65834;
		at: 'WmfRecordTypeLineTo' put: 66067;
		at: 'WmfRecordTypeMoveTo' put: 66068;
		at: 'WmfRecordTypeOffsetClipRgn' put: 66080;
		at: 'WmfRecordTypeOffsetViewportOrg' put: 66065;
		at: 'WmfRecordTypeOffsetWindowOrg' put: 66063;
		at: 'WmfRecordTypePaintRegion' put: 65835;
		at: 'WmfRecordTypePatBlt' put: 67101;
		at: 'WmfRecordTypePie' put: 67610;
		at: 'WmfRecordTypePolygon' put: 66340;
		at: 'WmfRecordTypePolyline' put: 66341;
		at: 'WmfRecordTypePolyPolygon' put: 66872;
		at: 'WmfRecordTypeRealizePalette' put: 65589;
		at: 'WmfRecordTypeRectangle' put: 66587;
		at: 'WmfRecordTypeResetDC' put: 65868;
		at: 'WmfRecordTypeResizePalette' put: 65849;
		at: 'WmfRecordTypeRestoreDC' put: 65831;
		at: 'WmfRecordTypeRoundRect' put: 67100;
		at: 'WmfRecordTypeSaveDC' put: 65566;
		at: 'WmfRecordTypeScaleViewportExt' put: 66578;
		at: 'WmfRecordTypeScaleWindowExt' put: 66576;
		at: 'WmfRecordTypeSelectClipRegion' put: 65836;
		at: 'WmfRecordTypeSelectObject' put: 65837;
		at: 'WmfRecordTypeSelectPalette' put: 66100;
		at: 'WmfRecordTypeSetBkColor' put: 66049;
		at: 'WmfRecordTypeSetBkMode' put: 65794;
		at: 'WmfRecordTypeSetDIBToDev' put: 68915;
		at: 'WmfRecordTypeSetLayout' put: 65865;
		at: 'WmfRecordTypeSetMapMode' put: 65795;
		at: 'WmfRecordTypeSetMapperFlags' put: 66097;
		at: 'WmfRecordTypeSetPalEntries' put: 65591;
		at: 'WmfRecordTypeSetPixel' put: 66591;
		at: 'WmfRecordTypeSetPolyFillMode' put: 65798;
		at: 'WmfRecordTypeSetRelAbs' put: 65797;
		at: 'WmfRecordTypeSetROP2' put: 65796;
		at: 'WmfRecordTypeSetStretchBltMode' put: 65799;
		at: 'WmfRecordTypeSetTextAlign' put: 65838;
		at: 'WmfRecordTypeSetTextCharExtra' put: 65800;
		at: 'WmfRecordTypeSetTextColor' put: 66057;
		at: 'WmfRecordTypeSetTextJustification' put: 66058;
		at: 'WmfRecordTypeSetViewportExt' put: 66062;
		at: 'WmfRecordTypeSetViewportOrg' put: 66061;
		at: 'WmfRecordTypeSetWindowExt' put: 66060;
		at: 'WmfRecordTypeSetWindowOrg' put: 66059;
		at: 'WmfRecordTypeStartDoc' put: 65869;
		at: 'WmfRecordTypeStartPage' put: 65615;
		at: 'WmfRecordTypeStretchBlt' put: 68387;
		at: 'WmfRecordTypeStretchDIB' put: 69443;
		at: 'WmfRecordTypeTextOut' put: 66849;
		at: 'WrapModeClamp' put: 4;
		at: 'WrapModeTile' put: 0;
		at: 'WrapModeTileFlipX' put: 1;
		at: 'WrapModeTileFlipXY' put: 3;
		at: 'WrapModeTileFlipy' put: 2;
		at: 'WrongState' put: 8;
		at: 'Yellow' put: 4294967040;
		at: 'YellowGreen' put: 4288335154]

{ #category : #converting }
GDIPlusObject >> asParameter [
	^handle asParameter]

{ #category : #private }
GDIPlusObject >> basicRelease [
	self subclassResponsibility]

{ #category : #private }
GDIPlusObject >> checkStatus [
	self class checkStatus: status]

{ #category : #private }
GDIPlusObject >> checkStatus: gpStatus [
	status := gpStatus.
	self checkStatus]

{ #category : #copying }
GDIPlusObject >> clone [
	self subclassResponsibility]

{ #category : #private }
GDIPlusObject >> dll [
	^self class dll]

{ #category : #private }
GDIPlusObject >> finalize [
	self release]

{ #category : #accessing }
GDIPlusObject >> handle [
	^handle]

{ #category : #accessing }
GDIPlusObject >> handle: anInteger [
	handle ~= anInteger ifTrue: [self release].
	handle := anInteger.
	(handle isNil or: [handle = 0]) ifFalse: [self requireFinalization]]

{ #category : #testing }
GDIPlusObject >> isCachedBitmap [
	^false]

{ #category : #testing }
GDIPlusObject >> isValid [
	^handle notNil andNot: [handle = 0]]

{ #category : #accessing }
GDIPlusObject >> lastStatus [
	^status]

{ #category : #private }
GDIPlusObject >> release [
	super release.
	(handle isNil or: [handle = 0]) ifFalse: [self basicRelease].
	self ignoreFinalization.
	handle := nil]

