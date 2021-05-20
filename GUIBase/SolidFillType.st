"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SolidFillType,
	#superclass : #BrushFillType,
	#instVars : [
		'color'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
SolidFillType class >> color: aColor [
	^self new color: aColor]

{ #category : #private }
SolidFillType class >> fromSelector [
	^#fromSolid:]

{ #category : #accessing }
SolidFillType >> color [
	^color]

{ #category : #accessing }
SolidFillType >> color: aColor [
	| previous |
	previous := color.
	color := aColor asARGBColor.
	(color != previous
		and: [owner notNil]
		and: [owner respondsTo: #solidColorChangedFrom:to:])
		ifTrue: [owner solidColorChangedFrom: previous to: color]]

{ #category : #converting }
SolidFillType >> fromHatch: aHatchFillType [
	self color: aHatchFillType foreColor]

{ #category : #converting }
SolidFillType >> fromLinearGradient: aLinearGradientFillType [
	self color: aLinearGradientFillType startColor]

{ #category : #converting }
SolidFillType >> fromRadialGradient: aRadialGradientFillType [
	self color: aRadialGradientFillType startColor]

{ #category : #accessing }
SolidFillType >> fromSolid: aSolidFillType [
	^self color: aSolidFillType color]

{ #category : #services }
SolidFillType >> highlighted [
	^self copy color: color muchLighter]

{ #category : #initialization }
SolidFillType >> initialize [
	super initialize.
	color := Color blue asARGBColor]

{ #category : #testing }
SolidFillType >> isLike: aBrushFillType [
	^aBrushFillType isSolid and: [color equals: aBrushFillType color]]

{ #category : #testing }
SolidFillType >> isSolid [
	^true]

{ #category : #copying }
SolidFillType >> postCopy [
	super postCopy.
	color := color copy]

{ #category : #services }
SolidFillType >> replaceColor: aColor with: anotherColor [
	(color equals: aColor) ifTrue: [color := anotherColor asARGBColor]]

{ #category : #accessing }
SolidFillType >> transparency [
	^color transparency]

{ #category : #accessing }
SolidFillType >> transparency: percent [
	color transparency: percent]

