"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_REQUEST_TOKEN,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Client'
}

{ #category : #private }
HTTP_REQUEST_TOKEN class >> def [
	^<def>
		typedef struct  {
			DWORD connectionId; // 0
			DWORD requestId; // 4
		} HTTP_REQUEST_TOKEN; // sizeInBytes = 8
	</def>]

{ #category : #accessing }
HTTP_REQUEST_TOKEN class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_REQUEST_TOKEN >> connectionId [
	^self uLongAtOffset: connectionId]

{ #category : #accessing }
HTTP_REQUEST_TOKEN >> connectionId: anInteger [
	self uLongAtOffset: connectionId put: anInteger]

{ #category : #accessing }
HTTP_REQUEST_TOKEN >> requestId [
	^self uLongAtOffset: requestId]

{ #category : #accessing }
HTTP_REQUEST_TOKEN >> requestId: anInteger [
	self uLongAtOffset: requestId put: anInteger]

