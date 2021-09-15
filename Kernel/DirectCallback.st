"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #DirectCallback, 
	#superclass : #Callback, 
	#instVars : [
		'method'
	], 
	#category : #DirectCallback
}

{#category : #private}
DirectCallback >> asParameter [
	^method nativeCodeAddress
]

{#category : #initialization}
DirectCallback >> initialize [
	| pinned offset |
	super initialize.
	method := (DirectCallback >> #reenterWith:) shallowCopy
		receiver: self;
		invalidateNativeCode;
		prepareForExecution.
	pinned := Smalltalk memory pinnedCopy: method nativeCode.
	offset := pinned at: 1.
	pinned code _objectAtOffset: offset put: pinned.
	method nativeCode: pinned
]

{#category : #private}
DirectCallback >> reenterWith: argsAddress [
	| result array |
	<callback>
	ActiveProcess callbackJustReentered.
	CRITICAL := false.
	result := self performWithArgs: argsAddress.
	array := ByteArray new: WordSize.
	result asParameter marshalOn: array writeStream.
	CRITICAL := true.
	ActiveProcess callbackFinishing.
	^array _basicAt: 1
]

