"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusPen,
	#superclass : #GDIPlusObject,
	#instVars : [
		'color',
		'width',
		'style'
	],
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusPen class >> black [
	^self color: ARGBColor black]

{ #category : #'instance creation' }
GDIPlusPen class >> blue [
	^self color: ARGBColor blue]

{ #category : #'instance creation' }
GDIPlusPen class >> brush: aGDIPBrush width: width [
	^self brush: aGDIPBrush width: width unit: UnitPixel]

{ #category : #'instance creation' }
GDIPlusPen class >> brush: aGDIPBrush width: width unit: unit [
	| pointer w status |
	pointer := ExternalPointer external.
	w := width notNil ifTrue: [ExternalFloat from: width].
	status := self dll
		GdipCreatePen2: aGDIPBrush asParameter
		width: w asParameter
		unit: unit
		pen: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusPen class >> color: anARGBColor [
	^self color: anARGBColor width: 1]

{ #category : #'instance creation' }
GDIPlusPen class >> color: color width: width [
	^self color: color width: width unit: UnitPixel]

{ #category : #'instance creation' }
GDIPlusPen class >> color: color width: width unit: unit [
	| pointer status argb w |
	pointer := ExternalPointer external.
	argb := ARGB from: color.
	w := width notNil ifTrue: [ExternalFloat from: width].
	status := self dll
		GdipCreatePen1: argb asParameter
		width: w asParameter
		unit: unit asParameter
		pen: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusPen class >> green [
	^self color: ARGBColor green]

{ #category : #'instance creation' }
GDIPlusPen class >> new [
	^self black]

{ #category : #'instance creation' }
GDIPlusPen class >> red [
	^self color: ARGBColor red]

{ #category : #aligning }
GDIPlusPen >> alignCenter [
	self alignment: PenAlignmentCenter]

{ #category : #aligning }
GDIPlusPen >> alignInset [
	self alignment: PenAlignmentInset]

{ #category : #aligning }
GDIPlusPen >> alignment [
	| alignment |
	alignment := ExternalInt32 external.
	status := self dll
		GdipGetPenMode: self asParameter
		penMode: alignment asParameter.
	self checkStatus.
	^alignment makeLocal asUnsignedInteger]

{ #category : #aligning }
GDIPlusPen >> alignment: alignmentMode [
	status := self dll GdipSetPenMode: self asParameter penMode: alignmentMode.
	self checkStatus]

{ #category : #private }
GDIPlusPen >> basicRelease [
	status := self dll GdipDeletePen: self asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> bevelLineJoin [
	self lineJoin: LineJoinBevel]

{ #category : #brushes }
GDIPlusPen >> brush [
	| class brush |
	class := self brushClass.
	class isNil ifTrue: [^nil].
	brush := ExternalPointer external.
	status := self dll
		GdipGetPenBrushFill: self asParameter
		brush: brush asParameter.
	self checkStatus.
	^class fromHandle: brush makeLocal]

{ #category : #brushes }
GDIPlusPen >> brush: aGDIPBrush [
	status := self dll
		GdipSetPenBrushFill: self asParameter
		brush: aGDIPBrush asParameter.
	self checkStatus]

{ #category : #brushes }
GDIPlusPen >> brushClass [
	| type |
	type := self penType.
	type = PenTypeSolidColor ifTrue: [^GDIPlusSolidBrush].
	type = PenTypeHatchFill ifTrue: [^GDIPlusHatchBrush].
	type = PenTypeTextureFill ifTrue: [^GDIPlusTextureBrush].
	type = PenTypePathGradient ifTrue: [^GDIPlusPathGradientBrush].
	type = PenTypeLinearGradient ifTrue: [^GDIPlusLinearGradientBrush].
	^nil]

{ #category : #copying }
GDIPlusPen >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipClonePen: self asParameter
		clonepen: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusPen >> color [
	| argb |
	color notNil ifTrue: [^color].
	argb := ARGB external.
	status := self dll GdipGetPenColor: self asParameter argb: argb asParameter.
	self checkStatus.
	color := argb makeLocal asColor.
	^color]

{ #category : #accessing }
GDIPlusPen >> color: aColor [
	| argb |
	color = aColor ifTrue: [^self].
	argb := ARGB from: aColor.
	status := self dll GdipSetPenColor: self asParameter argb: argb asParameter.
	self checkStatus.
	color := aColor]

{ #category : #accessing }
GDIPlusPen >> compoundArray [
	| array count |
	count := self compoundArrayCount.
	array := BufferArray externalNew: count of: ExternalFloat.
	array := array externalCopy.
	status := self dll
		GdipGetPenCompoundArray: self asParameter
		dash: array asParameter
		count: count.
	self checkStatus.
	^array makeLocal asArray collect: #asFloat]

{ #category : #accessing }
GDIPlusPen >> compoundArray: compoundArray [
	| array |
	self ASSERT: compoundArray size >= 2.
	self ASSERT: (compoundArray conform: [:each | each between: 0.0 and: 1.0]).
	self ASSERT: (compoundArray first = 0.0 and: [compoundArray last = 1.0]).
	array := BufferArray externalOn: compoundArray type: ExternalFloat.
	status := self dll
		GdipSetPenCompoundArray: self asParameter
		dash: array asParameter
		count: compoundArray size.
	self checkStatus.
	array free]

{ #category : #accessing }
GDIPlusPen >> compoundArrayCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPenCompoundCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #caps }
GDIPlusPen >> customEndCap [
	| cap |
	cap := ExternalPointer external.
	status := self dll
		GdipGetPenCustomEndCap: self asParameter
		customCap: cap asParameter.
	self checkStatus.
	^GDIPlusCustomLineCap fromHandle: cap makeLocal]

{ #category : #caps }
GDIPlusPen >> customEndCap: aGDIPCustonLineCap [
	status := self dll
		GdipSetPenCustomEndCap: self asParameter
		customCap: aGDIPCustonLineCap asParameter.
	self checkStatus]

{ #category : #caps }
GDIPlusPen >> customStartCap [
	| cap |
	cap := ExternalPointer external.
	status := self dll
		GdipGetPenCustomStartCap: self asParameter
		customCap: cap asParameter.
	self checkStatus.
	^GDIPlusCustomLineCap fromHandle: cap makeLocal]

{ #category : #caps }
GDIPlusPen >> customStartCap: aGDIPCustonLineCap [
	status := self dll
		GdipSetPenCustomStartCap: self asParameter
		customCap: aGDIPCustonLineCap asParameter.
	self checkStatus]

{ #category : #caps }
GDIPlusPen >> dashCap [
	| cap |
	cap := ExternalInt32 external.
	status := self dll
		GdipGetPenDashCap197819: self asParameter
		dashCap: cap asParameter.
	self checkStatus.
	^cap makeLocal asUnsignedInteger]

{ #category : #caps }
GDIPlusPen >> dashCap: dashCap [
	status := self dll
		GdipSetPenDashCap197819: self asParameter
		dashCap: dashCap.
	self checkStatus]

{ #category : #dashes }
GDIPlusPen >> dashOffset [
	| offset |
	offset := ExternalFloat external.
	status := self dll
		GdipGetPenDashOffset: self asParameter
		offset: offset asParameter.
	self checkStatus.
	^offset makeLocal asFloat]

{ #category : #dashes }
GDIPlusPen >> dashOffset: dashOffset [
	| offset |
	offset := ExternalFloat from: dashOffset.
	status := self dll
		GdipSetPenDashOffset: self asParameter
		offset: offset asParameter.
	self checkStatus]

{ #category : #dashes }
GDIPlusPen >> dashPattern [
	| count pattern |
	count := self dashPatternCount.
	pattern := BufferArray externalNew: count of: ExternalFloat.
	status := self dll
		GdipGetPenDashArray: self asParameter
		dash: pattern asParameter
		count: count.
	self checkStatus.
	^pattern makeLocal asArray collect: #asFloat]

{ #category : #dashes }
GDIPlusPen >> dashPattern: anArray [
	| pattern |
	pattern := BufferArray externalOn: anArray type: ExternalFloat.
	status := self dll
		GdipSetPenDashArray: self asParameter
		dash: pattern asParameter
		count: anArray size.
	self checkStatus.
	pattern free]

{ #category : #dashes }
GDIPlusPen >> dashPatternCount [
	| count |
	count := ExternalInt32 external.
	status := self dll
		GdipGetPenDashCount: self asParameter
		count: count asParameter.
	self checkStatus.
	^count makeInteger]

{ #category : #dashes }
GDIPlusPen >> dashStyle [
	| long |
	style notNil ifTrue: [^style].
	long := ExternalInt32 external.
	status := self dll
		GdipGetPenDashStyle: self asParameter
		dashstyle: long asParameter.
	self checkStatus.
	^style := long makeLocal asUnsignedInteger]

{ #category : #dashes }
GDIPlusPen >> dashStyle: anInteger [
	style = anInteger ifTrue: [^self].
	status := self dll
		GdipSetPenDashStyle: self asParameter
		dashstyle: anInteger.
	self checkStatus.
	style := anInteger]

{ #category : #caps }
GDIPlusPen >> endCap [
	| cap |
	cap := ExternalInt32 external.
	status := self dll
		GdipGetPenEndCap: self asParameter
		endCap: cap asParameter.
	self checkStatus.
	^cap makeLocal asUnsignedInteger]

{ #category : #caps }
GDIPlusPen >> endCap: cap [
	status := self dll
		GdipSetPenEndCap: self asParameter
		endCap: cap asParameter.
	self checkStatus]

{ #category : #caps }
GDIPlusPen >> lineCap: startCap endCap: endCap dashCap: dashCap [
	status := self dll
		GdipSetPenLineCap197819: self asParameter
		startCap: startCap asParameter
		endCap: endCap asParameter
		dashCap: dashCap asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> lineJoin [
	| join |
	join := ExternalInt32 external.
	status := self dll
		GdipGetPenLineJoin: self asParameter
		lineJoin: join asParameter.
	self checkStatus.
	^join makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusPen >> lineJoin: lineJoin [
	status := self dll
		GdipSetPenLineJoin: self asParameter
		lineJoin: lineJoin asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> miterClippedLineJoin [
	self lineJoin: LineJoinMiterClipped]

{ #category : #accessing }
GDIPlusPen >> miterLimit [
	| limit |
	limit := ExternalFloat external.
	status := self dll
		GdipGetPenMiterLimit: self asParameter
		miterLimit: limit asParameter.
	self checkStatus.
	^limit makeLocal asFloat]

{ #category : #accessing }
GDIPlusPen >> miterLimit: miterLimit [
	| limit |
	limit := ExternalFloat from: miterLimit.
	status := self dll
		GdipSetPenMiterLimit: self asParameter
		miterLimit: limit asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> miterLineJoin [
	self lineJoin: LineJoinMiter]

{ #category : #transforming }
GDIPlusPen >> multiplyTransform: aGDIPMatrix order: matrixOrder [
	status := self dll
		GdipMultiplyPenTransform: self asParameter
		matrix: aGDIPMatrix asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> penType [
	| type |
	type := ExternalInt32 external.
	status := self dll
		GdipGetPenFillType: self asParameter
		type: type asParameter.
	self checkStatus.
	^type makeLocal asUnsignedInteger]

{ #category : #transforming }
GDIPlusPen >> resetTransform [
	status := self dll GdipResetPenTransform: self asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusPen >> rotateTransform: angle order: matrixOrder [
	| real |
	real := ExternalFloat from: angle.
	status := self dll
		GdipRotatePenTransform: self asParameter
		angle: real asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> roundLineJoin [
	self lineJoin: LineJoinRound]

{ #category : #transforming }
GDIPlusPen >> scaleTransform: sx y: sy order: matrixOrder [
	| x y |
	x := ExternalFloat from: sx.
	y := ExternalFloat from: sy.
	status := self dll
		GdipScalePenTransform: self asParameter
		sx: x asParameter
		sy: y asParameter
		order: matrixOrder asParameter.
	self checkStatus]

{ #category : #caps }
GDIPlusPen >> startCap [
	| cap |
	cap := ExternalInt32 external.
	status := self dll
		GdipGetPenStartCap: self asParameter
		startCap: cap asParameter.
	self checkStatus.
	^cap makeLocal asUnsignedInteger]

{ #category : #caps }
GDIPlusPen >> startCap: cap [
	status := self dll
		GdipSetPenStartCap: self asParameter
		startCap: cap asParameter.
	self checkStatus]

{ #category : #transforming }
GDIPlusPen >> transform [
	| matrix |
	matrix := GDIPlusMatrix new.
	status := self dll
		GdipGetPenTransform: self asParameter
		matrix: matrix asParameter.
	self checkStatus.
	^matrix]

{ #category : #transforming }
GDIPlusPen >> transform: aGDIPMatrix [
	status := self dll
		GdipSetPenTransform: self asParameter
		matrix: aGDIPMatrix asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusPen >> width [
	| real |
	width notNil ifTrue: [^width].
	real := ExternalFloat external.
	status := self dll
		GdipGetPenWidth: self asParameter
		width: real asParameter.
	self checkStatus.
	width := real makeLocal asFloat.
	^width]

{ #category : #accessing }
GDIPlusPen >> width: aNumber [
	| real |
	width = aNumber ifTrue: [^self].
	real := ExternalFloat fromFloat: aNumber asFloat.
	status := self dll
		GdipSetPenWidth: self asParameter
		width: real asParameter.
	self checkStatus.
	width := aNumber]

