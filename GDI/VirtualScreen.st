"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #VirtualScreen,
	#superclass : #Screen,
	#category : #GDI
}

{ #category : #'instance creation' }
VirtualScreen class >> current [
	^current]

{ #category : #initialization }
VirtualScreen class >> initialize [
	current := self new]

{ #category : #accessing }
VirtualScreen >> dpi [
	^dpi ifNil: [dpi := UserDLL current systemDpi]]

{ #category : #initialization }
VirtualScreen >> initialize [
	super initialize.
	self reinitialize]

{ #category : #initialization }
VirtualScreen >> initializeBounds [
	| w h os |
	w := self systemMetric: SM_CXVIRTUALSCREEN.
	h := self systemMetric: SM_CYVIRTUALSCREEN.
	bounds := 0 @ 0 extent: w @ h]

{ #category : #initialization }
VirtualScreen >> initializeWorkingArea [
	| rect success |
	rect := RECT external.
	success := UserDLL current
		SystemParametersInfoW: SPI_GETWORKAREA
		uiParam: 0
		pvParam: rect asParameter
		fWinIni: 0.
	success = 0 ifTrue: [self winError].
	workingArea := rect makeLocal asRectangle]

{ #category : #accessing }
VirtualScreen >> monitorHandle: anInteger [
	self shouldNotImplement]

{ #category : #initialization }
VirtualScreen >> reinitialize [
	dc := DeviceContext createDC: 'DISPLAY' device: nil.
	self initializeBounds; initializeWorkingArea]

