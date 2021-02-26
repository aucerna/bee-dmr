"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusHatchBrush,
	#superclass : #GDIPlusBrush,
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusHatchBrush class >> style: hatchStyle foreColor: foreColor [
	^self style: hatchStyle foreColor: foreColor backColor: Color black]

{ #category : #'instance creation' }
GDIPlusHatchBrush class >> style: hatchStyle foreColor: foreColor backColor: backColor [
	| pointer fore back status |
	pointer := ExternalPointer external.
	fore := ARGB from: foreColor.
	back := ARGB from: backColor.
	status := self dll
		GdipCreateHatchBrush: hatchStyle asParameter
		forecol: fore asParameter
		backcol: back asParameter
		brush: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #accessing }
GDIPlusHatchBrush >> backColor [
	| color |
	color := ARGB external.
	status := self dll
		GdipGetHatchBackgroundColor: self asParameter
		backcol: color asParameter.
	self checkStatus.
	^color makeLocal asColor]

{ #category : #accessing }
GDIPlusHatchBrush >> foreColor [
	| color |
	color := ARGB external.
	status := self dll
		GdipGetHatchForegroundColor: self asParameter
		forecol: color asParameter.
	self checkStatus.
	^color makeLocal asColor]

{ #category : #accessing }
GDIPlusHatchBrush >> style [
	| style |
	style := ExternalInt32 external.
	status := self dll GdipGetHatchStyle: self asParameter hatchstyle: style.
	self checkStatus.
	^style makeInteger]

