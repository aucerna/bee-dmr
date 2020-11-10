"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Date }

{ #category : '*Units' }
Date >> inUnit: aUnit [
	self ASSERT: aUnit isDateUnit.
	^self]

