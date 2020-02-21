Class {
	#name : #IMAGE_EXPORT_DIRECTORY,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY class >> def [
	^<def>
	typedef struct IMAGE_EXPORT_DIRECTORY {
		DWORD Characteristics;
		DWORD TimeDateStamp;
		WORD MajorVersion;
		WORD MinorVersion;
		DWORD Name;
		DWORD Base;
		DWORD NumberOfFunctions;
		DWORD NumberOfNames;
		DWORD AddressOfFunctions;
		DWORD AddressOfNames;
		DWORD AddressOfNameOrdinals;
	} IMAGE_EXPORT_DIRECTORY ;
	</def>
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfFunctions [
	^self uLongAtOffset: AddressOfFunctions
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfFunctions: anInteger [
	self uLongAtOffset: AddressOfFunctions put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfNameOrdinals [
	^self uLongAtOffset: AddressOfNameOrdinals
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfNameOrdinals: anInteger [
	self uLongAtOffset: AddressOfNameOrdinals put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfNames [
	^self uLongAtOffset: AddressOfNames
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> AddressOfNames: anInteger [
	self uLongAtOffset: AddressOfNames put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Base [
	^self uLongAtOffset: Base
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Base: anInteger [
	self uLongAtOffset: Base put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Characteristics [
	^self uLongAtOffset: Characteristics
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Characteristics: anInteger [
	self uLongAtOffset: Characteristics put: anInteger
]

{ #category : #private }
IMAGE_EXPORT_DIRECTORY >> initializeDefault [
	self TimeDateStamp: Timestamp now asUnixTime; Base: 1
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> MajorVersion [
	^self uShortAtOffset: MajorVersion
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> MajorVersion: anInteger [
	self uShortAtOffset: MajorVersion put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> MinorVersion [
	^self uShortAtOffset: MinorVersion
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> MinorVersion: anInteger [
	self uShortAtOffset: MinorVersion put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Name [
	^self uLongAtOffset: Name
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> Name: anInteger [
	self uLongAtOffset: Name put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> NumberOfFunctions [
	^self uLongAtOffset: NumberOfFunctions
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> NumberOfFunctions: anInteger [
	self uLongAtOffset: NumberOfFunctions put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> NumberOfNames [
	^self uLongAtOffset: NumberOfNames
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> NumberOfNames: anInteger [
	self uLongAtOffset: NumberOfNames put: anInteger
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> TimeDateStamp [
	^self uLongAtOffset: TimeDateStamp
]

{ #category : #accessing }
IMAGE_EXPORT_DIRECTORY >> TimeDateStamp: anInteger [
	self uLongAtOffset: TimeDateStamp put: anInteger
]

