"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_CACHE_POLICY,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_CACHE_POLICY class >> aspects [
	^#(#Policy
		#SecondsToLive)]

{ #category : #private }
HTTP_CACHE_POLICY class >> def [
	^<def>
	typedef struct _HTTP_CACHE_POLICY {
		HTTP_CACHE_POLICY_TYPE Policy;
		ULONG                  SecondsToLive;
	} HTTP_CACHE_POLICY, *PHTTP_CACHE_POLICY;
	</def>]

{ #category : #'instance creation' }
HTTP_CACHE_POLICY class >> forSeconds: anInteger [
	^self new forSeconds: anInteger]

{ #category : #initialization }
HTTP_CACHE_POLICY class >> initializeConstants [
	self initializePolicyTypeConstants]

{ #category : #initialization }
HTTP_CACHE_POLICY class >> initializePolicyTypeConstants [
	WinConstants
		at: 'HttpCachePolicyNocache' put: 0;
		at: 'HttpCachePolicyUserInvalidates' put: 1;
		at: 'HttpCachePolicyTimeToLive' put: 2;
		at: 'HttpCachePolicyMaximum' put: 3]

{ #category : #accessing }
HTTP_CACHE_POLICY class >> sizeInBytes [
	^sizeInBytes]

{ #category : #'instance creation' }
HTTP_CACHE_POLICY class >> timeless [
	^self new timeless]

{ #category : #private }
HTTP_CACHE_POLICY class >> typedefTable [
	^HttpApiDLL typedefTable]

{ #category : #input }
HTTP_CACHE_POLICY >> forSeconds: anInteger [
	anInteger isInteger
		ifTrue: [self Policy: HttpCachePolicyTimeToLive; SecondsToLive: anInteger]
		ifFalse: [self timeless]]

{ #category : #accessing }
HTTP_CACHE_POLICY >> Policy [
	^self uLongAtOffset: Policy]

{ #category : #accessing }
HTTP_CACHE_POLICY >> Policy: anInteger [
	self uLongAtOffset: Policy put: anInteger]

{ #category : #accessing }
HTTP_CACHE_POLICY >> SecondsToLive [
	^self uLongAtOffset: SecondsToLive]

{ #category : #accessing }
HTTP_CACHE_POLICY >> SecondsToLive: anInteger [
	self uLongAtOffset: SecondsToLive put: anInteger]

{ #category : #input }
HTTP_CACHE_POLICY >> timeless [
	self Policy: HttpCachePolicyUserInvalidates; SecondsToLive: 0]

