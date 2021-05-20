"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HatchFillType,
	#superclass : #BrushFillType,
	#instVars : [
		'style',
		'foreColor',
		'backColor'
	],
	#category : #GUIbase
}

{ #category : #private }
HatchFillType class >> fromSelector [
	^#fromHatch:]

{ #category : #'instance creation' }
HatchFillType class >> style: aSymbol foreColor: aColor backColor: anotherColor [
	^self new style: aSymbol foreColor: aColor backColor: anotherColor]

{ #category : #accessing }
HatchFillType >> backColor [
	^backColor]

{ #category : #accessing }
HatchFillType >> backColor: aColor [
	backColor := aColor asARGBColor]

{ #category : #accessing }
HatchFillType >> color [
	^self foreColor]

{ #category : #accessing }
HatchFillType >> color: aColor [
	self foreColor: aColor]

{ #category : #accessing }
HatchFillType >> foreColor [
	^foreColor]

{ #category : #accessing }
HatchFillType >> foreColor: aColor [
	foreColor := aColor asARGBColor]

{ #category : #converting }
HatchFillType >> fromHatch: aHatchFillType [
	^self
		style: aHatchFillType style;
		foreColor: aHatchFillType foreColor;
		backColor: aHatchFillType backColor]

{ #category : #converting }
HatchFillType >> fromLinearGradient: aLinearGradientFillType [
	| s |
	self foreColor: aLinearGradientFillType startColor.
	s := aLinearGradientFillType style.
	(self styles includes: s) ifTrue: [self style: s]]

{ #category : #converting }
HatchFillType >> fromSolid: aSolidFillType [
	^self foreColor: aSolidFillType color]

{ #category : #services }
HatchFillType >> highlighted [
	^self copy
		foreColor: foreColor muchDarker;
		backColor: backColor muchLighter]

{ #category : #initialization }
HatchFillType >> initialize [
	super initialize.
	style := self styles anyone.
	foreColor := Color darkGray asARGBColor.
	backColor := ARGBColor
		alpha: 0
		red: 255
		green: 255
		blue: 255]

{ #category : #testing }
HatchFillType >> isHatch [
	^true]

{ #category : #testing }
HatchFillType >> isLike: aBrushFillType [
	^aBrushFillType isHatch
		and: [style = aBrushFillType style]
		and: [foreColor equals: aBrushFillType foreColor]
		and: [backColor equals: aBrushFillType backColor]]

{ #category : #copying }
HatchFillType >> postCopy [
	super postCopy.
	foreColor := foreColor copy.
	backColor := backColor copy]

{ #category : #services }
HatchFillType >> replaceColor: aColor with: anotherColor [
	(foreColor equals: aColor) ifTrue: [foreColor := anotherColor asARGBColor].
	(backColor equals: aColor) ifTrue: [backColor := anotherColor asARGBColor]]

{ #category : #accessing }
HatchFillType >> style [
	^style]

{ #category : #accessing }
HatchFillType >> style: aSymbol [
	self ASSERT: (self styles includes: aSymbol).
	style := aSymbol]

{ #category : #accessing }
HatchFillType >> styles [
	^#(#horizontal #vertical #cross #diagcross #bdiagonal #fdiagonal)]

{ #category : #accessing }
HatchFillType >> transparency: percent [
	foreColor transparency: percent.
	backColor transparency: percent]

