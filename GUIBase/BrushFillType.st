"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BrushFillType,
	#superclass : #Object,
	#instVars : [
		'owner'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
BrushFillType class >> fromHatch: aHatchFillType [
	^self new fromHatch: aHatchFillType]

{ #category : #'instance creation' }
BrushFillType class >> fromLinearGradient: aLinearGradientFillType [
	^self new fromLinearGradient: aLinearGradientFillType]

{ #category : #'instance creation' }
BrushFillType class >> fromRadialGradient: aRadialGradientFillType [
	^self new fromRadialGradient: aRadialGradientFillType]

{ #category : #private }
BrushFillType class >> fromSelector [
	^self subclassResponsibility]

{ #category : #'instance creation' }
BrushFillType class >> fromSolid: aSolidFillType [
	^self new fromSolid: aSolidFillType]

{ #category : #'instance creation' }
BrushFillType class >> fromType: aBrushFillType [
	^self perform: aBrushFillType fromSelector with: aBrushFillType]

{ #category : #'instance creation' }
BrushFillType class >> new [
	^super new initialize]

{ #category : #accessing }
BrushFillType >> color [
	^self subclassResponsibility]

{ #category : #accessing }
BrushFillType >> color: aColor [
	self subclassResponsibility]

{ #category : #enumerating }
BrushFillType >> elementsDo: aBlock [
	aBlock evaluateWith: self]

{ #category : #converting }
BrushFillType >> fromHatch: aHatchFillType [
	"
	Do nothing
	"
	]

{ #category : #converting }
BrushFillType >> fromLinearGradient: aLinearGradientFillType [
	"
	Do nothing
	"
	]

{ #category : #converting }
BrushFillType >> fromPathGradient: aPathGradientFillType [
	"
	Do nothing
	"
	]

{ #category : #converting }
BrushFillType >> fromRadialGradient: aRadialGradientFillType [
	"
	Do nothing
	"
	]

{ #category : #converting }
BrushFillType >> fromSelector [
	^self class fromSelector]

{ #category : #converting }
BrushFillType >> fromSolid: aChartFillType [
	"
	Do nothing
	"
	]

{ #category : #services }
BrushFillType >> highlighted [
	^self subclassResponsibility]

{ #category : #testing }
BrushFillType >> isGradient [
	^false]

{ #category : #testing }
BrushFillType >> isHatch [
	^false]

{ #category : #testing }
BrushFillType >> isLike: aBrushFillType [
	^self subclassResponsibility]

{ #category : #testing }
BrushFillType >> isLinearGradient [
	^false]

{ #category : #testing }
BrushFillType >> isPathGradient [
	^false]

{ #category : #testing }
BrushFillType >> isRadialGradient [
	^false]

{ #category : #testing }
BrushFillType >> isSolid [
	^false]

{ #category : #accessing }
BrushFillType >> opacity: aNumber [
	self transparency: 1.0 - aNumber]

{ #category : #accessing }
BrushFillType >> owner [
	^owner]

{ #category : #accessing }
BrushFillType >> owner: anObject [
	owner := anObject]

{ #category : #services }
BrushFillType >> replaceColor: aColor with: anotherColor [
	]

{ #category : #accessing }
BrushFillType >> transparency [
	^self color transparency]

{ #category : #accessing }
BrushFillType >> transparency: percent [
	self subclassResponsibility]

