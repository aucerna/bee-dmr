"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssStringValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssStringValue class >> readFrom: aStream [
	| out |
	out := '' writeStream.
	aStream peek = $'
		ifTrue: [
			aStream next.
			[aStream peek = $'] whileFalse: [
				aStream peek = $\ ifTrue: [aStream next].
				out nextPut: aStream next].
			aStream next]
		ifFalse: [
			aStream peek = $" ifTrue: [
				aStream next.
				[aStream peek = $"] whileFalse: [
					aStream peek = $\ ifTrue: [aStream next].
					out nextPut: aStream next].
				aStream next]].
	^out contents size > 0 ifTrue: [self new string: out contents]]

{ #category : #testing }
CssStringValue >> isValid [
	^string notEmpty]

{ #category : #accessing }
CssStringValue >> value [
	^string unquoted]

