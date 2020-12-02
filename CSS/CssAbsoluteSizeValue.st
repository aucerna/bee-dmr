"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAbsoluteSizeValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssAbsoluteSizeValue >> isValid [
	^#('xx-small' 'x-small' 'small' 'medium' 'large' 'x-large' 'xx-large')
		includes: string]

