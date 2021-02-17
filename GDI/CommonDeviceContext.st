"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CommonDeviceContext,
	#superclass : #DeviceContext,
	#instVars : [
		'hWnd'
	],
	#category : #GDI
}

{ #category : #removing }
CommonDeviceContext >> delete [
	self ASSERT: false]

{ #category : #finalization }
CommonDeviceContext >> finalize [
	handle notNil ifTrue: [self release]]

{ #category : #private }
CommonDeviceContext >> forWindow: aWindow [
	handle := aWindow getDC.
	hWnd := aWindow.
	self requireFinalization]

{ #category : #finalization }
CommonDeviceContext >> release [
	| return |
	return := UserDLL current ReleaseDC: hWnd asParameter hDC: handle.
	return = 0 ifTrue: [self winError].
	handle := nil.
	self ignoreFinalization]

