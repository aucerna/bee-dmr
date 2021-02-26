"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusImageAttributes,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> changeContrastAttributes: contrast [
	"
	0 <= contrast <= ... 10.  0 = black, 0.5 = 50%, 1 = unchanged, 2 = + 100% etc.
	"
	| cm |
	cm := ColorMatrix new
		r1c1: contrast;
		r2c2: contrast;
		r3c3: contrast;
		r4c4: 1;
		r5c1: 0.001;
		r5c2: 0.001;
		r5c3: 0.001.
	^self new colorMatrix: cm]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> changeSaturationAttributes: saturation [
	"
	0 <= saturation <= ... 10.  0 = black/white, 1 = unchanged, 2 = + 100% etc.
	"
	| complement r g b cm |
	complement := 1 - saturation.
	r := 0.3086 * complement.
	g := 0.6094 * complement.
	b := 0.082 * complement.
	cm := ColorMatrix new
		r1c1: r + saturation;
		r1c2: r;
		r1c3: r;
		r2c1: g;
		r2c2: g + saturation;
		r2c3: g;
		r3c1: b;
		r3c2: b;
		r3c3: b + saturation;
		r4c4: 1.
	^self new colorMatrix: cm]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> disabledImageAttributes [
	| matrix |
	matrix := ColorMatrix new
		r1c1: 0.2125;
		r1c2: 0.2125;
		r1c3: 0.2125;
		r2c1: 0.2577;
		r2c2: 0.2577;
		r2c3: 0.2577;
		r3c1: 0.0361;
		r3c2: 0.0361;
		r3c3: 0.0361;
		r4c4: 1;
		r5c1: 0.38;
		r5c2: 0.38;
		r5c3: 0.38.
	^self new clearColorKey; colorMatrix: matrix]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> fadedImageAttributes: transparency [
	"
	0 <= transparency <= 1
	"
	| matrix |
	matrix := ColorMatrix new
		r1c1: 1;
		r2c2: 1;
		r3c3: 1;
		r4c4: transparency.
	^self new colorMatrix: matrix]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> grayscaleImageAttributes [
	| matrix |
	matrix := ColorMatrix new
		r1c1: 1 / 3;
		r1c2: 1 / 3;
		r1c3: 1 / 3;
		r2c1: 1 / 3;
		r2c2: 1 / 3;
		r2c3: 1 / 3;
		r3c1: 1 / 3;
		r3c2: 1 / 3;
		r3c3: 1 / 3;
		r4c4: 1.
	^self new colorMatrix: matrix]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> new [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll GdipCreateImageAttributes: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusImageAttributes class >> shadowImageAttributes: shadowValue [
	"
	0 <= shadowValue <= 1
	"
	| matrix |
	matrix := ColorMatrix new r4c4: shadowValue.
	^self new colorMatrix: matrix]

{ #category : #private }
GDIPlusImageAttributes >> basicRelease [
	status := self dll GdipDisposeImageAttributes: self asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearBrushRemapTable [
	self clearRemapTable: ColorAdjustTypeBrush]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorKey [
	self clearColorKey: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorKey: colorAdjustType [
	status := self dll
		GdipSetImageAttributesColorKeys: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		colorLow: nil asParameter
		colorHigh: nil asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorMatrices [
	self clearColorMatrices: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorMatrices: colorAdjustType [
	status := self dll
		GdipSetImageAttributesColorMatrix: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		colorMatrix: 0
		grayMatrix: 0
		flags: ColorMatrixFlagsDefault asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorMatrix [
	self clearColorMatrix: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearColorMatrix: colorAdjustType [
	status := self dll
		GdipSetImageAttributesColorMatrix: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		colorMatrix: 0
		grayMatrix: 0
		flags: ColorMatrixFlagsDefault asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearGamma [
	self clearGamma: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearGamma: colorAdjustType [
	| zero |
	zero := ExternalFloat from: 0.0.
	status := self dll
		GdipSetImageAttributesGamma: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		gamma: zero asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearNoOp [
	self clearNoOp: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearNoOp: colorAdjustType [
	status := self dll
		GdipSetImageAttributesNoOp: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearOutputChannel [
	self clearOutputChannel: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearOutputChannel: colorAdjustType [
	status := self dll
		GdipSetImageAttributesOutputChannel: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		channelFlags: ColorChannelFlagsLast asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearOutputChannelColorProfile [
	self clearOutputChannelColorProfile: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearOutputChannelColorProfile: colorAdjustType [
	status := self dll
		GdipSetImageAttributesOutputChannelColorProfile: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		colorProfileFilename: nil asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearRemapTable [
	self clearRemapTable: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearRemapTable: colorAdjustType [
	status := self dll
		GdipSetImageAttributesRemapTable: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		mapSize: 0 asParameter
		map: nil asParameter.
	self checkStatus]

{ #category : #clear }
GDIPlusImageAttributes >> clearThreshold [
	self clearThreshold: ColorAdjustTypeDefault]

{ #category : #clear }
GDIPlusImageAttributes >> clearThreshold: colorAdjustType [
	| zero |
	zero := ExternalFloat from: 0.0.
	status := self dll
		GdipSetImageAttributesThreshold: self asParameter
		type: colorAdjustType asParameter
		enableFlag: false asParameter
		threshold: zero asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusImageAttributes >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneImageAttributes: self asParameter
		cloneImageattr: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #color }
GDIPlusImageAttributes >> colorMatrix: aColorMatrix [
	self colorMatrix: aColorMatrix mode: ColorMatrixFlagsDefault]

{ #category : #color }
GDIPlusImageAttributes >> colorMatrix: aColorMatrix mode: colorMatrixFlags [
	self
		colorMatrix: aColorMatrix
		mode: colorMatrixFlags
		type: ColorAdjustTypeDefault]

{ #category : #color }
GDIPlusImageAttributes >> colorMatrix: aColorMatrix mode: colorMatrixFlags type: colorAdjustType [
	| cm |
	cm := aColorMatrix externalCopy.
	status := self dll
		GdipSetImageAttributesColorMatrix: self asParameter
		type: colorAdjustType asParameter
		enableFlag: true asParameter
		colorMatrix: cm asParameter
		grayMatrix: 0
		flags: colorMatrixFlags asParameter.
	self checkStatus.
	cm free]

