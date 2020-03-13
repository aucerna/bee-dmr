"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_IMPORT_DESCRIPTOR,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR class >> def [
	^<def>
	typedef struct IMAGE_IMPORT_DESCRIPTOR {
		union {
			DWORD Characteristics;
			DWORD OriginalFirstThunk;
      	};
		DWORD TimeDateStamp;
		DWORD ForwarderChain;
		DWORD Name;
		DWORD FirstThunk;
	} IMAGE_IMPORT_DESCRIPTOR ;
	</def>
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> Characteristics [
	^self uLongAtOffset: Characteristics
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> Characteristics: anInteger [
	self uLongAtOffset: Characteristics put: anInteger
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> FirstThunk [
	^self uLongAtOffset: FirstThunk
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> FirstThunk: anInteger [
	self uLongAtOffset: FirstThunk put: anInteger
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> ForwarderChain [
	^self uLongAtOffset: ForwarderChain
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> ForwarderChain: anInteger [
	self uLongAtOffset: ForwarderChain put: anInteger
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> Name [
	^self uLongAtOffset: Name
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> Name: anInteger [
	self uLongAtOffset: Name put: anInteger
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> OriginalFirstThunk [
	^self uLongAtOffset: OriginalFirstThunk
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> OriginalFirstThunk: anInteger [
	self uLongAtOffset: OriginalFirstThunk put: anInteger
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> TimeDateStamp [
	^self uLongAtOffset: TimeDateStamp
]

{ #category : #accessing }
IMAGE_IMPORT_DESCRIPTOR >> TimeDateStamp: anInteger [
	self uLongAtOffset: TimeDateStamp put: anInteger
]

