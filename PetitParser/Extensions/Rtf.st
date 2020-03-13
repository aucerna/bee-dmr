"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #Rtf }

{ #category : '*Extensions' }
Rtf >> asParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : '*Extensions' }
Rtf >> asPetitStream [
	^ self asString asPetitStream
]

