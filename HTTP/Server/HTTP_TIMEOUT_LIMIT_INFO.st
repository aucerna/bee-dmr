"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_TIMEOUT_LIMIT_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_TIMEOUT_LIMIT_INFO class >> aspects [
	^#(#Flags
		#entityBody
		#drainEntityBody
		#requestQueue
		#idleConnection
		#headerWait
		#minSendRate)]

{ #category : #private }
HTTP_TIMEOUT_LIMIT_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS Flags;
		USHORT              EntityBody;
		USHORT              DrainEntityBody;
		USHORT              RequestQueue;
		USHORT              IdleConnection;
		USHORT              HeaderWait;
		ULONG               MinSendRate;
	} HTTP_TIMEOUT_LIMIT_INFO, *PHTTP_TIMEOUT_LIMIT_INFO;
	</def>]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> disableMinSendRate [
	self MinSendRate: -1]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> DrainEntityBody [
	^self uShortAtOffset: DrainEntityBody]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> drainEntityBody [
	| timer |
	timer := self DrainEntityBody.
	^timer = 0 ifTrue: [120] ifFalse: [timer]]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> DrainEntityBody: anInteger [
	self uShortAtOffset: DrainEntityBody put: anInteger]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> drainEntityBody: ms [
	self Flags: HTTP_PROPERTY_FLAGS present; DrainEntityBody: ms]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> entityBody [
	| timer |
	timer := self EntityBody.
	^timer = 0 ifTrue: [120] ifFalse: [timer]]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> EntityBody [
	^self uShortAtOffset: EntityBody]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> entityBody: ms [
	self Flags: HTTP_PROPERTY_FLAGS present; EntityBody: ms]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> EntityBody: anInteger [
	self uShortAtOffset: EntityBody put: anInteger]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> HeaderWait [
	^self uShortAtOffset: HeaderWait]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> headerWait [
	| timer |
	timer := self HeaderWait.
	^timer = 0 ifTrue: [120] ifFalse: [timer]]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> headerWait: ms [
	self Flags: HTTP_PROPERTY_FLAGS present; HeaderWait: ms]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> HeaderWait: anInteger [
	self uShortAtOffset: HeaderWait put: anInteger]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> idleConnection [
	| timer |
	timer := self IdleConnection.
	^timer = 0 ifTrue: [120] ifFalse: [timer]]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> IdleConnection [
	^self uShortAtOffset: IdleConnection]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> idleConnection: ms [
	self Flags: HTTP_PROPERTY_FLAGS present; IdleConnection: ms]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> IdleConnection: anInteger [
	self uShortAtOffset: IdleConnection put: anInteger]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> initialize: n [
	super initialize: n.
	self Flags: HTTP_PROPERTY_FLAGS present]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> MinSendRate [
	^self uLongAtOffset: MinSendRate]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> minSendRate [
	| timer |
	timer := self MinSendRate.
	^timer = 0 ifTrue: [150] ifFalse: [timer]]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> minSendRate: bps [
	self Flags: HTTP_PROPERTY_FLAGS present; MinSendRate: bps]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> MinSendRate: anInteger [
	self uLongAtOffset: MinSendRate put: anInteger]

{ #category : #output }
HTTP_TIMEOUT_LIMIT_INFO >> requestQueue [
	| timer |
	timer := self RequestQueue.
	^timer = 0 ifTrue: [120] ifFalse: [timer]]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> RequestQueue [
	^self uShortAtOffset: RequestQueue]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> requestQueue: ms [
	self Flags: HTTP_PROPERTY_FLAGS present; RequestQueue: ms]

{ #category : #accessing }
HTTP_TIMEOUT_LIMIT_INFO >> RequestQueue: anInteger [
	self uShortAtOffset: RequestQueue put: anInteger]

{ #category : #input }
HTTP_TIMEOUT_LIMIT_INFO >> useDefaults [
	self
		Flags: HTTP_PROPERTY_FLAGS present;
		DrainEntityBody: 0;
		EntityBody: 0;
		HeaderWait: 0;
		IdleConnection: 0;
		MinSendRate: 0;
		RequestQueue: 0]

