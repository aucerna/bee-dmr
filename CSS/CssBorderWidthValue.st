"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssBorderWidthValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssBorderWidthValue >> isValid [
	^(#('thin' 'medium' 'thick') includes: string)
		or: [(CssLengthValue fromString: string) isValid]]

