"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIPlusSolidBrush,
	#superclass : #GDIPlusBrush,
	#instVars : [
		'color'
	],
	#category : #GDIPlus
}

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> black [
	^self color: ARGBColor black]

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> blue [
	^self color: ARGBColor blue]

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> color: aColor [
	| argb pointer status |
	argb := ARGB from: aColor.
	pointer := ExternalPointer external.
	status := self dll
		GdipCreateSolidFill: argb asParameter
		brush: pointer asParameter.
	self checkStatus: status.
	^self fromHandle: pointer makeLocal]

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> green [
	^self color: ARGBColor green]

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> new [
	^self black]

{ #category : #'instance creation' }
GDIPlusSolidBrush class >> red [
	^self color: ARGBColor red]

{ #category : #accessing }
GDIPlusSolidBrush >> color [
	| argb |
	color notNil ifTrue: [^color].
	argb := ARGB external.
	status := self dll
		GdipGetSolidFillColor: self asParameter
		color: argb asParameter.
	self checkStatus.
	^color := argb makeLocal asColor]

{ #category : #accessing }
GDIPlusSolidBrush >> color: aColor [
	| argb |
	color = aColor ifTrue: [^self].
	argb := ARGB from: aColor.
	status := self dll
		GdipSetSolidFillColor: self asParameter
		color: argb asParameter.
	self checkStatus.
	color := aColor]

{ #category : #testing }
GDIPlusSolidBrush >> isSolidBrush [
	^true]

