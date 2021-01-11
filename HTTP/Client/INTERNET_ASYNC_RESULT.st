"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #INTERNET_ASYNC_RESULT,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Client'
}

{ #category : #accessing }
INTERNET_ASYNC_RESULT class >> def [
	^<def>
	typedef struct {
		DWORD_PTR dwResult;
		DWORD     dwError;
	} INTERNET_ASYNC_RESULT, * LPINTERNET_ASYNC_RESULT;
	</def>]

{ #category : #private }
INTERNET_ASYNC_RESULT class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 16;
		at: 'dwResult' put: 0;
		at: 'dwError' put: 8;
		yourself]

{ #category : #accessing }
INTERNET_ASYNC_RESULT class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
INTERNET_ASYNC_RESULT >> dwError [
	^self uLongAtOffset: dwError]

{ #category : #accessing }
INTERNET_ASYNC_RESULT >> dwResult [
	^self pointerAtOffset: dwResult]

{ #category : #output }
INTERNET_ASYNC_RESULT >> error [
	^self dwError]

{ #category : #output }
INTERNET_ASYNC_RESULT >> handle [
	^self dwResult asExternalHandle]

{ #category : #testing }
INTERNET_ASYNC_RESULT >> hasError [
	^self error != ERROR_SUCCESS]

{ #category : #output }
INTERNET_ASYNC_RESULT >> success [
	^self dwResult asBoolean]

