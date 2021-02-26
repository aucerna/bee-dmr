"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusCustomLineCap,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusCustomLineCap class >> fillPath: fillPath
strokePath: strokePath
baseCap: baseCap
baseInset: baseInset [
	| pointer inset status |
	pointer := ExternalPointer external.
	inset := ExternalFloat from: baseInset.
	status := self dll
		GdipCreateCustomLineCap: fillPath asParameter
		strokePath: strokePath asParameter
		baseCap: baseCap
		baseInset: inset asParameter
		customCap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusCustomLineCap class >> new [
	^self strokePath: GDIPlusGraphicsPath new]

{ #category : #'instance creation' }
GDIPlusCustomLineCap class >> strokePath: aStrokePath [
	^self
		fillPath: nil
		strokePath: aStrokePath
		baseCap: LineCapFlat
		baseInset: 0]

{ #category : #accessing }
GDIPlusCustomLineCap >> baseCap [
	| cap |
	cap := ExternalInt32 external.
	status := self dll
		GdipGetCustomLineCapBaseCap: self asParameter
		baseCap: cap asParameter.
	self checkStatus.
	^cap makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusCustomLineCap >> baseCap: anInteger [
	status := self dll
		GdipSetCustomLineCapBaseCap: self asParameter
		baseCap: anInteger asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusCustomLineCap >> baseInset [
	| inset |
	inset := ExternalFloat external.
	status := self dll
		GdipGetCustomLineCapBaseInset: self asParameter
		inset: inset asParameter.
	self checkStatus.
	^inset makeLocal asFloat]

{ #category : #accessing }
GDIPlusCustomLineCap >> baseInset: aNumber [
	| inset |
	inset := ExternalFloat from: aNumber.
	status := self dll
		GdipSetCustomLineCapBaseInset: self asParameter
		inset: inset asParameter.
	self checkStatus]

{ #category : #private }
GDIPlusCustomLineCap >> basicRelease [
	status := self dll GdipDeleteCustomLineCap: self asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusCustomLineCap >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneCustomLineCap: self asParameter
		clonedCap: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusCustomLineCap >> endCap [
	^self startEndCap at: 2]

{ #category : #accessing }
GDIPlusCustomLineCap >> startCap [
	^self startEndCap at: 1]

{ #category : #accessing }
GDIPlusCustomLineCap >> startCap: startCap endCap: endCap [
	status := self dll
		GdipSetCustomLineCapStrokeCaps: self asParameter
		startCap: startCap asParameter
		endCap: endCap asParameter.
	self checkStatus]

{ #category : #private }
GDIPlusCustomLineCap >> startEndCap [
	| start end |
	start := ExternalInt32 external.
	end := ExternalInt32 external.
	status := self dll
		GdipGetCustomLineCapStrokeCaps: self asParameter
		startCap: start asParameter
		endCap: end asParameter.
	self checkStatus.
	^{start makeLocal asUnsignedInteger. end makeLocal asUnsignedInteger}]

{ #category : #accessing }
GDIPlusCustomLineCap >> strokeJoin [
	| style |
	style := ExternalInt32 external.
	status := self dll
		GdipGetCustomLineCapStrokeJoin: self asParameter
		lineJoin: style asParameter.
	self checkStatus.
	^style makeLocal asUnsignedInteger]

{ #category : #accessing }
GDIPlusCustomLineCap >> strokeJoin: anInteger [
	status := self dll
		GdipSetCustomLineCapStrokeJoin: self asParameter
		lineJoin: anInteger asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusCustomLineCap >> widthScale [
	| width |
	width := ExternalFloat external.
	status := self dll
		GdipGetCustomLineCapWidthScale: self asParameter
		widthScale: width asParameter.
	self checkStatus.
	^width makeLocal asFloat]

{ #category : #accessing }
GDIPlusCustomLineCap >> widthScale: scale [
	| real |
	real := ExternalFloat from: scale.
	status := self dll
		GdipSetCustomLineCapWidthScale: self asParameter
		widthScale: real asParameter.
	self checkStatus]

