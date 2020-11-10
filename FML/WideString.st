"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #WideString }

{ #category : '*FML' }
WideString >> unaccented [
	^self normalizeToD reject: [:ch | ch isNonSpacingMark]]

