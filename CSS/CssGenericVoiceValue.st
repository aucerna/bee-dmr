"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssGenericVoiceValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssGenericVoiceValue >> isValid [
	^#('male' 'female' 'child') includes: string]

