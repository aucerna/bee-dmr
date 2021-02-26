"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusPathGradientBrush,
	#superclass : #GDIPlusBrush,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusPathGradientBrush class >> fromPath: aGDIPlusGraphicsPath [
	| pointer status |
	pointer := ExternalPointer external.
	status := self dll
		GdipCreatePathGradientFromPath: aGDIPlusGraphicsPath asParameter
		polyGradient: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusPathGradientBrush class >> fromPoints: pointsCollection [
	^self fromPoints: pointsCollection wrapMode: WrapModeClamp]

{ #category : #'instance creation' }
GDIPlusPathGradientBrush class >> fromPoints: points wrapMode: wrapMode [
	| pointer buffer status |
	pointer := ExternalPointer external.
	buffer := BufferArray externalOn: points type: POINT.
	status := self dll
		GdipCreatePathGradientI: buffer asParameter
		count: points size
		wrapMode: wrapMode
		polyGradient: pointer asParameter.
	self checkStatus: status.
	buffer free.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusPathGradientBrush class >> radial: radius
center: aPoint
centerColor: aColor
surroundColor: anotherColor [
	| path brush |
	path := GDIPlusGraphicsPath new.
	path addCircle: radius center: aPoint.
	brush := GDIPlusPathGradientBrush fromPath: path.
	brush
		"wrapMode: WrapModeTile;"
		centerColor: aColor;
		centerPoint: aPoint;
		surroundColor: anotherColor.
	^brush]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendBellShape: focus scale: scale [
	| f s |
	f := ExternalFloat from: focus.
	s := ExternalFloat from: scale.
	status := self dll
		GdipSetPathGradientSigmaBlend: self asParameter
		focus: f asParameter
		scale: s asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendColorPositions [
	^self blendColorsAndPositions second]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendColors [
	^self blendColorsAndPositions first]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendColors: colorsCollection positions: positionsCollection [
	| count colors positions |
	self ASSERT: colorsCollection size = positionsCollection size.
	self ASSERT: colorsCollection size >= 2.
	self
		ASSERT: (positionsCollection first = 0 and: [positionsCollection last = 1]).
	count := colorsCollection size.
	colors := BufferArray externalOn: colorsCollection type: ARGB.
	positions := BufferArray
		externalOn: positionsCollection
		type: ExternalFloat.
	status := self dll
		GdipSetPathGradientPresetBlend: self asParameter
		blend: colors asParameter
		positions: positions asParameter
		count: count asParameter.
	self checkStatus.
	colors free.
	positions free]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendColorsAndPositions [
	| count colors positions |
	count := self blendColorsCount.
	colors := BufferArray externalNew: count of: ARGB.
	positions := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetPathGradientPresetBlend: self asParameter
		blend: colors asParameter
		positions: positions asParameter
		count: count asParameter.
	self checkStatus.
	colors := colors makeLocal asArray collect: #asColor.
	positions := positions makeLocal asArray collect: #asFloat.
	^{colors. positions}]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendColorsCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientPresetBlendCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientBlendCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendFactors [
	^self blendFactorsAndPositions first]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendFactors: factorsCollection positions: positionsCollection [
	| factors positions |
	factors := BufferArray externalOn: factorsCollection type: ExternalFloat.
	positions := BufferArray
		externalOn: positionsCollection
		type: ExternalFloat.
	status := self dll
		GdipSetPathGradientBlend: self asParameter
		blend: factors asParameter
		positions: positions asParameter
		count: factorsCollection size asParameter.
	self checkStatus.
	factors free.
	positions free]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendFactorsAndPositions [
	| count factors positions |
	count := self blendCount.
	factors := BufferArray externalNew: count of: ExternalFloat.
	positions := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetPathGradientBlend: self asParameter
		blend: factors asParameter
		positions: positions asParameter
		count: count asParameter.
	self checkStatus.
	factors := factors makeLocal asArray collect: #asFloat.
	positions := positions makeLocal asArray collect: #asFloat.
	^{factors. positions}]

{ #category : #accessing }
GDIPlusPathGradientBrush >> blendPositions [
	^self blendFactorsAndPositions second]

{ #category : #accessing }
GDIPlusPathGradientBrush >> bounds [
	| rectangle |
	rectangle := RectF external.
	status := self dll
		GdipGetPathGradientRect: self asParameter
		rect: rectangle asParameter.
	self checkStatus.
	^rectangle makeLocal asRectangle]

{ #category : #accessing }
GDIPlusPathGradientBrush >> centerColor [
	| color |
	color := ARGB external.
	status := self dll
		GdipGetPathGradientCenterColor: self asParameter
		colors: color asParameter.
	self checkStatus.
	^color makeLocal asColor]

{ #category : #accessing }
GDIPlusPathGradientBrush >> centerColor: aColor [
	| argb |
	argb := ARGB from: aColor.
	status := self dll
		GdipSetPathGradientCenterColor: self asParameter
		colors: argb asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPathGradientBrush >> centerPoint [
	| point |
	point := POINT external.
	status := self dll
		GdipGetPathGradientCenterPointI: self asParameter
		points: point asParameter.
	self checkStatus.
	^point makeLocal asPoint]

{ #category : #accessing }
GDIPlusPathGradientBrush >> centerPoint: aPoint [
	| p |
	p := POINT external fromPoint: aPoint.
	status := self dll
		GdipSetPathGradientCenterPointI: self asParameter
		points: p asParameter.
	self checkStatus.
	p free]

{ #category : #accessing }
GDIPlusPathGradientBrush >> focusScales [
	| x y |
	x := ExternalFloat external.
	y := ExternalFloat external.
	status := self dll
		GdipGetPathGradientFocusScales: self asParameter
		xScale: x asParameter
		yScale: y asParameter.
	self checkStatus.
	^x makeLocal asFloat @ y makeLocal asFloat]

{ #category : #accessing }
GDIPlusPathGradientBrush >> focusScales: aPoint [
	| x y |
	x := ExternalFloat from: aPoint x.
	y := ExternalFloat from: aPoint y.
	status := self dll
		GdipSetPathGradientFocusScales: self asParameter
		xScale: x asParameter
		yScale: y asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPathGradientBrush >> gammaCorrection: aBoolean [
	status := self dll
		GdipSetPathGradientGammaCorrection: self asParameter
		useGammaCorrection: aBoolean asParameter.
	self checkStatus]

{ #category : #testing }
GDIPlusPathGradientBrush >> hasGammaCorrection [
	| gamma |
	gamma := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientGammaCorrection: self asParameter
		useGammaCorrection: gamma asParameter.
	self checkStatus.
	^gamma makeLocal asBoolean]

{ #category : #accessing }
GDIPlusPathGradientBrush >> pointCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientPointCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #transforming }
GDIPlusPathGradientBrush >> resetTransform [
	status := self dll GdipResetPathGradientTransform: self asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusPathGradientBrush >> rotateTransform: angle [
	self rotateTransform: angle order: nil]

{ #category : #transforming }
GDIPlusPathGradientBrush >> rotateTransform: angle order: matrixOrder [
	| real |
	real := ExternalFloat from: angle.
	status := self dll
		GdipRotatePathGradientTransform: self asParameter
		angle: real asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusPathGradientBrush >> scaleTransform: aPoint [
	self scaleTransform: aPoint x y: aPoint y order: nil]

{ #category : #transforming }
GDIPlusPathGradientBrush >> scaleTransform: sx y: sy order: matrixOrder [
	| x y |
	x := ExternalFloat from: sx.
	y := ExternalFloat from: sy.
	status := self dll
		GdipScalePathGradientTransform: self asParameter
		sx: x asParameter
		sy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPathGradientBrush >> surroundColor: aColor [
	| colors |
	colors := Array new: self pointCount withAll: aColor asARGBColor.
	self surroundColors: colors]

{ #category : #accessing }
GDIPlusPathGradientBrush >> surroundColors [
	| n colors count |
	n := self surroundColorsCount.
	colors := BufferArray externalNew: n of: ARGB.
	count := ExternalInt32 external fromInteger: n.
	status := self dll
		GdipGetPathGradientSurroundColorsWithCount: self asParameter
		color: colors asParameter
		count: count asParameter.
	self checkStatus.
	self ASSERT: count asInteger = n.
	count free.
	^colors makeLocal asArray collect: #asColor]

{ #category : #accessing }
GDIPlusPathGradientBrush >> surroundColors: aCollection [
	| colors count buffer |
	colors := aCollection collect: [:color | ARGB from: color].
	count := colors size asExternalInt32 externalCopy.
	buffer := BufferArray externalOn: colors type: ARGB.
	status := self dll
		GdipSetPathGradientSurroundColorsWithCount: self asParameter
		color: buffer asParameter
		count: count asParameter.
	self checkStatus.
	buffer free.
	count free]

{ #category : #accessing }
GDIPlusPathGradientBrush >> surroundColorsCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientSurroundColorCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #transforming }
GDIPlusPathGradientBrush >> transform [
	| matrix |
	matrix := GDIPlusMatrix new.
	status := self dll
		GdipGetPathGradientTransform: self asParameter
		matrix: matrix asParameter.
	self checkStatus.
	^matrix]

{ #category : #transforming }
GDIPlusPathGradientBrush >> transform: aGDIPlusMatrix [
	status := self dll
		GdipSetPathGradientTransform: self asParameter
		matrix: aGDIPlusMatrix asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusPathGradientBrush >> translateTransform: aPoint [
	self translateTransform: aPoint x y: aPoint y order: nil]

{ #category : #transforming }
GDIPlusPathGradientBrush >> translateTransform: dx y: dy order: matrixOrder [
	| x y |
	x := ExternalFloat from: dx.
	y := ExternalFloat from: dy.
	status := self dll
		GdipTranslatePathGradientTransform: self asParameter
		dx: x asParameter
		dy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPathGradientBrush >> wrapMode [
	| mode |
	mode := ExternalInt32 external.
	status := self dll
		GdipGetPathGradientWrapMode: self asParameter
		wrapmode: mode asParameter.
	self checkStatus.
	^mode makeInteger]

{ #category : #accessing }
GDIPlusPathGradientBrush >> wrapMode: wrapMode [
	status := self dll
		GdipSetPathGradientWrapMode: self asParameter
		wrapmode: wrapMode asParameter.
	self checkStatus]

