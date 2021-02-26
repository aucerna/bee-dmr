"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusAdjustableArrowCap,
	#superclass : #GDIPlusCustomLineCap,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusAdjustableArrowCap class >> height: height width: width filler: isFilled [
	| pointer h w status |
	pointer := ExternalPointer external.
	h := RECT from: height.
	w := RECT from: width.
	status := self dll
		GdipCreateAdjustableArrowCap: h asParameter
		width: w asParameter
		isFilled: isFilled asParameter
		cap: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> filled: aBoolean [
	status := self dll
		GdipSetAdjustableArrowCapFillState: self asParameter
		fillState: aBoolean asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> height [
	| height |
	height := ExternalFloat external.
	status := self dll
		GdipGetAdjustableArrowCapHeight: self asParameter
		height: height asParameter.
	self checkStatus.
	^height makeLocal asFloat]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> height: height [
	| h |
	h := ExternalFloat from: height.
	status := self dll
		GdipSetAdjustableArrowCapHeight: self asParameter
		height: h asParameter.
	self checkStatus]

{ #category : #testing }
GDIPlusAdjustableArrowCap >> isFilled [
	| state |
	state := ExternalInt32 external.
	status := self dll
		GdipGetAdjustableArrowCapFillState: self asParameter
		fillState: state asParameter.
	self checkStatus.
	^state makeLocal asBoolean]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> middleInset [
	| inset |
	inset := ExternalFloat external.
	status := self dll
		GdipGetAdjustableArrowCapMiddleInset: self asParameter
		middleInset: inset asParameter.
	self checkStatus.
	^inset makeLocal asFloat]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> middleInset: inset [
	| real |
	real := ExternalFloat from: inset.
	status := self dll
		GdipSetAdjustableArrowCapMiddleInset: self asParameter
		middleInset: real asParameter.
	self checkStatus]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> width [
	| width |
	width := ExternalFloat external.
	status := self dll
		GdipGetAdjustableArrowCapWidth: self asParameter
		width: width asParameter.
	self checkStatus.
	^width makeLocal asFloat]

{ #category : #accessing }
GDIPlusAdjustableArrowCap >> width: width [
	| real |
	real := ExternalFloat from: width.
	status := self dll
		GdipSetAdjustableArrowCapWidth: self asParameter
		width: real asParameter.
	self checkStatus]

