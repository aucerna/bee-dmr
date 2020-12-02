"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssRelativeSizeValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssRelativeSizeValue >> isValid [
	^#('smaller' 'larger') includes: string]

