"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #RadialGradientFillType,
	#superclass : #PathGradientFillType,
	#category : #GUIbase
}

{ #category : #private }
RadialGradientFillType class >> fromSelector [
	^#fromRadialGradient:]

{ #category : #testing }
RadialGradientFillType >> isLike: aBrushFillType [
	^(super isLike: aBrushFillType) and: [aBrushFillType isRadialGradient]]

{ #category : #testing }
RadialGradientFillType >> isRadialGradient [
	^true]

