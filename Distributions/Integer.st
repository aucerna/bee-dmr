"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Integer }

{ #category : '*Distributions' }
Integer >> sum [
	^self sumFrom: 1]

{ #category : '*Distributions' }
Integer >> sumFrom: anInteger [
	"
	4 sumFrom: 2
	"
	anInteger <= self ifFalse: [^0].
	^self + anInteger * (self - anInteger + 1) / 2]

