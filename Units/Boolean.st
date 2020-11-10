"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Boolean }

{ #category : '*Units' }
Boolean >> inUnit: aUnit [
	self ASSERT: aUnit isBooleanUnit.
	^self]

