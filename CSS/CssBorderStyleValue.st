"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssBorderStyleValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssBorderStyleValue >> isValid [
	^#('none'
	'hidden'
	'dotted'
	'dashed'
	'solid'
	'double'
	'groove'
	'ridge'
	'inset'
	'outset') includes: string]

