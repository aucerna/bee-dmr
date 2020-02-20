Class {
	#name : #NativeCode,
	#superclass : #Object,
	#instVars : [
		'#code',
		'#references',
		'#entryPoints',
		'#fresh'
	],
	#category : #Kernel
}

{ #category : #inspecting }
NativeCode class >> aspects [
	^#(#disassembledText32 #disassembledText64)
]

{ #category : #accessing }
NativeCode class >> code: code references: references [
	^self new code: code references: references
]

{ #category : #private }
NativeCode >> acquireReferences [
	self registerSendSites.
]

{ #category : #actions }
NativeCode >> beFresh [
	fresh := true
]

{ #category : #accessing }
NativeCode >> code [
	^code
]

{ #category : #accessing }
NativeCode >> code: bytes references: aCollection [
	code := bytes.
]

{ #category : #accessing }
NativeCode >> copy [
	^self shallowCopy postCopyFrom: self
]

{ #category : #services }
NativeCode >> decodedReferenceOffset: encoded [
	^encoded bitAnd: 16r1FFFFFFF
]

{ #category : #private }
NativeCode >> decodedReferences [
	^references collect: [:encoded | 
]

{ #category : #accessing }
NativeCode >> disassembledText32 [
	^code disassembledText32
]

{ #category : #accessing }
NativeCode >> disassembledText64 [
	^code disassembledText64
]

{ #category : #private }
NativeCode >> encodedReferences [
	^(references collect: [:reference | reference sourceOffset]) asArray
]

{ #category : #accessing }
NativeCode >> entryPoint [
	^code oop
]

{ #category : #services }
NativeCode >> initialize [
	super initialize.
]

{ #category : #services }
NativeCode >> invalidateReferences [
	references := nil
]

{ #category : #testing }
NativeCode >> isFresh [
	^fresh
]

{ #category : #testing }
NativeCode >> isNativeCode [
	^true
]

{ #category : #testing }
NativeCode >> isObjectReference: encoded [
	^(encoded bitAnd: 16r20000000) != 16r20000000
]

{ #category : #accessing }
NativeCode >> nativeCodeAddress [
	^code _oop
]

{ #category : #accessing }
NativeCode >> nilReference: reference [
	| offset |
]

{ #category : #services }
NativeCode >> nilReferenceOffsets: aCollection [
	aCollection do: [:reference | self nilReference: reference]
]

{ #category : #accessing }
NativeCode >> objectAtOffset: offset put: position [
	^code _objectAtOffset: offset put: position
]

{ #category : #private }
NativeCode >> overwritePointerIn: reference [
	| address memory |
]

{ #category : #private }
NativeCode >> overwritePointers [
	references do: [:reference | self overwritePointerIn: reference]
]

{ #category : #private }
NativeCode >> pointedMemory [
	^ExternalMemory at: code _asPointer * 2
]

{ #category : #accessing }
NativeCode >> pointerAtOffset: offset put: position [
	code pointerAtOffset: offset put: position
]

{ #category : #copying }
NativeCode >> postCopyFrom: aNativeCode [
	self isFresh
]

{ #category : #accessing }
NativeCode >> referencedObjects [
	^fresh
]

{ #category : #accessing }
NativeCode >> references [
	^references
]

{ #category : #actions }
NativeCode >> refresh [
	self isFresh ifFalse: [self acquireReferences]
]

{ #category : #services }
NativeCode >> registerSendSites [
	references
]

{ #category : #relocations }
NativeCode >> relocateReference: encodedOffset from: sourceCodeAddress to: targetCodeAddress [
	| offset old delta |
]

{ #category : #relocations }
NativeCode >> relocateReferencesFrom: sourceCodeAddress to: targetCodeAddress [
	references do: [:encoded | 
]

{ #category : #private }
NativeCode >> sendSites [
	^self referencedObjects select: [:obj | obj class == SendSite]
]

{ #category : #accessing }
NativeCode >> size [
	^code size
]
