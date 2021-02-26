"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusImage,
	#superclass : #GDIPlusObject,
	#instVars : [
		'bounds',
		'width',
		'height'
	],
	#category : #GDIPlus
}

{ #category : #'encoders / decoders' }
GDIPlusImage class >> clsidForEncoderType: mimeType [
	"
	GDIPlusImage clsidForEncoderType: 'image/bmp'
	"
	| encoder |
	encoder := self imageEncoders
		detect: [:ici | ici mimeType = mimeType]
		ifNone: [^nil].
	^encoder Clsid]

{ #category : #'instance creation' }
GDIPlusImage class >> fromFile: aFilename [
	^self fromFile: aFilename useICM: false]

{ #category : #'instance creation' }
GDIPlusImage class >> fromFile: aFilename useICM: aBoolean [
	| handle filename status |
	handle := ExternalPointer external.
	filename := aFilename asString externalCopy.
	status := aBoolean
		ifTrue: [
			self dll
				GdipLoadImageFromFileICM: filename asParameter
				image: handle asParameter]
		ifFalse: [
			self dll
				GdipLoadImageFromFile: filename asParameter
				image: handle asParameter].
	self checkStatus: status.
	filename free.
	^self fromHandle: handle makeLocal]

{ #category : #'instance creation' }
GDIPlusImage class >> fromIStream: anIStream useICM: aBoolean [
	| handle status stream |
	handle := ExternalPointer external.
	stream := anIStream externalCopy.
	status := aBoolean
		ifTrue: [
			self dll
				GdipLoadImageFromStreamICM: stream asParameter
				image: handle asParameter]
		ifFalse: [
			self dll
				GdipLoadImageFromStream: stream asParameter
				image: handle asParameter].
	self checkStatus: status.
	stream == anIStream ifFalse: [anIStream free].
	^self fromHandle: handle makeLocal]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageDecoders [
	"
	GDIPlusImage imageDecoders
	"
	| sizes decoders size memory codecs |
	sizes := self imageDecodersSizes.
	decoders := sizes at: 1.
	size := sizes at: 2.
	memory := size externalBytes.
	[| status buffer |
		status := self dll
			GdipGetImageDecoders: decoders
			size: size
			decoders: memory asParameter.
		self checkStatus: status.
		buffer := BufferArray at: memory count: decoders type: ImageCodecInfo.
		codecs := buffer asArray]
		ensure: [memory free].
	^codecs collect: #localCopy]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageDecodersNumber [
	^self imageDecodersSizes at: 1]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageDecodersSize [
	^self imageDecodersSizes at: 2]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageDecodersSizes [
	| size decoders status |
	size := ExternalInt32 external.
	decoders := ExternalInt32 external.
	status := self dll
		GdipGetImageDecodersSize: decoders asParameter
		size: size asParameter.
	self checkStatus: status.
	^{decoders makeLocal asUnsignedInteger. size makeLocal asUnsignedInteger}]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageEncoders [
	"
	GDIPlusImage imageEncoders
	"
	| sizes encoders size memory codecs |
	sizes := self imageEncodersSizes.
	encoders := sizes at: 1.
	size := sizes at: 2.
	memory := size externalBytes.
	[| status buffer |
		status := self dll
			GdipGetImageEncoders: encoders
			size: size
			encoders: memory asParameter.
		self checkStatus: status.
		buffer := BufferArray at: memory count: encoders type: ImageCodecInfo.
		codecs := buffer asArray]
		ensure: [memory free].
	^codecs collect: #localCopy]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageEncodersNumber [
	^self imageEncodersSizes at: 1]

{ #category : #'encoders / decoders' }
GDIPlusImage class >> imageEncodersSize [
	^self imageEncodersSizes at: 2]

{ #category : #'instance creation' }
GDIPlusImage class >> imageEncodersSizes [
	| size encoders status |
	size := ExternalInt32 external.
	encoders := ExternalInt32 external.
	status := self dll
		GdipGetImageEncodersSize: encoders asParameter
		size: size asParameter.
	self checkStatus: status.
	^{encoders makeLocal asUnsignedInteger. size makeLocal asUnsignedInteger}]

{ #category : #converting }
GDIPlusImage >> asGDIPlusBitmap [
	| bytes stream istream clsid bitmap |
	bytes := #[] writeStream.
	stream := (Smalltalk at: #ComStream) on: bytes.
	istream := stream clientFor: (Smalltalk at: #IStreamClient) iid.
	clsid := self class clsidForEncoderType: 'image/bmp'.
	self saveToStream: istream clsidEncoder: clsid.
	bitmap := GDIPlusBitmap fromIStream: istream useICM: false.
	istream release.
	bitmap]

{ #category : #private }
GDIPlusImage >> basicRelease [
	status := self dll GdipDisposeImage: self asParameter.
	self checkStatus]

{ #category : #geometry }
GDIPlusImage >> boundingBox [
	^self bounds rounded]

{ #category : #geometry }
GDIPlusImage >> bounds [
	bounds isNil ifTrue: [bounds := self getBounds at: 1].
	^bounds]

{ #category : #geometry }
GDIPlusImage >> boundsUnit [
	^self getBounds at: 2]

{ #category : #copying }
GDIPlusImage >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneImage: self asParameter
		cloneImage: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #'encoders / decoders' }
GDIPlusImage >> encoderParameterList: aCLSID [
	| size clsid memory params |
	size := self encoderParameterListSize: aCLSID.
	clsid := aCLSID externalCopy.
	memory := size externalBytes.
	[| buffer count |
		status := self dll
			GdipGetEncoderParameterList: self asParameter
			clsidEncoder: clsid asParameter
			size: size
			buffer: memory asParameter.
		self checkStatus.
		clsid == aCLSID ifFalse: [clsid free].
		buffer := MemoryBuffer atMemory: memory.
		count := buffer uLongAtOffset: 0.
		buffer := BufferArray
			at: memory + WordSize
			count: count
			type: EncoderParameter.
		params := buffer asArray]
		ensure: [memory free].
	^params]

{ #category : #'encoders / decoders' }
GDIPlusImage >> encoderParameterListSize: aCLSID [
	| clsid size |
	clsid := aCLSID externalCopy.
	size := ExternalInt32 external.
	status := self dll
		GdipGetEncoderParameterListSize: self asParameter
		clsidEncoder: clsid asParameter
		size: size asParameter.
	self checkStatus.
	clsid == aCLSID ifFalse: [clsid free].
	^size makeLocal asUnsignedInteger]

{ #category : #geometry }
GDIPlusImage >> extent [
	^self width @ self height]

{ #category : #accessing }
GDIPlusImage >> flags [
	| flags |
	flags := ExternalInt32 external.
	status := self dll
		GdipGetImageFlags: self asParameter
		flags: flags asParameter.
	self checkStatus.
	^flags makeLocal asUnsignedInteger]

{ #category : #frames }
GDIPlusImage >> frameCount: aGUID [
	| count dimension |
	count := ExternalInt32 external.
	dimension := aGUID externalCopy.
	status := self dll
		GdipImageGetFrameCount: self asParameter
		dimensionID: dimension asParameter
		count: count asParameter.
	self checkStatus.
	dimension == aGUID ifFalse: [dimension free].
	^count makeLocal asUnsignedInteger]

{ #category : #frames }
GDIPlusImage >> frameDimensionsCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipImageGetFrameDimensionsCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeLocal asUnsignedInteger]

{ #category : #frames }
GDIPlusImage >> frameDimensionsList [
	| count buffer guids n |
	count := self frameDimensionsCount.
	buffer := MemoryBuffer external: count * GUID sizeInBytes.
	status := self dll
		GdipImageGetFrameDimensionsList: self asParameter
		dimensionIDs: buffer asParameter
		count: count asParameter.
	self checkStatus.
	guids := Array new: count.
	n := GUID sizeInBytes.
	0 to: count - 1 do: [:idx | | bytes guid |
		bytes := buffer bytesAtOffset: idx * n count: n.
		guid := GUID usingBytes: bytes.
		guids at: idx + 1 put: guid].
	buffer free.
	^guids]

{ #category : #private }
GDIPlusImage >> getBounds [
	| rectangle unit |
	rectangle := RectF external.
	unit := ExternalInt32 external.
	status := self dll
		GdipGetImageBounds: self asParameter
		srcRect: rectangle asParameter
		srcUnit: unit asParameter.
	self checkStatus.
	^{rectangle makeLocal asRectangle. unit makeLocal asUnsignedInteger}]

{ #category : #accessing }
GDIPlusImage >> graphics [
	^GDIPlusGraphics fromImage: self]

{ #category : #geometry }
GDIPlusImage >> height [
	| long |
	height notNil ifTrue: [^height].
	long := ExternalInt32 external.
	status := self dll
		GdipGetImageHeight: self asParameter
		height: long asParameter.
	self checkStatus.
	height := long makeLocal asInteger.
	^height]

{ #category : #accessing }
GDIPlusImage >> horizontalResolution [
	| resolution |
	resolution := ExternalFloat external.
	status := self dll
		GdipGetImageHorizontalResolution: self asParameter
		resolution: resolution asParameter.
	self checkStatus.
	^resolution makeLocal asFloat]

{ #category : #palettes }
GDIPlusImage >> palette [
	| size palette |
	size := self paletteSize.
	palette := ColorPalette external: size.
	status := self dll
		GdipGetImagePalette: self asParameter
		palette: palette asParameter
		size: size asParameter.
	self checkStatus.
	^palette makeLocal entries]

{ #category : #palettes }
GDIPlusImage >> palette: aColorPalette [
	| palette |
	palette := aColorPalette externalCopy.
	status := self dll
		GdipSetImagePalette: self asParameter
		palette: palette asParameter.
	palette free.
	self checkStatus]

{ #category : #palettes }
GDIPlusImage >> paletteSize [
	| size |
	size := ExternalInt32 external.
	status := self dll
		GdipGetImagePaletteSize: self asParameter
		size: size asParameter.
	self checkStatus.
	^size makeInteger]

{ #category : #geometry }
GDIPlusImage >> physicalDimension [
	| w h |
	w := ExternalFloat external.
	h := ExternalFloat external.
	status := self dll
		GdipGetImageDimension: self asParameter
		width: w asParameter
		height: h asParameter.
	self checkStatus.
	^w makeLocal asFloat @ h makeLocal asFloat]

{ #category : #accessing }
GDIPlusImage >> pixelFormat [
	| format |
	format := ExternalInt32 external.
	status := self dll
		GdipGetImagePixelFormat: self asParameter
		format: format asParameter.
	self checkStatus.
	^format makeLocal asUnsignedInteger]

{ #category : #properties }
GDIPlusImage >> properties [
	^self propertiesIdList collect: [:prop | self propertyItem: prop]]

{ #category : #properties }
GDIPlusImage >> propertiesBufferSize [
	^self propertySizes at: 1]

{ #category : #properties }
GDIPlusImage >> propertiesCount [
	^self propertySizes at: 2]

{ #category : #properties }
GDIPlusImage >> propertiesIdList [
	| size buffer |
	size := self propertiesCount.
	buffer := BufferArray externalNew: size of: ExternalInt32.
	status := self dll
		GdipGetPropertyIdList: self asParameter
		numOfProperty: size
		list: buffer asParameter.
	self checkStatus.
	^buffer makeLocal asArray collect: #asUnsignedInteger]

{ #category : #properties }
GDIPlusImage >> propertyItem: propertyId [
	| size memory prop |
	size := self propertyItemSize: propertyId.
	memory := size externalBytes.
	[
		status := self dll
			GdipGetPropertyItem: self asParameter
			propId: propertyId asParameter
			propSize: size asParameter
			buffer: memory asParameter.
		self checkStatus.
		prop := PropertyItem fromMemory: memory]
		ensure: [memory free].
	^prop]

{ #category : #properties }
GDIPlusImage >> propertyItemSize: propId [
	| size |
	size := ExternalInt32 external.
	status := self dll
		GdipGetPropertyItemSize: self asParameter
		propId: propId asParameter
		size: size asParameter.
	self checkStatus.
	^size makeLocal asUnsignedInteger]

{ #category : #properties }
GDIPlusImage >> propertySizes [
	| properties size |
	size := ExternalInt32 external.
	properties := ExternalInt32 external.
	status := self dll
		GdipGetPropertySize: self asParameter
		totalBufferSize: size asParameter
		numProperties: properties asParameter.
	self checkStatus.
	^{size makeLocal asUnsignedInteger. properties makeLocal asUnsignedInteger}]

{ #category : #accessing }
GDIPlusImage >> rawFormat [
	| guid |
	guid := GUID external.
	status := self dll
		GdipGetImageRawFormat: self asParameter
		format: guid asParameter.
	self checkStatus.
	^guid makeLocal]

{ #category : #accessing }
GDIPlusImage >> rawFormatString [
	"
	The GetRawFormat method gets a GUID that identifies the format of this Image
	object. GUIDs that identify various file formats are defined in Gdiplusimaging.h.
	"
	^self rawFormat asString]

{ #category : #properties }
GDIPlusImage >> removePropertyItem: propId [
	status := self dll
		GdipRemovePropertyItem: self asParameter
		propId: propId asParameter.
	self checkStatus]

{ #category : #services }
GDIPlusImage >> rotateFlip: rotateFlipType [
	status := self dll
		GdipImageRotateFlip: self asParameter
		rfType: rotateFlipType asParameter.
	self checkStatus]

{ #category : #saving }
GDIPlusImage >> saveAdd: encoderParameters [
	| buffer |
	buffer := EncoderParameters new parameters: encoderParameters.
	buffer := buffer externalCopy.
	status := self dll
		GdipSaveAdd: self asParameter
		encoderParams: buffer asParameter.
	self checkStatus.
	buffer free]

{ #category : #saving }
GDIPlusImage >> saveAdd: newImage encoderParameters: encoderParameters [
	| buffer |
	buffer := EncoderParameters new parameters: encoderParameters.
	buffer := buffer externalCopy.
	status := self dll
		GdipSaveAddImage: self asParameter
		newImage: newImage asParameter
		encoderParams: buffer asParameter.
	self checkStatus.
	buffer free]

{ #category : #saving }
GDIPlusImage >> saveToFile: aFilename clsidEncoder: clsidEncoder [
	^self
		saveToFile: aFilename
		clsidEncoder: clsidEncoder
		encoderParameters: nil]

{ #category : #saving }
GDIPlusImage >> saveToFile: filename clsidEncoder: clsidEncoder encoderParameters: encoderParameters [
	| fn buffer |
	fn := filename asString externalCopy.
	buffer := encoderParameters notNil
		ifTrue: [EncoderParameters new parameters: encoderParameters].
	buffer := buffer externalCopy.
	status := self dll
		GdipSaveImageToFile: self asParameter
		filename: fn asParameter
		clsidEncoder: clsidEncoder asParameter
		encoderParams: buffer asParameter.
	self checkStatus.
	buffer free.
	fn free]

{ #category : #saving }
GDIPlusImage >> saveToStream: anIStream clsidEncoder: clsidEncoder [
	^self
		saveToStream: anIStream
		clsidEncoder: clsidEncoder
		encoderParameters: nil]

{ #category : #saving }
GDIPlusImage >> saveToStream: anIStream clsidEncoder: clsidEncoder encoderParameters: encoderParameters [
	| buffer clsid |
	buffer := encoderParameters notNil
		ifTrue: [EncoderParameters new parameters: encoderParameters].
	buffer := buffer externalCopy.
	clsid := clsidEncoder externalCopy.
	status := self dll
		GdipSaveImageToStream: self asParameter
		stream: anIStream asParameter
		clsidEncoder: clsid asParameter
		encoderParams: buffer asParameter.
	self checkStatus.
	buffer free.
	clsid free]

{ #category : #frames }
GDIPlusImage >> selectActiveFrame: aGUID frameIndex: frameIndex [
	| dimension |
	dimension := aGUID externalCopy.
	status := self dll
		GdipImageSelectActiveFrame: self asParameter
		dimensionID: dimension asParameter
		frameIndex: frameIndex asParameter.
	self checkStatus.
	dimension free]

{ #category : #properties }
GDIPlusImage >> setPropertyItem: aGDIPlusPropertyItem [
	| item |
	item := aGDIPlusPropertyItem marshal.
	[
		status := self dll
			GdipSetPropertyItem: self asParameter
			item: item asParameter.
		self checkStatus]
		ensure: [item free]]

{ #category : #services }
GDIPlusImage >> thumbnailImage: length height: stature [
	^self
		thumbnailImage: length
		height: stature
		callback: nil
		callbackData: nil]

{ #category : #services }
GDIPlusImage >> thumbnailImage: x
height: y
callback: callback
callbackData: data [
	| image |
	image := ExternalPointer external.
	status := self dll
		GdipGetImageThumbnail: self asParameter
		thumbWidth: x asParameter
		thumbHeight: y asParameter
		thumbImage: image asParameter
		callback: callback asParameter
		callbackData: data asParameter.
	self checkStatus.
	^self class fromHandle: image makeLocal]

{ #category : #accessing }
GDIPlusImage >> type [
	| type |
	type := ExternalInt32 external.
	status := self dll
		GdipGetImageType: self asParameter
		type: type asParameter.
	self checkStatus.
	^type makeLocal asUnsignedInteger]

{ #category : #geometry }
GDIPlusImage >> verticalResolution [
	| resolution |
	resolution := ExternalFloat external.
	status := self dll
		GdipGetImageVerticalResolution: self asParameter
		resolution: resolution asParameter.
	self checkStatus.
	^resolution makeLocal asFloat]

{ #category : #geometry }
GDIPlusImage >> width [
	| long |
	width notNil ifTrue: [^width].
	long := ExternalInt32 external.
	status := self dll
		GdipGetImageWidth: self asParameter
		width: long asParameter.
	self checkStatus.
	width := long makeInteger.
	^width]

