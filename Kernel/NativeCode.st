"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #NativeCode,
	#superclass : #Array,
	#type : #variable,
	#instVars : [
		'machineCode',
		'compiledCode'
	],
	#category : #Kernel
}

{ #category : #actions }
NativeCode >> asParameter [
	^machineCode _oop
]

{ #category : #accessing }
NativeCode >> block [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> block: anObject [
	compiledCode := anObject
]

{ #category : #accessing }
NativeCode >> bytes [
	^machineCode
]

{ #category : #accessing }
NativeCode >> code [
	^machineCode
]

{ #category : #accessing }
NativeCode >> code: bytes [
	machineCode := bytes
]

{ #category : #accessing }
NativeCode >> codeAddress [
	^machineCode _oop
]

{ #category : #accessing }
NativeCode >> compiledCode [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> compiledCode: anObject [
	compiledCode := anObject
]

{ #category : #accessing }
NativeCode >> entryPoint [
	^machineCode oop
]

{ #category : #testing }
NativeCode >> isNativeCode [
	^true
]

{ #category : #accessing }
NativeCode >> method [
	^compiledCode
]

{ #category : #accessing }
NativeCode >> method: anObject [
	compiledCode := anObject
]

{ #category : #private }
NativeCode >> pointedMemory [
	^(machineCode _asPointer * 2) pointedMemory
]

{ #category : #private }
NativeCode >> printOn: aStream [
	aStream
		nextPutAll: self class name withArticle;
		nextPutAll: ' (';
		print: compiledCode;
		nextPut: $)
]

{ #category : #private }
NativeCode >> sendSites [
	^self select: [:obj | obj class == SendSite]
]

