"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssMarginWidthValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssMarginWidthValue >> isValid [
	string = 'auto' ifTrue: [^true].
	(CssLengthValue fromString: string) isValid ifTrue: [^true].
	(CssPercentageValue fromString: string) isValid ifTrue: [^true].
	^false]

