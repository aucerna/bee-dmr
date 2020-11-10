"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Character }

{ #category : '*FML' }
Character class >> specialCharacters [
	"
	Character specialCharacters
	"
	^#($* $+ $~ $| $, $/ $\ $< $= $> $? $@ $! $% $& )]

{ #category : '*FML' }
Character >> isSpecial [
	^self class specialCharacters includes: self]

{ #category : '*FML' }
Character >> normalized [
	| unaccented |
	unaccented := self unaccented.
	^unaccented = self ifTrue: [self asLowercase] ifFalse: [self asUppercase]]

{ #category : '*FML' }
Character >> unaccented [
	^self asString unaccented first]

