"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssGenericFamilyValue,
	#superclass : #CssValue,
	#category : #CSS
}

{ #category : #parsing }
CssGenericFamilyValue class >> readFrom: aStream [
	| out pos |
	pos := aStream position.
	out := '' writeStream.
	aStream skipSeparators.
	aStream peek = $'
		ifTrue: [
			aStream next.
			[aStream peek = $'] whileFalse: [
				aStream peek = $\ ifTrue: [aStream next].
				out nextPut: aStream next]]
		ifFalse: [
			aStream peek = $"
				ifTrue: [
					aStream next.
					[aStream peek = $"] whileFalse: [
						aStream peek = $\ ifTrue: [aStream next].
						out nextPut: aStream next]]
				ifFalse: [| seps |
					seps := self separators , ',;/'.
					[aStream atEnd or: [seps includes: aStream peek]]
						whileFalse: [out nextPut: aStream next]]].
	out contents size > 0 ifTrue: [^self new string: out contents].
	aStream position: pos.
	^nil]

{ #category : #testing }
CssGenericFamilyValue >> isValid [
	^#('serif' 'sans-serif' 'cursive' 'fantasy' 'monospace') includes: string]

