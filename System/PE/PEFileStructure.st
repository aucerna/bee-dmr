Class {
	#name : #PEFileStructure,
	#superclass : #WindowsStructure,
	#category : #PE
}

{ #category : #accessing }
PEFileStructure class >> characteristics [
	^OrderedCollection new
		add: #IMAGE_FILE_RELOCS_STRIPPED -> 16r1;
		add: #IMAGE_FILE_EXECUTABLE_IMAGE -> 16r2;
		add: #IMAGE_FILE_LINE_NUMS_STRIPPED -> 16r4;
		add: #IMAGE_FILE_LOCAL_SYMS_STRIPPED -> 16r8;
		add: #IMAGE_FILE_BYTES_REVERSED_LO -> 16r80;
		add: #IMAGE_FILE_32BIT_MACHINE -> 16r100;
		add: #IMAGE_FILE_DEBUG_STRIPPED -> 16r200;
		add: #IMAGE_FILE_SYSTEM -> 16r1000;
		add: #IMAGE_FILE_DLL -> 16r2000;
		add: #IMAGE_FILE_BYTES_REVERSED_HI -> 16r8000;
		yourself
]

{ #category : #'instance creation' }
PEFileStructure class >> fromPEFile: aPEFile at: rva [
	| data |
	data := aPEFile copyFromRva: rva size: self sizeInBytes.
	^self usingBytes: data
]

{ #category : #'instance creation' }
PEFileStructure class >> fromStream: aStream [
	^self new fromStream: aStream
]

{ #category : #'instance creation' }
PEFileStructure class >> initializeConstants [
	"
	PEFileStructure initializeConstants
	"
	self initializeImageConstants
]

{ #category : #'instance creation' }
PEFileStructure class >> initializeImageConstants [
	"
	IMAGE_OPTIONAL_HEADER initializeImageConstants
	"
	WinConstants
		at: 'IMAGE_DOS_SIGNATURE' put: 16r5A4D;
		at: 'IMAGE_SIZEOF_SHORT_NAME' put: 8;
		at: 'IMAGE_NUMBEROF_DIRECTORY_ENTRIES' put: 16;
		at: 'IMAGE_NT_OPTIONAL_HDR32_MAGIC' put: 16r10B;
		at: 'IMAGE_SUBSYSTEM_WINDOWS_CUI' put: 3
]

{ #category : #'instance creation' }
PEFileStructure class >> validatorClass [
	^Smalltalk at: #WinExeHeaderValidator
]

{ #category : #printing }
PEFileStructure >> flags: bitMask using: description [
	| result |
	result := OrderedCollection new.
	description
		do: [:assoc | (assoc value anyMask: bitMask) ifTrue: [result
			add: assoc key]].
	^result asArray
]

{ #category : #parsing }
PEFileStructure >> fromStream: aStream [
	| data |
	data := aStream next: self sizeInBytes.
	self bytesAtOffset: 0 put: data
]

{ #category : #printing }
PEFileStructure >> printFlags: bitMask
using: description
on: rtf
indent: n [
	| array |
	array size > 1 ifTrue: [rtf crtab: n].
	description
		do: [:assoc | (assoc value anyMask: bitMask)
			ifTrue: [rtf append: assoc key asText]]
		separatedBy: [rtf crtab: n]
]

{ #category : #printing }
PEFileStructure >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $:; cr; cr.
	self aspects
		do: [:selector | 
			aStream
				nextPutAll: selector;
				nextPutAll: ': ';
				print: (self perform: selector)]
		separatedBy: [aStream cr]
]

{ #category : #printing }
PEFileStructure >> printTextOn: rtf [
	| painter |
	painter := PaintingVisitor new.
	rtf useItalicWhile: [
		super printOn: rtf.
		rtf nextPut: $:; cr; cr].
	self aspects
		do: [:selector | 
			rtf
				useColor: painter literalColor
				while: [rtf nextPutAll: selector; nextPutAll: ': '].
			rtf
				useColor: painter instVarColor
				while: [(self perform: selector) printTextOn: rtf]]
		separatedBy: [rtf cr]
]

{ #category : #parsing }
PEFileStructure >> storeOn: aStream [
	aStream putBytesFrom: self contents
]

