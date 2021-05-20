"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GradientFillType,
	#superclass : #BrushFillType,
	#instVars : [
		'startColor',
		'endColor'
	],
	#category : #GUIbase
}

{ #category : #services }
GradientFillType >> averageColor [
	^startColor averageWith: endColor]

{ #category : #accessing }
GradientFillType >> color [
	^self endColor]

{ #category : #accessing }
GradientFillType >> color: aColor [
	self startColor: Color white; endColor: aColor]

{ #category : #accessing }
GradientFillType >> endColor [
	^endColor]

{ #category : #accessing }
GradientFillType >> endColor: aColor [
	endColor := aColor asARGBColor]

{ #category : #converting }
GradientFillType >> fromGradient: aGradientFillType [
	self
		startColor: aGradientFillType startColor;
		endColor: aGradientFillType endColor]

{ #category : #converting }
GradientFillType >> fromLinearGradient: aLinearGradientFillType [
	self fromGradient: aLinearGradientFillType]

{ #category : #converting }
GradientFillType >> fromPathGradient: aPathGradientFillType [
	self fromGradient: aPathGradientFillType]

{ #category : #converting }
GradientFillType >> fromRadialGradient: aRadialGradientFillType [
	self fromGradient: aRadialGradientFillType]

{ #category : #converting }
GradientFillType >> fromSolid: aSolidFillType [
	self color: aSolidFillType color]

{ #category : #services }
GradientFillType >> highlighted [
	^self copy
		startColor: startColor muchLighter;
		endColor: endColor muchLighter]

{ #category : #initialization }
GradientFillType >> initialize [
	super initialize.
	startColor := Color green muchDarker asARGBColor.
	endColor := Color green muchLighter asARGBColor]

{ #category : #testing }
GradientFillType >> isGradient [
	^true]

{ #category : #testing }
GradientFillType >> isLike: aBrushFillType [
	^aBrushFillType isGradient
		and: [startColor equals: aBrushFillType startColor]
		and: [endColor equals: aBrushFillType endColor]]

{ #category : #copying }
GradientFillType >> postCopy [
	super postCopy.
	startColor := startColor copy.
	endColor := endColor copy]

{ #category : #services }
GradientFillType >> replaceColor: aColor with: anotherColor [
	(startColor equals: aColor) ifTrue: [startColor := anotherColor asARGBColor].
	(endColor equals: aColor) ifTrue: [endColor := anotherColor asARGBColor]]

{ #category : #accessing }
GradientFillType >> startColor [
	^startColor]

{ #category : #accessing }
GradientFillType >> startColor: aColor [
	startColor := aColor asARGBColor]

{ #category : #accessing }
GradientFillType >> transparency: percent [
	startColor transparency: percent.
	endColor transparency: percent]

