"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssLangSelector,
	#superclass : #CssPseudoClassSelector,
	#category : #CSS
}

{ #category : #accessing }
CssLangSelector >> language [
	^self arguments]

