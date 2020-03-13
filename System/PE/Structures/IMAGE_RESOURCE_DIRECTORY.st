"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_RESOURCE_DIRECTORY,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY class >> def [
	^<def>
	typedef struct IMAGE_RESOURCE_DIRECTORY {
		DWORD	Characteristics;
		DWORD	TimeDateStamp;
		WORD	MajorVersion;
		WORD	MinorVersion;
		WORD	NumberOfNamedEntries;
		WORD	NumberOfIdEntries;
	} IMAGE_RESOURCE_DIRECTORY;
	</def>
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> Characteristics [
	^self uLongAtOffset: Characteristics
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> Characteristics: anInteger [
	self uLongAtOffset: Characteristics put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> MajorVersion [
	^self uShortAtOffset: MajorVersion
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> MajorVersion: anInteger [
	self uShortAtOffset: MajorVersion put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> MinorVersion [
	^self uShortAtOffset: MinorVersion
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> MinorVersion: anInteger [
	self uShortAtOffset: MinorVersion put: anInteger
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY >> numberOfEntries [
	^self NumberOfNamedEntries + self NumberOfIdEntries
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> NumberOfIdEntries [
	^self uShortAtOffset: NumberOfIdEntries
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> NumberOfIdEntries: anInteger [
	self uShortAtOffset: NumberOfIdEntries put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> NumberOfNamedEntries [
	^self uShortAtOffset: NumberOfNamedEntries
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> NumberOfNamedEntries: anInteger [
	self uShortAtOffset: NumberOfNamedEntries put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> TimeDateStamp [
	^self uLongAtOffset: TimeDateStamp
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY >> TimeDateStamp: anInteger [
	self uLongAtOffset: TimeDateStamp put: anInteger
]

