Class {
	#name : #WriteStringStream,
	#superclass : #InternalWriteStream,
	#category : #Kernel
}

{ #category : #configuration }
WriteStringStream >> beUnicode [
	super beUnicode.
]

{ #category : #writing }
WriteStringStream >> nextPut: aCharacter [
	aCharacter isAnsi ifTrue: [^super nextPut: aCharacter].
]

{ #category : #writing }
WriteStringStream >> nextPutAll: aString [
	aString isString ifFalse: [^super nextPutAll: aString].
]
