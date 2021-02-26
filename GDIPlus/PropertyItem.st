"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PropertyItem,
	#superclass : #GdiPlusStructure,
	#instVars : [
		'values'
	],
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #inspecting }
PropertyItem class >> aspects [
	^super aspects , #(#values)]

{ #category : #private }
PropertyItem class >> def [
	^<def>
	typedef struct PropertyItem {
		PROPID id;
		ULONG length;
		WORD type;
		VOID *value;
	} PropertyItem;
	</def>]

{ #category : #private }
PropertyItem class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 24;
		at: 'id' put: 0;
		at: 'length' put: 4;
		at: 'type' put: 8;
		at: 'value' put: 16;
		yourself]

{ #category : #accessing }
PropertyItem class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
PropertyItem class >> typedefTable [
	^GDIPlusDLL typedefTable]

{ #category : #output }
PropertyItem >> bytes [
	| memory |
	memory := self value.
	^memory isValid ifTrue: [ByteArray fromMemory: memory length: self length]]

{ #category : #input }
PropertyItem >> bytes: aByteArray [
	self
		type: PropertyTagTypeByte;
		value: aByteArray externalCopy;
		length: aByteArray size]

{ #category : #output }
PropertyItem >> chars [
	| memory |
	memory := self value.
	^memory isValid ifTrue: [String fromMemory: memory length: self length]]

{ #category : #input }
PropertyItem >> chars: aString [
	self
		type: PropertyTagTypeASCII;
		value: aString externalCopy;
		length: aString size]

{ #category : #accessing }
PropertyItem >> id [
	^self uLongAtOffset: id]

{ #category : #accessing }
PropertyItem >> id: anInteger [
	self uLongAtOffset: id put: anInteger]

{ #category : #output }
PropertyItem >> idDescription [
	| idx |
	self type = PropertyTagArtist ifTrue: [^'PropertyTagArtist'].
	idx := self id.
	idx = PropertyTagBitsPerSample ifTrue: [^'PropertyTagBitsPerSample'].
	idx = PropertyTagCellHeight ifTrue: [^'PropertyTagCellHeight'].
	idx = PropertyTagCellWidth ifTrue: [^'PropertyTagCellWidth'].
	idx = PropertyTagChrominanceTable ifTrue: [^'PropertyTagChrominanceTable'].
	idx = PropertyTagColorMap ifTrue: [^'PropertyTagColorMap'].
	idx = PropertyTagColorTransferFunction
		ifTrue: [^'PropertyTagColorTransferFunction'].
	idx = PropertyTagCompression ifTrue: [^'PropertyTagCompression'].
	idx = PropertyTagCopyright ifTrue: [^'PropertyTagCopyright'].
	idx = PropertyTagDateTime ifTrue: [^'PropertyTagDateTime'].
	idx = PropertyTagDocumentName ifTrue: [^'PropertyTagDocumentName'].
	idx = PropertyTagDotRange ifTrue: [^'PropertyTagDotRange'].
	idx = PropertyTagEquipMake ifTrue: [^'PropertyTagEquipMake'].
	idx = PropertyTagEquipModel ifTrue: [^'PropertyTagEquipModel'].
	idx = PropertyTagExifAperture ifTrue: [^'PropertyTagExifAperture'].
	idx = PropertyTagExifBrightness ifTrue: [^'PropertyTagExifBrightness'].
	idx = PropertyTagExifCfaPattern ifTrue: [^'PropertyTagExifCfaPattern'].
	idx = PropertyTagExifColorSpace ifTrue: [^'PropertyTagExifColorSpace'].
	idx = PropertyTagExifCompBPP ifTrue: [^'PropertyTagExifCompBPP'].
	idx = PropertyTagExifCompConfig ifTrue: [^'PropertyTagExifCompConfig'].
	idx = PropertyTagExifDTDigitized ifTrue: [^'PropertyTagExifDTDigitized'].
	idx = PropertyTagExifDTDigSS ifTrue: [^'PropertyTagExifDTDigSS'].
	idx = PropertyTagExifDTOrig ifTrue: [^'PropertyTagExifDTOrig'].
	idx = PropertyTagExifDTOrigSS ifTrue: [^'PropertyTagExifDTOrigSS'].
	idx = PropertyTagExifDTSubsec ifTrue: [^'PropertyTagExifDTSubsec'].
	idx = PropertyTagExifExposureBias ifTrue: [^'PropertyTagExifExposureBias'].
	idx = PropertyTagExifExposureIndex
		ifTrue: [^'PropertyTagExifExposureIndex'].
	idx = PropertyTagExifExposureProg ifTrue: [^'PropertyTagExifExposureProg'].
	idx = PropertyTagExifExposureTime ifTrue: [^'PropertyTagExifExposureTime'].
	idx = PropertyTagExifFileSource ifTrue: [^'PropertyTagExifFileSource'].
	idx = PropertyTagExifFlash ifTrue: [^'PropertyTagExifFlash'].
	idx = PropertyTagExifFlashEnergy ifTrue: [^'PropertyTagExifFlashEnergy'].
	idx = PropertyTagExifFNumber ifTrue: [^'PropertyTagExifFNumber'].
	idx = PropertyTagExifFocalLength ifTrue: [^'PropertyTagExifFocalLength'].
	idx = PropertyTagExifFocalResUnit ifTrue: [^'PropertyTagExifFocalResUnit'].
	idx = PropertyTagExifFocalXRes ifTrue: [^'PropertyTagExifFocalXRes'].
	idx = PropertyTagExifFocalYRes ifTrue: [^'PropertyTagExifFocalYRes'].
	idx = PropertyTagExifFPXVer ifTrue: [^'PropertyTagExifFPXVer'].
	idx = PropertyTagExifIFD ifTrue: [^'PropertyTagExifIFD'].
	idx = PropertyTagExifInterop ifTrue: [^'PropertyTagExifInterop'].
	idx = PropertyTagExifISOSpeed ifTrue: [^'PropertyTagExifISOSpeed'].
	idx = PropertyTagExifLightSource ifTrue: [^'PropertyTagExifLightSource'].
	idx = PropertyTagExifMakerNote ifTrue: [^'PropertyTagExifMakerNote'].
	idx = PropertyTagExifMaxAperture ifTrue: [^'PropertyTagExifMaxAperture'].
	idx = PropertyTagExifMeteringMode ifTrue: [^'PropertyTagExifMeteringMode'].
	idx = PropertyTagExifOECF ifTrue: [^'PropertyTagExifOECF'].
	idx = PropertyTagExifPixXDim ifTrue: [^'PropertyTagExifPixXDim'].
	idx = PropertyTagExifPixYDim ifTrue: [^'PropertyTagExifPixYDim'].
	idx = PropertyTagExifRelatedWav ifTrue: [^'PropertyTagExifRelatedWav'].
	idx = PropertyTagExifSceneType ifTrue: [^'PropertyTagExifSceneType'].
	idx = PropertyTagExifSensingMethod
		ifTrue: [^'PropertyTagExifSensingMethod'].
	idx = PropertyTagExifShutterSpeed ifTrue: [^'PropertyTagExifShutterSpeed'].
	idx = PropertyTagExifSpatialFR ifTrue: [^'PropertyTagExifSpatialFR'].
	idx = PropertyTagExifSpectralSense
		ifTrue: [^'PropertyTagExifSpectralSense'].
	idx = PropertyTagExifSubjectDist ifTrue: [^'PropertyTagExifSubjectDist'].
	idx = PropertyTagExifSubjectLoc ifTrue: [^'PropertyTagExifSubjectLoc'].
	idx = PropertyTagExifUserComment ifTrue: [^'PropertyTagExifUserComment'].
	idx = PropertyTagExifVer ifTrue: [^'PropertyTagExifVer'].
	idx = PropertyTagExtraSamples ifTrue: [^'PropertyTagExtraSamples'].
	idx = PropertyTagFillOrder ifTrue: [^'PropertyTagFillOrder'].
	idx = PropertyTagFrameDelay ifTrue: [^'PropertyTagFrameDelay'].
	idx = PropertyTagFreeByteCounts ifTrue: [^'PropertyTagFreeByteCounts'].
	idx = PropertyTagFreeOffset ifTrue: [^'PropertyTagFreeOffset'].
	idx = PropertyTagGamma ifTrue: [^'PropertyTagGamma'].
	idx = PropertyTagGpsAltitude ifTrue: [^'PropertyTagGpsAltitude'].
	idx = PropertyTagGpsAltitudeRef ifTrue: [^'PropertyTagGpsAltitudeRef'].
	idx = PropertyTagGpsDestBear ifTrue: [^'PropertyTagGpsDestBear'].
	idx = PropertyTagGpsDestBearRef ifTrue: [^'PropertyTagGpsDestBearRef'].
	idx = PropertyTagGpsDestDist ifTrue: [^'PropertyTagGpsDestDist'].
	idx = PropertyTagGpsDestDistRef ifTrue: [^'PropertyTagGpsDestDistRef'].
	idx = PropertyTagGpsDestLat ifTrue: [^'PropertyTagGpsDestLat'].
	idx = PropertyTagGpsDestLatRef ifTrue: [^'PropertyTagGpsDestLatRef'].
	idx = PropertyTagGpsDestLong ifTrue: [^'PropertyTagGpsDestLong'].
	idx = PropertyTagGpsDestLongRef ifTrue: [^'PropertyTagGpsDestLongRef'].
	idx = PropertyTagGpsGpsDop ifTrue: [^'PropertyTagGpsGpsDop'].
	idx = PropertyTagGpsGpsMeasureMode
		ifTrue: [^'PropertyTagGpsGpsMeasureMode'].
	idx = PropertyTagGpsGpsSatellites ifTrue: [^'PropertyTagGpsGpsSatellites'].
	idx = PropertyTagGpsGpsStatus ifTrue: [^'PropertyTagGpsGpsStatus'].
	idx = PropertyTagGpsGpsTime ifTrue: [^'PropertyTagGpsGpsTime'].
	idx = 16r8825 ifTrue: [^'PropertyTagGpsIFD'].
	idx = PropertyTagGpsImgDir ifTrue: [^'PropertyTagGpsImgDir'].
	idx = PropertyTagGpsImgDirRef ifTrue: [^'PropertyTagGpsImgDirRef'].
	idx = PropertyTagGpsLatitude ifTrue: [^'PropertyTagGpsLatitude'].
	idx = PropertyTagGpsLatitudeRef ifTrue: [^'PropertyTagGpsLatitudeRef'].
	idx = PropertyTagGpsLongitude ifTrue: [^'PropertyTagGpsLongitude'].
	idx = PropertyTagGpsLongitudeRef ifTrue: [^'PropertyTagGpsLongitudeRef'].
	idx = PropertyTagGpsMapDatum ifTrue: [^'PropertyTagGpsMapDatum'].
	idx = PropertyTagGpsSpeed ifTrue: [^'PropertyTagGpsSpeed'].
	idx = PropertyTagGpsSpeedRef ifTrue: [^'PropertyTagGpsSpeedRef'].
	idx = PropertyTagGpsTrack ifTrue: [^'PropertyTagGpsTrack'].
	idx = PropertyTagGpsTrackRef ifTrue: [^'PropertyTagGpsTrackRef'].
	idx = PropertyTagGpsVer ifTrue: [^'PropertyTagGpsVer'].
	idx = PropertyTagGrayResponseCurve
		ifTrue: [^'PropertyTagGrayResponseCurve'].
	idx = PropertyTagGrayResponseUnit ifTrue: [^'PropertyTagGrayResponseUnit'].
	idx = PropertyTagGridSize ifTrue: [^'PropertyTagGridSize'].
	idx = PropertyTagHalftoneDegree ifTrue: [^'PropertyTagHalftoneDegree'].
	idx = PropertyTagHalftoneHints ifTrue: [^'PropertyTagHalftoneHints'].
	idx = PropertyTagHalftoneLPI ifTrue: [^'PropertyTagHalftoneLPI'].
	idx = PropertyTagHalftoneLPIUnit ifTrue: [^'PropertyTagHalftoneLPIUnit'].
	idx = PropertyTagHalftoneMisc ifTrue: [^'PropertyTagHalftoneMisc'].
	idx = PropertyTagHalftoneScreen ifTrue: [^'PropertyTagHalftoneScreen'].
	idx = PropertyTagHalftoneShape ifTrue: [^'PropertyTagHalftoneShape'].
	idx = PropertyTagHostComputer ifTrue: [^'PropertyTagHostComputer'].
	idx = PropertyTagICCProfile ifTrue: [^'PropertyTagICCProfile'].
	idx = PropertyTagICCProfileDescriptor
		ifTrue: [^'PropertyTagICCProfileDescriptor'].
	idx = PropertyTagImageDescription ifTrue: [^'PropertyTagImageDescription'].
	idx = PropertyTagImageHeight ifTrue: [^'PropertyTagImageHeight'].
	idx = PropertyTagImageTitle ifTrue: [^'PropertyTagImageTitle'].
	idx = PropertyTagImageWidth ifTrue: [^'PropertyTagImageWidth'].
	idx = PropertyTagInkNames ifTrue: [^'PropertyTagInkNames'].
	idx = PropertyTagInkSet ifTrue: [^'PropertyTagInkSet'].
	idx = PropertyTagJPEGACTables ifTrue: [^'PropertyTagJPEGACTables'].
	idx = PropertyTagJPEGDCTables ifTrue: [^'PropertyTagJPEGDCTables'].
	idx = PropertyTagJPEGInterFormat ifTrue: [^'PropertyTagJPEGInterFormat'].
	idx = PropertyTagJPEGInterLength ifTrue: [^'PropertyTagJPEGInterLength'].
	idx = PropertyTagJPEGLosslessPredictors
		ifTrue: [^'PropertyTagJPEGLosslessPredictors'].
	idx = 16r206 ifTrue: [^'PropertyTagJPEGPointTransforms'].
	idx = 16r200 ifTrue: [^'PropertyTagJPEGProc'].
	idx = PropertyTagJPEGQTables ifTrue: [^'PropertyTagJPEGQTables'].
	idx = PropertyTagJPEGQuality ifTrue: [^'PropertyTagJPEGQuality'].
	idx = PropertyTagJPEGRestartInterval
		ifTrue: [^'PropertyTagJPEGRestartInterval'].
	idx = PropertyTagLoopCount ifTrue: [^'PropertyTagLoopCount'].
	idx = PropertyTagLuminanceTable ifTrue: [^'PropertyTagLuminanceTable'].
	idx = PropertyTagMaxSampleValue ifTrue: [^'PropertyTagMaxSampleValue'].
	idx = PropertyTagMinSampleValue ifTrue: [^'PropertyTagMinSampleValue'].
	idx = PropertyTagNewSubfileType ifTrue: [^'PropertyTagNewSubfileType'].
	idx = PropertyTagNumberOfInks ifTrue: [^'PropertyTagNumberOfInks'].
	idx = PropertyTagOrientation ifTrue: [^'PropertyTagOrientation'].
	idx = PropertyTagPageName ifTrue: [^'PropertyTagPageName'].
	idx = PropertyTagPageNumber ifTrue: [^'PropertyTagPageNumber'].
	idx = PropertyTagPaletteHistogram ifTrue: [^'PropertyTagPaletteHistogram'].
	idx = PropertyTagPhotometricInterp
		ifTrue: [^'PropertyTagPhotometricInterp'].
	idx = PropertyTagPixelPerUnitX ifTrue: [^'PropertyTagPixelPerUnitX'].
	idx = PropertyTagPixelPerUnitY ifTrue: [^'PropertyTagPixelPerUnitY'].
	idx = PropertyTagPixelUnit ifTrue: [^'PropertyTagPixelUnit'].
	idx = PropertyTagPlanarConfig ifTrue: [^'PropertyTagPlanarConfig'].
	idx = PropertyTagPredictor ifTrue: [^'PropertyTagPredictor'].
	idx = PropertyTagPrimaryChromaticities
		ifTrue: [^'PropertyTagPrimaryChromaticities'].
	idx = PropertyTagPrintFlags ifTrue: [^'PropertyTagPrintFlags'].
	idx = PropertyTagPrintFlagsBleedWidth
		ifTrue: [^'PropertyTagPrintFlagsBleedWidth'].
	idx = PropertyTagPrintFlagsBleedWidthScale
		ifTrue: [^'PropertyTagPrintFlagsBleedWidthScale'].
	idx = PropertyTagPrintFlagsCrop ifTrue: [^'PropertyTagPrintFlagsCrop'].
	idx = PropertyTagPrintFlagsVersion
		ifTrue: [^'PropertyTagPrintFlagsVersion'].
	idx = PropertyTagREFBlackWhite ifTrue: [^'PropertyTagREFBlackWhite'].
	idx = PropertyTagResolutionUnit ifTrue: [^'PropertyTagResolutionUnit'].
	idx = PropertyTagResolutionXLengthUnit
		ifTrue: [^'PropertyTagResolutionXLengthUnit'].
	idx = PropertyTagResolutionXUnit ifTrue: [^'PropertyTagResolutionXUnit'].
	idx = PropertyTagResolutionYLengthUnit
		ifTrue: [^'PropertyTagResolutionYLengthUnit'].
	idx = PropertyTagResolutionYUnit ifTrue: [^'PropertyTagResolutionYUnit'].
	idx = PropertyTagRowsPerStrip ifTrue: [^'PropertyTagRowsPerStrip'].
	idx = PropertyTagSampleFormat ifTrue: [^'PropertyTagSampleFormat'].
	idx = PropertyTagSamplesPerPixel ifTrue: [^'PropertyTagSamplesPerPixel'].
	idx = PropertyTagSMaxSampleValue ifTrue: [^'PropertyTagSMaxSampleValue'].
	idx = PropertyTagSMinSampleValue ifTrue: [^'PropertyTagSMinSampleValue'].
	idx = PropertyTagSoftwareUsed ifTrue: [^'PropertyTagSoftwareUsed'].
	idx = PropertyTagSRGBRenderingIntent
		ifTrue: [^'PropertyTagSRGBRenderingIntent'].
	idx = PropertyTagStripBytesCount ifTrue: [^'PropertyTagStripBytesCount'].
	idx = PropertyTagStripOffsets ifTrue: [^'PropertyTagStripOffsets'].
	idx = PropertyTagSubfileType ifTrue: [^'PropertyTagSubfileType'].
	idx = PropertyTagT4Option ifTrue: [^'PropertyTagT4Option'].
	idx = PropertyTagT6Option ifTrue: [^'PropertyTagT6Option'].
	idx = PropertyTagTargetPrinter ifTrue: [^'PropertyTagTargetPrinter'].
	idx = PropertyTagThreshHolding ifTrue: [^'PropertyTagThreshHolding'].
	idx = PropertyTagThumbnailArtist ifTrue: [^'PropertyTagThumbnailArtist'].
	idx = PropertyTagThumbnailBitsPerSample
		ifTrue: [^'PropertyTagThumbnailBitsPerSample'].
	idx = PropertyTagThumbnailColorDepth
		ifTrue: [^'PropertyTagThumbnailColorDepth'].
	idx = PropertyTagThumbnailCompressedSize
		ifTrue: [^'PropertyTagThumbnailCompressedSize'].
	idx = PropertyTagThumbnailCompression
		ifTrue: [^'PropertyTagThumbnailCompression'].
	idx = PropertyTagThumbnailCopyRight
		ifTrue: [^'PropertyTagThumbnailCopyRight'].
	idx = PropertyTagThumbnailData ifTrue: [^'PropertyTagThumbnailData'].
	idx = PropertyTagThumbnailDateTime
		ifTrue: [^'PropertyTagThumbnailDateTime'].
	idx = PropertyTagThumbnailEquipMake
		ifTrue: [^'PropertyTagThumbnailEquipMake'].
	idx = PropertyTagThumbnailEquipModel
		ifTrue: [^'PropertyTagThumbnailEquipModel'].
	idx = PropertyTagThumbnailFormat ifTrue: [^'PropertyTagThumbnailFormat'].
	idx = PropertyTagThumbnailHeight ifTrue: [^'PropertyTagThumbnailHeight'].
	idx = PropertyTagThumbnailImageDescription
		ifTrue: [^'PropertyTagThumbnailImageDescription'].
	idx = PropertyTagThumbnailImageHeight
		ifTrue: [^'PropertyTagThumbnailImageHeight'].
	idx = PropertyTagThumbnailImageWidth
		ifTrue: [^'PropertyTagThumbnailImageWidth'].
	idx = PropertyTagThumbnailOrientation
		ifTrue: [^'PropertyTagThumbnailOrientation'].
	idx = PropertyTagThumbnailPhotometricInterp
		ifTrue: [^'PropertyTagThumbnailPhotometricInterp'].
	idx = PropertyTagThumbnailPlanarConfig
		ifTrue: [^'PropertyTagThumbnailPlanarConfig'].
	idx = PropertyTagThumbnailPlanes ifTrue: [^'PropertyTagThumbnailPlanes'].
	idx = PropertyTagThumbnailPrimaryChromaticities
		ifTrue: [^'PropertyTagThumbnailPrimaryChromaticities'].
	idx = PropertyTagThumbnailRawBytes
		ifTrue: [^'PropertyTagThumbnailRawBytes'].
	idx = PropertyTagThumbnailRefBlackWhite
		ifTrue: [^'PropertyTagThumbnailRefBlackWhite'].
	idx = PropertyTagThumbnailResolutionUnit
		ifTrue: [^'PropertyTagThumbnailResolutionUnit'].
	idx = PropertyTagThumbnailResolutionX
		ifTrue: [^'PropertyTagThumbnailResolutionX'].
	idx = PropertyTagThumbnailResolutionY
		ifTrue: [^'PropertyTagThumbnailResolutionY'].
	idx = PropertyTagThumbnailRowsPerStrip
		ifTrue: [^'PropertyTagThumbnailRowsPerStrip'].
	idx = PropertyTagThumbnailSamplesPerPixel
		ifTrue: [^'PropertyTagThumbnailSamplesPerPixel'].
	idx = PropertyTagThumbnailSize ifTrue: [^'PropertyTagThumbnailSize'].
	idx = PropertyTagThumbnailSoftwareUsed
		ifTrue: [^'PropertyTagThumbnailSoftwareUsed'].
	idx = PropertyTagThumbnailStripBytesCount
		ifTrue: [^'PropertyTagThumbnailStripBytesCount'].
	idx = PropertyTagThumbnailStripOffsets
		ifTrue: [^'PropertyTagThumbnailStripOffsets'].
	idx = PropertyTagThumbnailTransferFunction
		ifTrue: [^'PropertyTagThumbnailTransferFunction'].
	idx = PropertyTagThumbnailWhitePoint
		ifTrue: [^'PropertyTagThumbnailWhitePoint'].
	idx = PropertyTagThumbnailWidth ifTrue: [^'PropertyTagThumbnailWidth'].
	idx = PropertyTagThumbnailYCbCrCoefficients
		ifTrue: [^'PropertyTagThumbnailYCbCrCoefficients'].
	idx = PropertyTagThumbnailYCbCrPositioning
		ifTrue: [^'PropertyTagThumbnailYCbCrPositioning'].
	idx = PropertyTagThumbnailYCbCrSubsampling
		ifTrue: [^'PropertyTagThumbnailYCbCrSubsampling'].
	idx = PropertyTagTileByteCounts ifTrue: [^'PropertyTagTileByteCounts'].
	idx = PropertyTagTileLength ifTrue: [^'PropertyTagTileLength'].
	idx = PropertyTagTileOffset ifTrue: [^'PropertyTagTileOffset'].
	idx = PropertyTagTileWidth ifTrue: [^'PropertyTagTileWidth'].
	idx = PropertyTagTransferFuncition
		ifTrue: [^'PropertyTagTransferFuncition'].
	idx = PropertyTagTransferRange ifTrue: [^'PropertyTagTransferRange'].
	idx = PropertyTagWhitePoint ifTrue: [^'PropertyTagWhitePoint'].
	idx = PropertyTagXPosition ifTrue: [^'PropertyTagXPosition'].
	idx = PropertyTagXResolution ifTrue: [^'PropertyTagXResolution'].
	idx = PropertyTagYCbCrCoefficients
		ifTrue: [^'PropertyTagYCbCrCoefficients'].
	idx = PropertyTagYCbCrPositioning ifTrue: [^'PropertyTagYCbCrPositioning'].
	idx = PropertyTagYCbCrSubsampling ifTrue: [^'PropertyTagYCbCrSubsampling'].
	idx = PropertyTagYPosition ifTrue: [^'PropertyTagYPosition'].
	^self type asString]

{ #category : #testing }
PropertyItem >> isLocal [
	^values notNil]

{ #category : #accessing }
PropertyItem >> length [
	^self uLongAtOffset: length]

{ #category : #accessing }
PropertyItem >> length: anInteger [
	self uLongAtOffset: length put: anInteger]

{ #category : #copying }
PropertyItem >> postLocalCopy [
	values := self values.
	super postLocalCopy]

{ #category : #output }
PropertyItem >> rationals [
	| rationals |
	rationals := OrderedCollection new.
	self uLongs pairsDo: [:a :b | rationals add: a / b].
	^rationals]

{ #category : #input }
PropertyItem >> rationals: aCollection [
	| ulongs |
	ulongs := OrderedCollection new.
	aCollection do: [:each | 
		each isFraction
			ifTrue: [ulongs add: each numerator; add: each denominator]
			ifFalse: [ulongs add: each asInteger; add: 1]].
	self uLongs: ulongs; type: PropertyTagTypeRational]

{ #category : #private }
PropertyItem >> readLongs: count [
	| memory array |
	memory := self value.
	memory isValid ifFalse: [^nil].
	array := BufferArray at: memory count: count type: ExternalInt32.
	^array makeLocal]

{ #category : #private }
PropertyItem >> readSLongs: count [
	| longs |
	longs := self readLongs: count.
	^longs collect: #asInteger]

{ #category : #private }
PropertyItem >> readULongs: count [
	| ulongs |
	ulongs := self readLongs: count.
	^ulongs collect: #asUnsignedInteger]

{ #category : #output }
PropertyItem >> shorts [
	| memory buffer n shorts |
	memory := self value.
	memory isValid ifFalse: [^nil].
	buffer := MemoryBuffer atMemory: memory.
	n := self length / 2.
	shorts := OrderedCollection new: n.
	1 to: n do: [:i | | short |
		short := buffer uShortAtOffset: i - 1 * 2.
		shorts add: short].
	^shorts]

{ #category : #input }
PropertyItem >> shorts: aCollection [
	| buffer |
	buffer := MemoryBuffer external: aCollection size * 2.
	aCollection
		withIndexDo: [:each :i | buffer uShortAtOffset: i - 1 * 2 put: each].
	self
		type: PropertyTagTypeShort;
		value: buffer address;
		length: aCollection size * 2]

{ #category : #output }
PropertyItem >> sLongs [
	^self readSLongs: self length / 4]

{ #category : #input }
PropertyItem >> sLongs: aCollection [
	| buffer |
	buffer := MemoryBuffer external: aCollection size * 4.
	aCollection
		withIndexDo: [:each :i | buffer longAtOffset: i - 1 * 4 put: each].
	self
		type: PropertyTagTypeSLONG;
		value: buffer address;
		length: aCollection size * 4]

{ #category : #output }
PropertyItem >> sRationals [
	| rationals |
	rationals := OrderedCollection new.
	self sLongs pairsDo: [:a :b | rationals add: a / b].
	^rationals]

{ #category : #input }
PropertyItem >> sRationals: aCollection [
	| ulongs |
	ulongs := OrderedCollection new.
	aCollection do: [:each | 
		each isFraction
			ifTrue: [ulongs add: each numerator; add: each denominator]
			ifFalse: [ulongs add: each asInteger; add: 1]].
	self sLongs: ulongs; type: PropertyTagTypeRational]

{ #category : #accessing }
PropertyItem >> type [
	^self uShortAtOffset: type]

{ #category : #accessing }
PropertyItem >> type: anInteger [
	self uShortAtOffset: type put: anInteger]

{ #category : #output }
PropertyItem >> uLongs [
	^self readULongs: self length / 4]

{ #category : #input }
PropertyItem >> uLongs: aCollection [
	| buffer |
	buffer := MemoryBuffer external: aCollection size * 4.
	aCollection
		withIndexDo: [:each :i | buffer uLongAtOffset: i - 1 * 4 put: each].
	self
		type: PropertyTagTypeLong;
		value: buffer address;
		length: aCollection size * 4]

{ #category : #output }
PropertyItem >> undefined [
	| memory |
	memory := self value.
	^memory isValid ifTrue: [ByteArray fromMemory: memory length: self length]]

{ #category : #input }
PropertyItem >> undefined: aByteArray [
	self
		type: PropertyTagTypeUndefined;
		value: aByteArray externalCopy;
		length: aByteArray size]

{ #category : #accessing }
PropertyItem >> value [
	^self addressAtOffset: value]

{ #category : #accessing }
PropertyItem >> value: anExternalMemory [
	self addressAtOffset: value register: anExternalMemory]

{ #category : #output }
PropertyItem >> values [
	| t |
	self isLocal ifTrue: [^values].
	t := self type.
	t = PropertyTagTypeByte ifTrue: [^self bytes].
	t = PropertyTagTypeASCII ifTrue: [^self chars].
	t = PropertyTagTypeShort ifTrue: [^self shorts].
	t = PropertyTagTypeLong ifTrue: [^self uLongs].
	t = PropertyTagTypeRational ifTrue: [^self rationals].
	t = PropertyTagTypeSLONG ifTrue: [^self sLongs].
	t = PropertyTagTypeSRational ifTrue: [^self sRationals].
	t = PropertyTagTypeUndefined ifTrue: [^self undefined].
	self ASSERT: false]

