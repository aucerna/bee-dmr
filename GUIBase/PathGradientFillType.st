"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #PathGradientFillType,
	#superclass : #GradientFillType,
	#category : #GUIbase
}

{ #category : #private }
PathGradientFillType class >> fromSelector [
	^#fromPathGradient:]

{ #category : #testing }
PathGradientFillType >> isLike: aBrushFillType [
	^(super isLike: aBrushFillType) and: [aBrushFillType isPathGradient]]

{ #category : #testing }
PathGradientFillType >> isPathGradient [
	^true]

