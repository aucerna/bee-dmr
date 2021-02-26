"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusBrush,
	#superclass : #GDIPlusObject,
	#category : #GDIPlus
}

{ #category : #private }
GDIPlusBrush >> basicRelease [
	status := self dll GdipDeleteBrush: self asParameter.
	self checkStatus]

{ #category : #copying }
GDIPlusBrush >> clone [
	| pointer |
	pointer := ExternalPointer external.
	status := self dll
		GdipCloneBrush: self asParameter
		cloneBrush: pointer asParameter.
	self checkStatus.
	^self class fromHandle: pointer makeLocal]

{ #category : #testing }
GDIPlusBrush >> isSolidBrush [
	^false]

{ #category : #accessing }
GDIPlusBrush >> type [
	| type |
	type := ExternalPointer external.
	status := self dll
		GdipGetBrushType: self asParameter
		type: type asParameter.
	self checkStatus.
	^type makeLocal asUnsignedInteger]

