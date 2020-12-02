"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssPropertyError,
	#superclass : #CssError,
	#instVars : [
		'propertyName'
	],
	#category : #CSS
}

{ #category : #accessing }
CssPropertyError >> propertyName: aString [
	propertyName := aString]

