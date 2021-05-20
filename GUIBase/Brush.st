"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Brush,
	#superclass : #Object,
	#instVars : [
		'pattern',
		'style'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
Brush class >> color: aColor [
	^self new color: aColor]

{ #category : #'instance creation' }
Brush class >> new [
	^super new initialize]

{ #category : #accessing }
Brush >> backColor [
	^pattern backColor]

{ #category : #accessing }
Brush >> beHatch [
	pattern isHatch ifTrue: [^self].
	pattern := HatchFillType fromType: pattern]

{ #category : #accessing }
Brush >> beHatch: aSymbol foreColor: aColor backColor: anotherColor [
	self beHatch.
	pattern
		style: aSymbol;
		foreColor: aColor;
		backColor: anotherColor]

{ #category : #accessing }
Brush >> beLinearGradient [
	pattern isLinearGradient ifTrue: [^self].
	pattern := LinearGradientFillType fromType: pattern]

{ #category : #accessing }
Brush >> beRadialGradient [
	pattern isRadialGradient ifTrue: [^self].
	pattern := RadialGradientFillType fromType: pattern]

{ #category : #accessing }
Brush >> beSolid [
	pattern isSolid ifTrue: [^self].
	pattern := SolidFillType fromType: pattern]

{ #category : #accessing }
Brush >> color [
	^pattern color]

{ #category : #accessing }
Brush >> color: aColor [
	pattern color: aColor]

{ #category : #accessing }
Brush >> endColor [
	^pattern endColor]

{ #category : #accessing }
Brush >> foreColor [
	^pattern foreColor]

{ #category : #accessing }
Brush >> hatchStyle [
	self ASSERT: pattern isHatch.
	^pattern style]

{ #category : #initialization }
Brush >> initialize [
	pattern := SolidFillType color: Color white]

{ #category : #testing }
Brush >> isHatchBrush [
	^pattern isHatch]

{ #category : #testing }
Brush >> isLinearGradientBrush [
	^pattern isLinearGradient]

{ #category : #testing }
Brush >> isPathGradientBrush [
	^pattern isPathGradient]

{ #category : #testing }
Brush >> isRadialGradientBrush [
	^pattern isRadialGradient]

{ #category : #testing }
Brush >> isSolidBrush [
	^pattern isSolid]

{ #category : #accessing }
Brush >> startColor [
	^pattern startColor]

