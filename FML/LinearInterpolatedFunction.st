"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #LinearInterpolatedFunction }

{ #category : '*FML' }
LinearInterpolatedFunction >> asFmlValue [
	^FmlTable on: self]

{ #category : '*FML' }
LinearInterpolatedFunction >> resultType [
	^FmlTable]

