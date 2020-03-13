"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OffsetDictionaryWriter,
	#superclass : #Object,
	#instVars : [
		'class',
		'documentation',
		'dictionary'
	],
	#category : #C
}

{ #category : #services }
OffsetDictionaryWriter class >> exceptions [
	^#(
		'BSTR'
		'HTTP_DATA_CHUNK'
		'ObjectSpaceInfoStruct'
		'VENDORCODE') collect: [:cn | Smalltalk at: cn asSymbol]
]

{ #category : #'instance creation' }
OffsetDictionaryWriter class >> on: aClass [
	"
	(OffsetDictionaryWriter on: DISPLAY_DEVICE) write
	"
	^self on: aClass documentation: aClass def
]

{ #category : #'instance creation' }
OffsetDictionaryWriter class >> on: aClass documentation: aString [
	^self new on: aClass; documentation: aString
]

{ #category : #services }
OffsetDictionaryWriter class >> writeAll [
	"
	OffsetDictionaryWriter writeAll
	"
	| exceptions |
	exceptions := self exceptions.
	ExternalStructure allSubclasses
		reject: [:cls | cls isAbstract or: [exceptions includes: cls]]
		thenDo: [:cls | (self on: cls) write]
]

{ #category : #private }
OffsetDictionaryWriter >> classChange [
	(class classVarNames includes: 'Offsets') ifTrue: [^nil].
	^ClassVariableAddition new
		project: class project;
		className: class name;
		variable: 'Offsets'
]

{ #category : #private }
OffsetDictionaryWriter >> defString [
	^String streamContents: [:strm | 
		strm nextPutAll: 'def'; crtab; nextPutAll: '^'''.
		documentation lines do: [:line | 
			strm
				crtab: 2;
				nextPutAll: (line replaceAll: '''' with: '''''')].
		strm nextPut: $']
]

{ #category : #accessing }
OffsetDictionaryWriter >> documentation: aString [
	documentation := aString
]

{ #category : #private }
OffsetDictionaryWriter >> methodChange [
	^MethodDefinition new
		project: class project;
		category: #accessing;
		className: class class name;
		sourceCode: self defString
]

{ #category : #accessing }
OffsetDictionaryWriter >> on: aClass [
	class := aClass
]

{ #category : #writing }
OffsetDictionaryWriter >> write [
	self classChange ifNotNil: [:change | change perform].
	self writeDef.
	class project changes evaluate: class name , ' initializeOffsets'
]

{ #category : #writing }
OffsetDictionaryWriter >> writeDef [
	self methodChange perform
]

