"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ARGBColor,
	#superclass : #RGBColor,
	#instVars : [
		'alpha'
	],
	#category : #GUIbase
}

{ #category : #'instance creation' }
ARGBColor class >> alpha: alpha
red: red
green: green
blue: blue [
	| a r g b |
	a := (alpha max: 0) min: 255.
	r := (red max: 0) min: 255.
	g := (green max: 0) min: 255.
	b := (blue max: 0) min: 255.
	^self new
		alpha: a asInteger;
		red: r asInteger;
		green: g asInteger;
		blue: b asInteger]

{ #category : #private }
ARGBColor class >> defaultClass [
	^RGBColor]

{ #category : #'instance accessing' }
ARGBColor class >> defaultNamed: aSymbol [
	^(super defaultNamed: aSymbol) asARGBColor]

{ #category : #'instance creation' }
ARGBColor class >> fromArray: anArray [
	^self
		alpha: anArray first
		red: anArray second
		green: anArray third
		blue: anArray fourth]

{ #category : #comparing }
ARGBColor >> = aColor [
	^super = aColor and: [alpha = aColor alpha]]

{ #category : #accessing }
ARGBColor >> alpha [
	^alpha]

{ #category : #accessing }
ARGBColor >> alpha: value [
	self ASSERT: (value between: 0 and: 255).
	alpha := value]

{ #category : #accessing }
ARGBColor >> alphaLevel [
	^alpha asFloat / 255.0]

{ #category : #converting }
ARGBColor >> asARGBColor [
	^self]

{ #category : #converting }
ARGBColor >> asRGBColor [
	^Color red: red green: green blue: blue]

{ #category : #services }
ARGBColor >> averageWith: aColor [
	| average |
	average := super averageWith: aColor.
	^average alpha: alpha + aColor asARGBColor alpha // 2]

{ #category : #accessing }
ARGBColor >> displayName [
	| name parenthesized |
	name := self asRGBColor displayName.
	parenthesized := name last = $).
	parenthesized ifTrue: [name := name allButLast].
	name := name , ', alpha: ' , alpha printString.
	parenthesized ifTrue: [name := name , ')'].
	^name]

{ #category : #testing }
ARGBColor >> hasAlphaChannel [
	^true]

{ #category : #comparing }
ARGBColor >> hash [
	^super hash hashWith: alpha]

{ #category : #initialization }
ARGBColor >> initialize [
	super initialize.
	alpha := 255]

{ #category : #accessing }
ARGBColor >> opacity [
	^alpha / 255.0]

{ #category : #accessing }
ARGBColor >> opacity: percent [
	self alpha: (255 * percent) rounded]

{ #category : #accessing }
ARGBColor >> transparency [
	^1 - self opacity]

{ #category : #accessing }
ARGBColor >> transparency: percent [
	self opacity: 1.0 - percent]

