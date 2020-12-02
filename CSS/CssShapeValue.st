"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssShapeValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #testing }
CssShapeValue >> isValid [
	| s items |
	s := string trimBlanks asLowercase.
	(s beginsWith: 'rect(') ifFalse: [^false].
	(s endsWith: ')') ifFalse: [^false].
	s := s tail: s size - 'rect(' size.
	s := s truncateTo: s size - 1.
	items := s substringsDelimitedBy: ' '.
	items size = 4 ifFalse: [^false].
	^items
		conform: [:item | item = 'auto'
			or: [(CssLengthValue fromString: item) isValid]]]

