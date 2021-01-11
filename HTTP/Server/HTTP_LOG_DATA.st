"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_LOG_DATA,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_LOG_DATA class >> aspects [
	^#(#Type)]

{ #category : #private }
HTTP_LOG_DATA class >> def [
	^<def>
	typedef struct _HTTP_LOG_DATA {
		HTTP_LOG_DATA_TYPE  Type;
	} HTTP_LOG_DATA, *PHTTP_LOG_DATA;
	</def>]

{ #category : #accessing }
HTTP_LOG_DATA class >> sizeInBytes [
	^sizeInBytes]

{ #category : #private }
HTTP_LOG_DATA class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #accessing }
HTTP_LOG_DATA >> Type [
	^self uLongAtOffset: Type]

{ #category : #accessing }
HTTP_LOG_DATA >> Type: anInteger [
	self uLongAtOffset: Type put: anInteger]

