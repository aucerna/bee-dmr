"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDIObject,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : #GDI
}

{ #category : #'instance creation' }
GDIObject class >> fromHandle: anInteger [
	^self new fromHandle: anInteger]

{ #category : #'instance creation' }
GDIObject class >> fromInteger: anInteger [
	^self new fromInteger: anInteger]

{ #category : #'system startup' }
GDIObject class >> sessionShutdown [
	self == GDIObject
		ifTrue: [self allSubclasses do: [:cls | cls sessionShutdown]]]

{ #category : #'system startup' }
GDIObject class >> startUp [
	self allSubclasses
		do: [:c | c allExistingInstances do: [:o | o sessionStartup]].
	Smalltalk registerExternal: self.
	GDIBitmap startUp]

{ #category : #converting }
GDIObject >> asParameter [
	^handle asParameter]

{ #category : #private }
GDIObject >> fromHandle: anInteger [
	| n memory ulong struct return |
	handle := anInteger.
	handle isNil ifTrue: [^self].
	n := GDILibrary GetObjectW: anInteger cbBuffer: 0 lpvObject: 0.
	memory := (n + 3) externalBytes.
	ulong := memory asInteger + 3 // 4 * 4.
	struct := self class structClass atMemory: ulong pointedMemory.
	return := GDILibrary
		GetObjectW: anInteger
		cbBuffer: n
		lpvObject: struct asParameter.
	return = 0 ifTrue: [^self winError].
	self fromStruct: struct localCopy.
	memory free]

{ #category : #private }
GDIObject >> fromInteger: anInteger [
	handle := anInteger]

{ #category : #accessing }
GDIObject >> handle [
	^handle]

{ #category : #testing }
GDIObject >> isAlive [
	^handle isInteger and: [handle != 0]]

{ #category : #printing }
GDIObject >> printOn: aStream [
	handle isNil ifTrue: [^super printOn: aStream].
	aStream
		nextPutAll: self class name;
		nextPutAll: ' [';
		nextPutAll: handle asString;
		nextPut: $]]

{ #category : #finalization }
GDIObject >> releaseHandle [
	handle := nil]

{ #category : #startup }
GDIObject >> sessionStartup [
	handle isInteger ifTrue: [self releaseHandle]]

