"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #SortedCollection }

{ #category : '*FML' }
SortedCollection >> replace: anObject with: anotherObject [
	self
		remove: anObject ifAbsent: [^self];
		add: anotherObject]

