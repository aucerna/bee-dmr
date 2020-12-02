"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CssValue,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #CSS
}

{ #category : #'instance creation' }
CssValue class >> forType: aType [
	^self allSubclasses detect: [:cls | cls type = aType] ifNone: nil]

{ #category : #'instance creation' }
CssValue class >> fromString: aString [
	^self readFrom: aString readStream]

{ #category : #parsing }
CssValue class >> readFrom: aStream [
	| out seps |
	out := '' writeStream.
	seps := self separators , ';,'.
	aStream skipSeparators.
	[aStream atEnd or: [seps includes: aStream peek]]
		whileFalse: [out nextPut: aStream next].
	out contents trimBlanks size < 1 ifTrue: [^nil].
	^self new string: out contents]

{ #category : #accessing }
CssValue class >> separators [
	^String
		with: Space
		with: Tab
		with: Cr
		with: Lf
		with: Ff]

{ #category : #accessing }
CssValue class >> type [
	| s in out |
	s := self name.
	s := s tail: s size - 'CSS' size.
	s := s copyFrom: 1 to: s size - 'Value' size.
	out := String new writeStream.
	in := s readStream.
	out nextPut: $<; nextPut: in next asLowercase.
	[in atEnd] whileFalse: [
		in peek isUppercase ifTrue: [out nextPut: $-].
		out nextPut: in next asLowercase].
	out nextPut: $>.
	^out contents]

{ #category : #testing }
CssValue >> isProperty [
	^false]

{ #category : #testing }
CssValue >> isValid [
	self subclassResponsibility]

{ #category : #accessing }
CssValue >> string: aString [
	string := aString trimBlanks]

{ #category : #accessing }
CssValue >> stringValue [
	^string]

{ #category : #accessing }
CssValue >> value [
	self subclassResponsibility]

