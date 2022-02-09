"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #IdentitySet,
	#superclass : #Set,
	#category : #Kernel
}

{ #category : #private }
IdentitySet >> equates: key with: element [
	^key == element
]

{ #category : #private }
IdentitySet >> hashFor: object [
	^object basicHash * 16273
]

{ #category : #inquiries }
IdentitySet >> includesIdentical: anObject [
	^self includes: anObject
]

