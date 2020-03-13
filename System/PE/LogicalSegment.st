"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #LogicalSegment,
	#superclass : #LogicalSection,
	#instVars : [
		'#section',
		'#name',
		'#offset',
		'#contents'
	],
	#category : #PE
}

{ #category : #accessing }
LogicalSegment class >> in: section [
	^self new section: section
]

{ #category : #accessing }
LogicalSegment >> baseFileAddress [
	^section baseFileAddress + offset
]

{ #category : #accessing }
LogicalSegment >> baseVirtualAddress [
	^section baseVirtualAddress + offset
]

{ #category : #accessing }
LogicalSegment >> bytes: aByteArray [
	contents := aByteArray
]

{ #category : #accessing }
LogicalSegment >> endOffset [
	^offset + self size - 1
]

{ #category : #accessing }
LogicalSegment >> expectedOffset [
	^offset ifNil: [section offsetOf: self]
]

{ #category : #accessing }
LogicalSegment >> name [
	^name
]

{ #category : #accessing }
LogicalSegment >> name: aString [
	name := aString
]

{ #category : #accessing }
LogicalSegment >> offset [
	^offset
]

{ #category : #accessing }
LogicalSegment >> offset: anInteger [
	offset := anInteger
]

{ #category : #testing }
LogicalSegment >> overlapsInFileWithSection: aSection at: address [
	^aSection segments
		anySatisfy: [:segment | self
			overlapsInFileWithSegment: segment
			at: address + segment expectedOffset]
]

{ #category : #private }
LogicalSegment >> overlapsInFileWithSegment: aSegment at: address [
	| base own other |
	base := self baseFileAddress.
	own := base to: base + self size - 1.
	other := address to: address + aSegment size - 1.
	^(own intersection: other) isEmpty not
]

{ #category : #testing }
LogicalSegment >> overlapsWithSection: aSection at: address [
	^aSection segments
		anySatisfy: [:segment | self
			overlapsWithSegment: segment
			at: address + segment expectedOffset]
]

{ #category : #private }
LogicalSegment >> overlapsWithSegment: aSegment at: address [
	| base own other |
	base := self baseVirtualAddress.
	own := base to: base + self size - 1.
	other := address to: address + aSegment size - 1.
	^(own intersection: other) isEmpty not
]

{ #category : #accessing }
LogicalSegment >> pebuilder [
	^section pebuilder
]

{ #category : #accessing }
LogicalSegment >> pefile [
	^section pefile
]

{ #category : #accessing }
LogicalSegment >> printOn: aStream [
	aStream nextPutAll: section name , ' segment @ ' , (offset ifNil: [0]) hex.
	name ifNotNil: [aStream nextPutAll: ' (' , name , ')']
]

{ #category : #accessing }
LogicalSegment >> rvaOf: anInteger [
	^(section @ offset) rva + anInteger
]

{ #category : #accessing }
LogicalSegment >> section: aPESection [
	section := aPESection
]

{ #category : #accessing }
LogicalSegment >> size [
	^contents size
]

{ #category : #accessing }
LogicalSegment >> storeContentsOn: aStream [
	aStream position: self baseFileAddress; nextPutAll: contents
]

{ #category : #accessing }
LogicalSegment >> uLongAtOffset: anInteger put: value [
	contents uLongAtOffset: anInteger put: value
]

{ #category : #accessing }
LogicalSegment >> vaOf: anInteger [
	^(section @ offset) va + anInteger
]

{ #category : #accessing }
LogicalSegment >> wordSize [
	^section wordSize
]

