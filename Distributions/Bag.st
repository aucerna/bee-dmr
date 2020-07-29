"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #Bag }

{ #category : '*Distributions' }
Bag >> density [
	| answer s |
	answer := Dictionary new.
	s := self size asFloat.
	contents keysAndValuesDo: [:k :v | answer at: k put: v asFloat / s].
	^answer]

