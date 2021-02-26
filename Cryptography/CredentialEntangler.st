"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CredentialEntangler,
	#superclass : #Object,
	#instVars : [
		'class',
		'selector',
		'credential',
		'seed'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
CredentialEntangler class >> new [
	^super new initialize]

{ #category : #private }
CredentialEntangler >> blob [
	| random xor |
	random := Random new seed: seed.
	xor := (1 to: credential size) collect: [:i | (256 atRandom: random) - 1].
	^credential asByteArray bitXor: xor]

{ #category : #private }
CredentialEntangler >> class: aClass selector: aSymbol credential: aString [
	class := aClass.
	selector := aSymbol.
	credential := aString]

{ #category : #initialization }
CredentialEntangler >> initialize [
	super initialize.
	seed := Random current next asString asNumber]

{ #category : #services }
CredentialEntangler >> installChange [
	| change |
	change := self change.
	class project changes addChange: change.
	change perform]

{ #category : #accessing }
CredentialEntangler >> source [
	^String streamContents: [:strm | self writeSourceOn: strm]]

{ #category : #private }
CredentialEntangler >> writeSourceOn: aStream [
	| n |
	n := credential sizeInBytes.
	aStream
		nextPutAll: selector;
		crtab;
		nextPutAll: '| bytes random xor text |';
		crtab;
		nextPutAll: 'bytes := ';
		nextPutAll: (ByteArray new: n) literalString;
		nextPut: $.;
		crtab;
		nextPutAll: 'random := Random new seed: ';
		nextPutAll: seed asString;
		nextPut: $.;
		crtab;
		nextPutAll: 'bytes'.
	self blob withIndexDo: [:byte :i | 
		i > 1 ifTrue: [aStream nextPut: $;].
		aStream
			crtab: 2;
			nextPutAll: 'at: ';
			nextPutAll: i asString;
			nextPutAll: ' put: ';
			nextPutAll: byte asString].
	aStream
		nextPut: $.;
		crtab;
		nextPutAll: 'xor := ';
		nextPutAll: '(1 to: ';
		nextPutAll: n asString;
		nextPutAll: ') collect: [:i | (256 atRandom: random) - 1].';
		crtab;
		nextPutAll: 'text := (bytes bitXor: xor) asString.';
		crtab;
		nextPutAll: 'bytes atAllPut: 0.';
		crtab;
		nextPutAll: '^text']

