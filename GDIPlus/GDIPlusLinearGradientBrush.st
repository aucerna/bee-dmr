"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusLinearGradientBrush,
	#superclass : #GDIPlusBrush,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusLinearGradientBrush class >> rectangle: aRectangle
startColor: startColor
endColor: endColor
angle: angle
isAngleScalable: isAngleScalable [
	| pointer status rect color1 color2 alpha |
	pointer := ExternalPointer external.
	rect := RectF external from: aRectangle.
	color1 := ARGB from: startColor.
	color2 := ARGB from: endColor.
	alpha := ExternalFloat from: angle.
	status := self dll
		GdipCreateLineBrushFromRectWithAngle: rect asParameter
		color1: color1 asParameter
		color2: color2 asParameter
		angle: alpha asParameter
		isAngleScalable: isAngleScalable asParameter
		wrapMode: WrapModeTile
		lineGradient: pointer asParameter.
	self checkStatus: status.
	rect free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusLinearGradientBrush class >> rectangle: aRectangle
startColor: startColor
endColor: endColor
mode: linearGradientMode [
	| pointer rectangle start end status |
	aRectangle area = 0 ifTrue: [^nil].
	pointer := ExternalPointer external.
	rectangle := RectF external from: aRectangle.
	start := ARGB from: startColor.
	end := ARGB from: endColor.
	status := self dll
		GdipCreateLineBrushFromRect: rectangle asParameter
		color1: start asParameter
		color2: end asParameter
		mode: linearGradientMode asParameter
		wrapMode: WrapModeTile
		lineGradient: pointer asParameter.
	self checkStatus: status.
	rectangle free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusLinearGradientBrush class >> startPoint: startPoint
endPoint: endPoint
startColor: startColor
endColor: endColor [
	| pointer s e start end status |
	pointer := ExternalPointer external.
	s := PointF external from: startPoint.
	e := PointF external from: endPoint.
	start := ARGB from: startColor.
	end := ARGB from: endColor.
	status := self dll
		GdipCreateLineBrush: s asParameter
		point2: e asParameter
		color1: start asParameter
		color2: end asParameter
		wrapMode: WrapModeTile
		lineGradient: pointer asParameter.
	self checkStatus: status.
	s free.
	e free.
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendBellShape: focus [
	self blendBellShape: focus scale: 1]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendBellShape: focus scale: scale [
	| f s |
	f := ExternalFloat from: focus.
	s := ExternalFloat from: scale.
	status := self dll
		GdipSetLineSigmaBlend: self asParameter
		focus: f asParameter
		scale: s asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendColorPositions [
	^self blendColorsAndPositions second]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendColors [
	^self blendColorsAndPositions first]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendColors: colorsCollection positions: positionsCollection [
	| colors positions |
	colors := BufferArray externalOn: colorsCollection type: ARGB.
	positions := BufferArray
		externalOn: positionsCollection
		type: ExternalFloat.
	status := self dll
		GdipSetLinePresetBlend: self asParameter
		blend: colors asParameter
		positions: positions asParameter
		count: colorsCollection size asParameter.
	self checkStatus.
	colors free.
	positions free]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendColorsAndPositions [
	| count colors positions |
	count := self blendColorsCount.
	colors := BufferArray externalNew: count of: ExternalFloat.
	positions := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetLinePresetBlend: self asParameter
		blend: colors asParameter
		positions: positions asParameter
		count: count asParameter.
	self checkStatus.
	colors := colors makeLocal asArray collect: #asFloat.
	positions := positions makeLocal asArray collect: #asFloat.
	^{colors. positions}]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendColorsCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetLinePresetBlendCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetLineBlendCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #blend }
GDIPlusLinearGradientBrush >> blendFactors [
	^self blendFactorsAndPositions first]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendFactors: factorsCollection positions: positionsCollection [
	| factors positions |
	factors := BufferArray externalOn: factorsCollection type: ExternalFloat.
	positions := BufferArray
		externalOn: positionsCollection
		type: ExternalFloat.
	status := self dll
		GdipSetLineBlend: self asParameter
		blend: factors asParameter
		positions: positions asParameter
		count: factorsCollection size asParameter.
	self checkStatus.
	factors free.
	positions free]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendFactorsAndPositions [
	| count factors positions |
	count := self blendCount.
	factors := BufferArray externalNew: count of: ExternalFloat.
	positions := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetLineBlend: self asParameter
		blend: factors asParameter
		positions: positions asParameter
		count: count asParameter.
	self checkStatus.
	factors := factors makeLocal asArray collect: #asFloat.
	positions := positions makeLocal asArray collect: #asFloat.
	^{factors. positions}]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendPositions [
	^self blendFactorsAndPositions second]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendTriangularShape: focus [
	self blendTriangularShape: focus scale: 1]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> blendTriangularShape: focus scale: scale [
	| f s |
	f := ExternalFloat from: focus.
	s := ExternalFloat from: scale.
	status := self dll
		GdipSetLineLinearBlend: self asParameter
		focus: f asParameter
		scale: f asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> endColor [
	^self startAndEndColors second]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> gammaCorrection: aBoolean [
	status := self dll
		GdipSetLineGammaCorrection: self asParameter
		useGammaCorrection: aBoolean asParameter.
	self checkStatus]

{ #category : #testing }
GDIPlusLinearGradientBrush >> hasGammaCorrection [
	| gamma |
	gamma := ExternalInt32 external.
	status := self dll
		GdipGetLineGammaCorrection: self asParameter
		useGammaCorrection: gamma asParameter.
	self checkStatus.
	^gamma makeLocal asBoolean]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> multiplyTransform: aGDIPMatrix order: matrixOrder [
	status := self dll
		GdipMultiplyLineTransform: self asParameter
		matrix: aGDIPMatrix asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> rectangle [
	| rectangle |
	rectangle := RectF external.
	status := self dll
		GdipGetLineRect: self asParameter
		rect: rectangle asParameter.
	self checkStatus.
	^rectangle makeLocal asRectangle]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> resetTransform [
	status := self dll GdipResetLineTransform: self asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> rotateTransform: angle [
	self rotateTransform: angle order: nil]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> rotateTransform: angle order: matrixOrder [
	| real |
	real := ExternalFloat from: angle.
	status := self dll
		GdipRotateLineTransform: self asParameter
		angle: real asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> scaleTransform: aPoint [
	self scaleTransform: aPoint x y: aPoint y order: nil]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> scaleTransform: sx y: sy order: matrixOrder [
	| x y |
	x := ExternalFloat from: sx.
	y := ExternalFloat from: sy.
	status := self dll
		GdipScaleLineTransform: self asParameter
		sx: x asParameter
		sy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> startAndEndColors [
	| colors |
	colors := BufferArray externalNew: 2 of: ARGB.
	status := self dll
		GdipGetLineColors: self asParameter
		colors: colors asParameter.
	self checkStatus.
	^colors makeLocal asArray collect: #asColor]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> startColor [
	^self startAndEndColors first]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> startColor: aColor endColor: anotherColor [
	| argb1 argb2 |
	argb1 := ARGB from: aColor.
	argb2 := ARGB from: anotherColor.
	status := self dll
		GdipSetLineColors: self asParameter
		color1: argb1 asParameter
		color2: argb2 asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> transform [
	| matrix |
	matrix := GDIPlusMatrix new.
	status := self dll
		GdipGetLineTransform: self asParameter
		matrix: matrix asParameter.
	self checkStatus.
	^matrix]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> transform: aGDIPlusMatrix [
	status := self dll
		GdipSetLineTransform: self asParameter
		matrix: aGDIPlusMatrix asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> translateTransform: aPoint [
	self translateTransform: aPoint x y: aPoint y order: nil]

{ #category : #transforming }
GDIPlusLinearGradientBrush >> translateTransform: dx y: dy order: matrixOrder [
	| x y |
	x := ExternalFloat from: dx.
	y := ExternalFloat from: dy.
	status := self dll
		GdipTranslateLineTransform: self asParameter
		dx: x asParameter
		dy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> wrapMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll
		GdipGetLineWrapMode: self asParameter
		wrapmode: mode asParameter.
	self checkStatus.
	^mode makeInteger]

{ #category : #accessing }
GDIPlusLinearGradientBrush >> wrapMode: wrapMode [
	status := self dll
		GdipSetLineWrapMode: self asParameter
		wrapmode: wrapMode asParameter.
	self checkStatus]

