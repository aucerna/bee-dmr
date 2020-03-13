"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_RESOURCE_DATA_ENTRY,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY class >> def [
	^<def>
	typedef struct IMAGE_RESOURCE_DATA_ENTRY {
		ULONG OffsetToData;
		ULONG Size;
		ULONG CodePage;
		DWORD Reserved;
	} IMAGE_RESOURCE_DATA_ENTRY;
	</def>
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> CodePage [
	^self uLongAtOffset: CodePage
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> CodePage: anInteger [
	self uLongAtOffset: CodePage put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> OffsetToData [
	^self uLongAtOffset: OffsetToData
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> OffsetToData: anInteger [
	self uLongAtOffset: OffsetToData put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> Reserved [
	^self uLongAtOffset: Reserved
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> Reserved: anInteger [
	self uLongAtOffset: Reserved put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> Size [
	^self uLongAtOffset: Size
]

{ #category : #accessing }
IMAGE_RESOURCE_DATA_ENTRY >> Size: anInteger [
	self uLongAtOffset: Size put: anInteger
]

