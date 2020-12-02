"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssUrlValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssUrlValue class >> readFrom: aStream [
	| pos s |
	aStream skipSeparators.
	pos := aStream position.
	s := (aStream peekForAll: 'url(') ifTrue: [aStream upTo: $)] ifFalse: [
		aStream position: pos.
		aStream peek = $'
			ifTrue: [aStream next; upTo: $']
			ifFalse: [aStream peek = $"
				ifTrue: [aStream next; upTo: $"]
				ifFalse: [^nil]]].
	^self new string: s unquoted]

{ #category : #testing }
CssUrlValue >> isValid [
	^true]

{ #category : #accessing }
CssUrlValue >> value [
	| s |
	s := string trimBlanks.
	^self isValid
		ifTrue: [
			(s beginsWith: 'url(')
				ifTrue: [
					s := s tail: s size - 4.
					s := s truncateTo: s size - 1.
					s := s trimBlanks unquoted]
				ifFalse: [s unquoted]]
		ifFalse: ['']]

