"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssFamilyNameValue,
	#superclass : #CssStringValue,
	#category : #CSS
}

{ #category : #'instance creation' }
CssFamilyNameValue class >> readFrom: aStream [
	| pos out |
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
						out nextPut: aStream next].
					aStream next]
				ifFalse: [| seps |
					seps := self separators , ',;/'.
					[aStream atEnd or: [seps includes: aStream peek]]
						whileFalse: [out nextPut: aStream next]]].
	(CssGenericFamilyValue new string: out contents asLowercase) isValid ifTrue: [
		aStream position: pos.
		^nil].
	out contents size > 0 ifTrue: [^self new string: out contents].
	aStream position: pos.
	^nil]

