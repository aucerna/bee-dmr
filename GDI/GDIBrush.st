"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIBrush,
	#superclass : #GDILogicalObject,
	#instVars : [
		'style',
		'color',
		'hatch'
	],
	#category : #GDI
}

{ #category : #initialization }
GDIBrush class >> default [
	^self stockObject: WHITE_BRUSH]

{ #category : #accessing }
GDIBrush class >> structClass [
	^LOGBRUSH]

{ #category : #accessing }
GDIBrush class >> threshold [
	^1024]

{ #category : #'instance creation' }
GDIBrush class >> withStyle: anInteger color: aColor [
	^self withStyle: anInteger color: aColor hatch: nil]

{ #category : #'instance creation' }
GDIBrush class >> withStyle: anInteger color: aColor hatch: anotherInteger [
	| style color hash |
	style := anInteger ifNil: BS_SOLID.
	color := aColor ifNil: [Color white].
	hash := anotherInteger ifNil: [HS_HORIZONTAL].
	^self new
		style: style color: color asInteger hatch: hash;
		createObject]

{ #category : #accessing }
GDIBrush >> color [
	^color]

{ #category : #private }
GDIBrush >> create [
	| struct ulong |
	stockObject notNil ifTrue: [^self class stockObject: stockObject].
	struct := LOGBRUSH external
		style: style;
		color: color asParameter;
		hatch: hatch.
	ulong := GDILibrary CreateBrushIndirect: struct asParameter.
	ulong = 0 ifTrue: [^self winError].
	struct free.
	^ulong]

{ #category : #private }
GDIBrush >> fromStruct: aLOGBRUSH [
	style := aLOGBRUSH style.
	color := aLOGBRUSH color.
	hatch := aLOGBRUSH hatch.
	handle isNil ifTrue: [self createObject]]

{ #category : #accessing }
GDIBrush >> rgbColor [
	^RGBColor fromInteger: color]

{ #category : #accessing }
GDIBrush >> style: aStyle color: aColor hatch: anInteger [
	self ASSERT: handle isNil.
	style := aStyle.
	color := aColor.
	hatch := anInteger]

