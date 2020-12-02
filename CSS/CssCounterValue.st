"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssCounterValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssCounterValue >> isValid [
	(string endsWith: ')') ifFalse: [^false].
	(string beginsWith: 'counter(')
		ifTrue: [| args |
			args := (string substringsDelimitedBy: '(,) ') allButFirst.
			^args size = 1 or: [args size = 2 and: [self isValidStyle: args last]]]
		ifFalse: [
			(string beginsWith: 'counters(') ifTrue: [| args |
				args := (string substringsDelimitedBy: '(,) ') allButFirst.
				^args size = 2 or: [args size = 3 and: [self isValidStyle: args last]]]].
	^false]

{ #category : #testing }
CssCounterValue >> isValidStyle: aString [
	^(CssPropertyDefinition named: 'list-style-type') valueType
		isValidValue: aString]

