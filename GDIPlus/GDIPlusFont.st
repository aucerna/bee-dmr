"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusFont,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamily: aGDIPlusFontFamily
emSize: emSize
style: style
unit: unit [
	| pointer em status |
	pointer := ExternalPointer external.
	em := ExternalFloat from: emSize.
	status := self dll
		GdipCreateFont: aGDIPlusFontFamily asParameter
		emSize: em asParameter
		style: style asParameter
		unit: unit asParameter
		font: pointer asParameter.
	self checkStatus: status.
	em free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamilyName: familyName
emSize: emSize
style: style
unit: unit [
	^self
		fromFamilyName: familyName
		emSize: emSize
		style: style
		unit: unit
		fontCollection: nil]

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamilyName: familyName
emSize: emSize
style: style
unit: unit
fontCollection: aGDIPlusFontCollection [
	| family |
	family := GDIPlusFontFamily
		fromName: familyName
		fontCollection: aGDIPlusFontCollection.
	family isNil ifTrue: [^nil].
	^self
		fromFamily: family
		emSize: emSize
		style: style
		unit: unit]

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamilyName: familyName emSize: emSize unit: unit [
	^self
		fromFamilyName: familyName
		emSize: emSize
		style: FontStyleRegular
		unit: unit
		fontCollection: nil]

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamilyName: familyName pointSize: emSize [
	^self fromFamilyName: familyName pointSize: emSize style: FontStyleRegular]

{ #category : #'instance creation' }
GDIPlusFont class >> fromFamilyName: familyName pointSize: anInteger style: style [
	^self
		fromFamilyName: familyName
		emSize: anInteger
		style: style
		unit: UnitPoint]

{ #category : #'instance creation' }
GDIPlusFont class >> fromHDC: aDeviceContext [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateFontFromDC: aDeviceContext asParameter
		font: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusFont class >> fromHDC: aHDC hFont: hFont [
	| struct return |
	struct := LOGFONT external.
	return := GDILibrary
		GetObjectW: hFont asParameter
		cbBuffer: struct sizeInBytes
		lpvObject: struct asParameter.
	return = 0 ifTrue: [
		self winError.
		^self fromHDC: aHDC].
	^self fromHDC: aHDC logFont: struct makeLocal]

{ #category : #'instance creation' }
GDIPlusFont class >> fromHDC: aDeviceContext logFont: aLOGFONT [
	| memory struct status handle |
	memory := ExternalPointer external.
	struct := aLOGFONT externalCopy.
	status := self dll
		GdipCreateFontFromLogfontW: aDeviceContext asParameter
		logfont: struct asParameter
		font: memory asParameter.
	handle := memory makeInteger.
	struct free.
	self checkStatus: status.
	^self fromHandle: handle]

{ #category : #'instance creation' }
GDIPlusFont class >> new [
	^self fromFamilyName: 'Arial' pointSize: GDIFont systemFont pointSize]

{ #category : #accessing }
GDIPlusFont >> ascent [
	| family style |
	family := self family.
	style := self style.
	^(family getCellAscent: style) / (family getEmHeight: style)
		* self sizeInPixels]

{ #category : #converting }
GDIPlusFont >> asFont [
	^[GDIFont fromLogicalFont: self logFont] on: Error do: [
		[GDIFont face: self face size: self pointSize]
			on: Error
			do: [GDIFont face: 'Arial' size: self pointSize]]]

{ #category : #converting }
GDIPlusFont >> asGDIPlusFont [
	^self]

{ #category : #services }
GDIPlusFont >> basicCharWidth: aCharacter [
	^self basicStringWidth: aCharacter asString]

{ #category : #private }
GDIPlusFont >> basicRelease [
	status := self dll GdipDeleteFont: self asParameter.
	self checkStatus]

{ #category : #services }
GDIPlusFont >> basicStringWidth: aString [
	| measure |
	measure := (GDIPlusGraphics fromHDC: Display deviceContext)
		measureString: aString
		font: self
		layoutRectangle: Display boundingBox.
	^measure boundingBox width]

{ #category : #testing }
GDIPlusFont >> bold [
	^self style = FontStyleBold]

{ #category : #services }
GDIPlusFont >> break: aString width: width [
	^StringFormatter break: aString font: self width: width]

{ #category : #private }
GDIPlusFont >> charset [
	^0]

{ #category : #services }
GDIPlusFont >> charWidth: aCharacter [
	^self stringWidth: aCharacter asString]

{ #category : #copying }
GDIPlusFont >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneFont: self asParameter
		cloneFont: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #copying }
GDIPlusFont >> copy [
	^self class
		fromFamily: self family
		emSize: self size
		style: self style
		unit: self unit]

{ #category : #scaling }
GDIPlusFont >> decreased [
	| n |
	n := GDIFont decreasePointSize: self pointSize.
	^self resizedTo: n]

{ #category : #accessing }
GDIPlusFont >> descent [
	| family style |
	family := self family.
	style := self style.
	^(family getCellDescent: style) / (family getEmHeight: style)
		* self sizeInPixels]

{ #category : #accessing }
GDIPlusFont >> face [
	^self family name]

{ #category : #accessing }
GDIPlusFont >> family [
	| family |
	family := ExternalPointer external.
	status := self dll
		GdipGetFamily: self asParameter
		family: family asParameter.
	self checkStatus.
	^GDIPlusFontFamily fromHandle: family makeLocal]

{ #category : #services }
GDIPlusFont >> fit: aString to: extent with: ellipsis [
	^StringFormatter
		fit: aString
		to: extent
		font: self
		ellipsis: ellipsis]

{ #category : #private }
GDIPlusFont >> getHeight: dpi [
	| real height |
	real := ExternalFloat from: dpi.
	height := ExternalFloat external.
	status := self dll
		GdipGetFontHeightGivenDPI: self asParameter
		dpi: real asParameter
		height: height asParameter.
	self checkStatus.
	^height makeLocal asFloat]

{ #category : #private }
GDIPlusFont >> getHeightGraphics: aGDIPlusGraphics [
	| spacing |
	spacing := ExternalFloat external.
	status := self dll
		GdipGetFontHeight: self asParameter
		graphics: aGDIPlusGraphics asParameter
		height: spacing asParameter.
	self checkStatus.
	^spacing makeLocal asFloat]

{ #category : #private }
GDIPlusFont >> getLogFont: aGDIPlusGraphics [
	| font |
	font := LOGFONT external.
	status := self dll
		GdipGetLogFontW: self asParameter
		graphics: aGDIPlusGraphics asParameter
		logfontW: font asParameter.
	self checkStatus.
	^font makeLocal]

{ #category : #accessing }
GDIPlusFont >> height [
	^(self ascent + self descent) rounded]

{ #category : #scaling }
GDIPlusFont >> increased [
	| n |
	n := GDIFont increasePointSize: self pointSize.
	^self resizedTo: n]

{ #category : #testing }
GDIPlusFont >> italic [
	^self style = FontStyleItalic]

{ #category : #accessing }
GDIPlusFont >> lineSpacing [
	^(self getHeight: Display verticalPixelsPerInch) rounded]

{ #category : #services }
GDIPlusFont >> logFont [
	| graphics |
	graphics := GDIPlusGraphics fromHDC: Display deviceContext.
	^self getLogFont: graphics]

{ #category : #accessing }
GDIPlusFont >> pointSize [
	| u size |
	u := self unit.
	size := self size.
	u = UnitPoint ifTrue: [^size].
	u = UnitPixel ifTrue: [^size / Display verticalPixelsPerInch * 72].
	u = UnitInch ifTrue: [^size * 72].
	u = UnitWorld ifTrue: [^size / Display verticalPixelsPerInch * 72].
	self ASSERT: false.
	^size]

{ #category : #printing }
GDIPlusFont >> printOn: aStream [
	aStream
		nextPutAll: self class name , '{' , self family name , ' '
			, self pointSize printString.
	self bold ifTrue: [aStream nextPutAll: ' bold'].
	self italic ifTrue: [aStream nextPutAll: ' italic'].
	aStream nextPutAll: '}']

{ #category : #scaling }
GDIPlusFont >> resizedTo: aNumber [
	aNumber = self size ifTrue: [^self].
	^self class
		fromFamily: self family
		emSize: aNumber
		style: self style
		unit: UnitPoint]

{ #category : #accessing }
GDIPlusFont >> size [
	| size |
	size := ExternalFloat external.
	status := self dll GdipGetFontSize: self asParameter size: size asParameter.
	self checkStatus.
	^size makeLocal asFloat]

{ #category : #accessing }
GDIPlusFont >> sizeInPixels [
	| u size |
	u := self unit.
	size := self size.
	u = UnitPixel ifTrue: [^size].
	u = UnitPoint ifTrue: [^size / 72 * Display verticalPixelsPerInch].
	u = UnitInch ifTrue: [^size * Display verticalPixelsPerInch].
	u = UnitWorld ifTrue: [^size].
	self ASSERT: false.
	^size]

{ #category : #services }
GDIPlusFont >> spaceWidth [
	^self stringWidth: ' ']

{ #category : #testing }
GDIPlusFont >> strikeout [
	^self style = FontStyleStrikeout]

{ #category : #services }
GDIPlusFont >> stringExtent: aString [
	^StringFormatter extent: aString font: self]

{ #category : #services }
GDIPlusFont >> stringHeight: aString [
	aString isNil ifTrue: [^0].
	^aString lineCount * self height]

{ #category : #services }
GDIPlusFont >> stringWidth: aString [
	^(self basicStringWidth: aString) rounded]

{ #category : #accessing }
GDIPlusFont >> style [
	"
	enum FontStyle {
		FontStyleRegular = 0,
		FontStyleBold = 1,
		FontStyleItalic = 2,
		FontStyleBoldItalic = 3,
		FontStyleUnderline = 4,
		FontStyleStrikeOut = 8
	};
	"
	| style |
	style := ExternalInt32 external.
	status := self dll
		GdipGetFontStyle: self asParameter
		style: style asParameter.
	self checkStatus.
	^style makeInteger]

{ #category : #testing }
GDIPlusFont >> underline [
	^self style = FontStyleUnderline]

{ #category : #accessing }
GDIPlusFont >> unit [
	| unit |
	unit := ExternalInt32 external.
	status := self dll GdipGetFontUnit: self asParameter unit: unit asParameter.
	self checkStatus.
	^unit makeLocal asUnsignedInteger]

