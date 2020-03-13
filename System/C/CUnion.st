"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #CUnion,
	#superclass : #CStruct,
	#category : #C
}

{ #category : #offsets }
CUnion >> computeLayout [
	fields do: [:f | 
		f alignAfter: 0.
		size := size max: f sizeInBytes ceiling]
]

{ #category : #printing }
CUnion >> typeTitle [
	^'union'
]

