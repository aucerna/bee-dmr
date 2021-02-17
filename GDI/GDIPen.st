"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPen,
	#superclass : #GDILogicalObject,
	#instVars : [
		'style',
		'width',
		'color'
	],
	#category : #GDI
}

{ #category : #'instance creation' }
GDIPen class >> default [
	^self stockObject: BLACK_PEN]

{ #category : #accessing }
GDIPen class >> structClass [
	^LOGPEN]

{ #category : #accessing }
GDIPen class >> threshold [
	^1024]

{ #category : #'instance creation' }
GDIPen class >> withStyle: anInteger color: aColor width: anotherInteger [
	| style color width |
	style := anInteger ifNil: PS_SOLID.
	color := aColor ifNil: [Color black].
	width := anotherInteger ifNil: 0.
	^self new
		style: style color: color width: width;
		createObject]

{ #category : #accessing }
GDIPen >> color [
	^color]

{ #category : #private }
GDIPen >> create [
	| ulong |
	stockObject notNil ifTrue: [^self class stockObject: stockObject].
	ulong := GDILibrary
		CreatePen: style
		nWidth: width
		crColor: color asParameter.
	ulong = 0 ifTrue: [^self winError].
	^ulong]

{ #category : #private }
GDIPen >> fromStruct: aLOGPEN [
	style := aLOGPEN style.
	color := aLOGPEN color.
	width := aLOGPEN width.
	handle isNil ifTrue: [self createObject]]

{ #category : #accessing }
GDIPen >> style [
	^style]

{ #category : #accessing }
GDIPen >> style: aStyle color: aColor width: anInteger [
	style := aStyle.
	color := aColor.
	width := anInteger]

{ #category : #accessing }
GDIPen >> width [
	^width]

