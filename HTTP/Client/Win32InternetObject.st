"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Win32InternetObject,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
Win32InternetObject class >> new [
	^super new initialize]

{ #category : #converting }
Win32InternetObject >> asParameter [
	^handle asParameter]

{ #category : #'open/close' }
Win32InternetObject >> close [
	| result |
	self isValid ifFalse: [^true].
	result := self dll InternetCloseHandle: self asParameter.
	result ifFalse: [self winError].
	self invalidate; ignoreFinalization.
	^result]

{ #category : #accessing }
Win32InternetObject >> dll [
	^WininetDLL current]

{ #category : #finalization }
Win32InternetObject >> finalizationRegistry [
	^Smalltalk resourceRegistry]

{ #category : #'open/close' }
Win32InternetObject >> finalize [
	self release.
	super finalize]

{ #category : #'os messages' }
Win32InternetObject >> getLastResponseInfo [
	| info length result buffer memory error |
	info := ExternalPointer external fromInteger: 0.
	length := ExternalInt32 external fromInteger: 0.
	result := self dll
		InternetGetLastResponseInfo: info asParameter
		lpszBuffer: 0
		lpdwBufferLength: length asParameter.
	buffer := (length asInteger + 1 * 2) externalBytes.
	result := self dll
		InternetGetLastResponseInfo: info asParameter
		lpszBuffer: buffer asParameter
		lpdwBufferLength: length asParameter.
	result ifFalse: [self winError].
	length free.
	memory := info makeExternalMemory.
	error := memory isValid ifTrue: [WideString fromMemory: memory].
	error := error isNil ifTrue: [''] ifFalse: [' (' , error , ')'].
	^buffer makeUnicode , error]

{ #category : #'os messages' }
Win32InternetObject >> getOption: dwOption [
	^self dll queryOption: dwOption handle: self]

{ #category : #accessing }
Win32InternetObject >> handle [
	^handle]

{ #category : #accessing }
Win32InternetObject >> handle: anExternalHandle [
	handle := anExternalHandle asExternalHandle.
	self requireFinalization]

{ #category : #accessing }
Win32InternetObject >> invalidate [
	handle := nil]

{ #category : #testing }
Win32InternetObject >> isValid [
	^handle notNil and: [handle isValid]]

{ #category : #'open/close' }
Win32InternetObject >> open [
	self subclassResponsibility]

{ #category : #options }
Win32InternetObject >> receiveTimeout [
	| data |
	data := self getOption: INTERNET_OPTION_RECEIVE_TIMEOUT.
	^data asExternalInt32 asInteger / 1000]

{ #category : #options }
Win32InternetObject >> receiveTimeout: seconds [
	self setOption: INTERNET_OPTION_RECEIVE_TIMEOUT to: seconds * 1000]

{ #category : #finalization }
Win32InternetObject >> release [
	self close.
	^super release]

{ #category : #options }
Win32InternetObject >> sendTimeout [
	| data |
	data := self getOption: INTERNET_OPTION_SEND_TIMEOUT.
	^data asExternalInt32 asInteger / 1000]

{ #category : #options }
Win32InternetObject >> sendTimeout: seconds [
	self setOption: INTERNET_OPTION_SEND_TIMEOUT to: seconds * 1000]

{ #category : #startup }
Win32InternetObject >> sessionStartup [
	self invalidate]

{ #category : #'os messages' }
Win32InternetObject >> setOption: option to: value [
	| memory success |
	memory := value isString
		ifTrue: [value externalCopy]
		ifFalse: [value asExternalInt32 externalCopy].
	success := self dll
		InternetSetOption: handle
		dwOption: option
		lpBuffer: memory asParameter
		dwBufferLength: memory length.
	success ifFalse: [self winError].
	memory free]

{ #category : #errors }
Win32InternetObject >> winError: anInteger [
	| description |
	anInteger = 0 ifTrue: [^self].
	description := anInteger = ERROR_INTERNET_EXTENDED_ERROR
		ifTrue: [self getLastResponseInfo].
	^WinInetError signal: description code: anInteger]

