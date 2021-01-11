"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_SERVICE_CONFIG_TIMEOUT_SET,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_SERVICE_CONFIG_TIMEOUT_SET class >> aspects [
	^#(#KeyDesc
		#ParamDesc)]

{ #category : #private }
HTTP_SERVICE_CONFIG_TIMEOUT_SET class >> def [
	^<def>
	typedef struct HTTP_SERVICE_CONFIG_TIMEOUT_SET {
		HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
		HTTP_SERVICE_CONFIG_TIMEOUT_PARAM ParamDesc;
	} HTTP_SERVICE_CONFIG_TIMEOUT_SET, *PHTTP_SERVICE_CONFIG_TIMEOUT_SET;
	</def>]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_TIMEOUT_SET class >> initializeConstants [
	self initializeKeyConstants]

{ #category : #initialization }
HTTP_SERVICE_CONFIG_TIMEOUT_SET class >> initializeKeyConstants [
	WinConstants
		at: 'IdleConnectionTimeout' put: 0;
		at: 'HeaderWaitTimeout' put: 1]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_TIMEOUT_SET class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_TIMEOUT_SET >> KeyDesc [
	^self uLongAtOffset: KeyDesc]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_TIMEOUT_SET >> KeyDesc: anInteger [
	self uLongAtOffset: KeyDesc put: anInteger]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_TIMEOUT_SET >> ParamDesc [
	^self uLongAtOffset: ParamDesc]

{ #category : #accessing }
HTTP_SERVICE_CONFIG_TIMEOUT_SET >> ParamDesc: anInteger [
	self uLongAtOffset: ParamDesc put: anInteger]

