Class {
	#name : #IMAGE_RESOURCE_DIRECTORY_ENTRY,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY class >> def [
	"
	ShellDLL current openWebPage: 'http://msdn.microsoft.com/en-us/library/ms809762.aspx'
	"
	^<def>
	typedef struct _IMAGE_RESOURCE_DIRECTORY_ENTRY {
		union {
			struct {
				DWORD NameOffset:31;
				DWORD NameIsString:1;
			};
			DWORD   Name;
			WORD    Id;
		};
		union {
			DWORD   OffsetToData;
			struct {
				DWORD OffsetToDirectory:31;
				DWORD DataIsDirectory:1;
			};
		};
	} IMAGE_RESOURCE_DIRECTORY_ENTRY, *PIMAGE_RESOURCE_DIRECTORY_ENTRY ;
	</def>
]

{ #category : #initialization }
IMAGE_RESOURCE_DIRECTORY_ENTRY class >> generate [
	self error: 'cannot generate methods of this class'
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY class >> offsets64 [
^PoolDictionary new
		at: 'OffsetToDirectory' put: 8;
		at: 'Name' put: 0;
		at: 'Id' put: 0;
		at: 'NameOffset' put: 0;
		at: 'DataIsDirectory' put: 65/8;
		at: 'sizeInBytes' put: 16;
		at: 'OffsetToData' put: 8;
		at: 'NameIsString' put: 1/8;
		yourself
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> DataIsDirectory [
	^self uLongAtOffset: DataIsDirectory
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> DataIsDirectory: anInteger [
	self uLongAtOffset: DataIsDirectory put: anInteger
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> hasName [
	^self NameIsString isOnBit: 16r80000000
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> hasSubdirectory [
	^self DataIsDirectory isOnBit: 16r80000000
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> id [
	| id |
	self hasName ifTrue: [^nil].
	self hasSubdirectory ifFalse: [^nil].
	id := self Id.
	^id = 0 ifFalse: [id]
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> Id [
	^self uShortAtOffset: Id
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> Id: anInteger [
	self uShortAtOffset: Id put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> Name [
	^self uLongAtOffset: Name
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> Name: anInteger [
	self uLongAtOffset: Name put: anInteger
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> nameFrom: aStream [
	| rva bytes |
	self hasName ifFalse: [^nil].
	rva := self Name bitAnd: 16r7FFFFFF.
	aStream position: rva.
	bytes := ByteArray new: aStream nextULong * 2.
	aStream getBytesFor: bytes.
	^UTF16 current decode: bytes
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> NameIsString [
	^self uLongAtOffset: NameIsString
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> NameIsString: anInteger [
	self uLongAtOffset: NameIsString put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> NameOffset [
	^self uLongAtOffset: NameOffset
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> NameOffset: anInteger [
	self uLongAtOffset: NameOffset put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> OffsetToData [
	^self uLongAtOffset: OffsetToData
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> OffsetToData: anInteger [
	self uLongAtOffset: OffsetToData put: anInteger
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> OffsetToDirectory [
	^self uLongAtOffset: OffsetToDirectory
]

{ #category : #accessing }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> OffsetToDirectory: anInteger [
	self uLongAtOffset: OffsetToDirectory put: anInteger
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> resourceDataEntryFrom: aStream [
	| entry |
	self hasSubdirectory ifTrue: [^nil].
	entry := IMAGE_RESOURCE_DATA_ENTRY new.
	aStream position: self OffsetToData; getBytesFor: entry contents.
	^entry
]

{ #category : #output }
IMAGE_RESOURCE_DIRECTORY_ENTRY >> resourceSubdirectoryFrom: aStream [
	| directory rva |
	self hasSubdirectory ifFalse: [^nil].
	directory := IMAGE_RESOURCE_DIRECTORY new.
	rva := self OffsetToDirectory bitAnd: 16r7FFFFFFF.
	aStream position: rva; getBytesFor: directory contents.
	^directory
]

