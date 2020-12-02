"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssAttrXValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssAttrXValue class >> readFrom: in [
	| pos |
	in skipSeparators.
	pos := in position.
	(in match: 'attr(') ifFalse: [
		in position: pos.
		^nil].
	^self new string: (in upTo: $)) trimBlanks]

{ #category : #testing }
CssAttrXValue >> isValid [
	^(string beginsWith: 'attr(') and: [string endsWith: ')']]

