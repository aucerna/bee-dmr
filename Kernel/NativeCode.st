"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #NativeCode,
	#superclass : #Object,
	#type : #variable,
	#instVars : [
		'machineCode',
		'compiledCode'
	],
	#category : #Kernel
}

{ #category : #inspecting }
NativeCode class >> aspects [
	^#(#disassembledText32 #disassembledText64)
]

{ #category : #accessing }
NativeCode >> code [
	^machineCode
]

{ #category : #accessing }
NativeCode >> code: bytes [
	machineCode := bytes
]

{ #category : #private }
NativeCode >> decodedReferences [
	^self asArray
]

{ #category : #accessing }
NativeCode >> disassembledText32 [
	^machineCode disassembledText32
]

{ #category : #accessing }
NativeCode >> disassembledText64 [
	^machineCode disassembledText64
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
NativeCode >> nativeCodeAddress [
	^machineCode _oop
]

{ #category : #accessing }
NativeCode >> objectAtOffset: offset put: position [
	^machineCode _objectAtOffset: offset put: position
]

{ #category : #accessing }
NativeCode >> pointerAtOffset: offset put: position [
	machineCode pointerAtOffset: offset put: position
]

{ #category : #accessing }
NativeCode >> referencedObjects [
	^self asArray
]

{ #category : #services }
NativeCode >> registerSendSites [
	self do: [:o | o class == SendSite ifTrue: [o register]]
]

{ #category : #private }
NativeCode >> sendSites [
	^self select: [:obj | obj class == SendSite]
]

