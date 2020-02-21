Class {
	#name : #IMAGE_NT_HEADERS64,
	#superclass : #IMAGE_NT_HEADERS,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #private }
IMAGE_NT_HEADERS64 class >> def [
	^<def>
	typedef struct _IMAGE_NT_HEADERS {
		DWORD                 Signature;
		IMAGE_FILE_HEADER     FileHeader;
		IMAGE_OPTIONAL_HEADER64 OptionalHeader;
	} IMAGE_NT_HEADERS, *PIMAGE_NT_HEADERS;
	</def>
]

{ #category : #services }
IMAGE_NT_HEADERS64 class >> defaultCharacteristics [
	^IMAGE_FILE_HEADER defaultCharacteristicsAMD64
]

{ #category : #services }
IMAGE_NT_HEADERS64 class >> defaultMachineType [
	^IMAGE_FILE_HEADER machineFlagAMD64
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> FileHeader [
	^self structureAtOffset: FileHeader ofClass: IMAGE_FILE_HEADER
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> FileHeader: anIMAGE_FILE_HEADER [
	self bytesAtOffset: FileHeader put: anIMAGE_FILE_HEADER asParameter
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> OptionalHeader [
	^self structureAtOffset: OptionalHeader ofClass: IMAGE_OPTIONAL_HEADER64
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> OptionalHeader: anIMAGE_OPTIONAL_HEADER64 [
	self bytesAtOffset: OptionalHeader put: anIMAGE_OPTIONAL_HEADER64 asParameter
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> Signature [
	^self uLongAtOffset: Signature
]

{ #category : #accessing }
IMAGE_NT_HEADERS64 >> Signature: anInteger [
	self uLongAtOffset: Signature put: anInteger
]

