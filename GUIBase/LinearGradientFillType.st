"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #LinearGradientFillType,
	#superclass : #GradientFillType,
	#instVars : [
		'style'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
LinearGradientFillType class >> fromHatch: aHatchFillType [
	^self new color: aHatchFillType foreColor]

{ #category : #private }
LinearGradientFillType class >> fromSelector [
	^#fromLinearGradient:]

{ #category : #accessing }
LinearGradientFillType >> color [
	^self startColor]

{ #category : #accessing }
LinearGradientFillType >> color: aColor [
	self startColor: aColor; endColor: aColor muchDarker muchDarker]

{ #category : #converting }
LinearGradientFillType >> fromHatch: aHatchFillType [
	| s |
	self color: aHatchFillType foreColor.
	s := aHatchFillType style.
	(self styles includes: s) ifTrue: [self style: s]]

{ #category : #initialization }
LinearGradientFillType >> initialize [
	super initialize.
	style := #vertical]

{ #category : #testing }
LinearGradientFillType >> isLike: aBrushFillType [
	^(super isLike: aBrushFillType) and: [aBrushFillType isLinearGradient]]

{ #category : #testing }
LinearGradientFillType >> isLinearGradient [
	^true]

{ #category : #accessing }
LinearGradientFillType >> style [
	^style]

{ #category : #accessing }
LinearGradientFillType >> style: aSymbol [
	self ASSERT: (self styles includes: aSymbol).
	style := aSymbol]

{ #category : #accessing }
LinearGradientFillType >> styles [
	^#(horizontal #vertical #fdiagonal #bdiagonal)]

