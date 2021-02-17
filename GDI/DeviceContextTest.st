"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DeviceContextTest,
	#superclass : #TestCase,
	#category : #GDI
}

{ #category : #all }
DeviceContextTest >> testCurrentFont [
	| font |
	font := DeviceContext forDisplay currentFont.
	self assert: (font class name endsWith: 'Font')]

{ #category : #services }
DeviceContextTest >> testEnumDisplays [
	| displays |
	displays := DeviceContext displayDevices.
	self assert: (displays anySatisfy: [:struct | struct isDesktop])]

{ #category : #all }
DeviceContextTest >> testTP7332 [
	self
		assert: VirtualScreen current deviceContext pixelsPerInch
			* VirtualScreen current deviceContext inchSize
			~ Screen current extent]

