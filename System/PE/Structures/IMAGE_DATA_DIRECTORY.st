"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #IMAGE_DATA_DIRECTORY,
	#superclass : #PEFileStructure,
	#classVars : [
		'#Offsets'
	],
	#category : #PE
}

{ #category : #accessing }
IMAGE_DATA_DIRECTORY class >> def [
	^<def>
	typedef struct _IMAGE_DATA_DIRECTORY {
		DWORD VirtualAddress;
		DWORD Size;
	} IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;
	</def>
]

{ #category : #accessing }
IMAGE_DATA_DIRECTORY class >> sizeInBytes [
	^sizeInBytes
]

{ #category : #printing }
IMAGE_DATA_DIRECTORY >> addValidationSelectorsTo: aCollection [
	super addValidationSelectorsTo: aCollection.
	aCollection add: #directoryValidation
]

{ #category : #printing }
IMAGE_DATA_DIRECTORY >> containsRva: anInteger [
	^anInteger - self VirtualAddress between: 0 and: self Size
]

{ #category : #printing }
IMAGE_DATA_DIRECTORY >> printTextOn: rtf [
	rtf
		bold: 'Exe Directory Header';
		crtab;
		italic: 'virtual address: ';
		append: (self VirtualAddress radix: 16);
		crtab;
		italic: 'size: ';
		append: (self Size radix: 16)
]

{ #category : #accessing }
IMAGE_DATA_DIRECTORY >> Size [
	^self uLongAtOffset: Size
]

{ #category : #accessing }
IMAGE_DATA_DIRECTORY >> Size: anInteger [
	self uLongAtOffset: Size put: anInteger
]

{ #category : #accessing }
IMAGE_DATA_DIRECTORY >> VirtualAddress [
	^self uLongAtOffset: VirtualAddress
]

{ #category : #accessing }
IMAGE_DATA_DIRECTORY >> VirtualAddress: anInteger [
	self uLongAtOffset: VirtualAddress put: anInteger
]

