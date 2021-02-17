"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DEV_BROADCAST_HDR,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
DEV_BROADCAST_HDR class >> def [
	^<def>
	typedef struct _DEV_BROADCAST_HDR {
		DWORD dbch_size;
		DWORD dbch_devicetype;
		DWORD dbch_reserved;
	} DEV_BROADCAST_HDR, *PDEV_BROADCAST_HDR;
	</def>]

{ #category : #accessing }
DEV_BROADCAST_HDR class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
DEV_BROADCAST_HDR >> dbch_devicetype [
	^self uLongAtOffset: dbch_devicetype]

{ #category : #accessing }
DEV_BROADCAST_HDR >> dbch_devicetype: anInteger [
	self uLongAtOffset: dbch_devicetype put: anInteger]

{ #category : #accessing }
DEV_BROADCAST_HDR >> dbch_reserved [
	^self uLongAtOffset: dbch_reserved]

{ #category : #accessing }
DEV_BROADCAST_HDR >> dbch_size [
	^self uLongAtOffset: dbch_size]

{ #category : #accessing }
DEV_BROADCAST_HDR >> dbch_size: anInteger [
	self uLongAtOffset: dbch_size put: anInteger]

{ #category : #initialization }
DEV_BROADCAST_HDR >> initialize: anInteger [
	super initialize: anInteger.
	self dbch_size: anInteger]

{ #category : #accessing }
DEV_BROADCAST_HDR >> sizeInBytes [
	^self dbch_size]

{ #category : #output }
DEV_BROADCAST_HDR >> type [
	| code |
	code := self dbch_devicetype.
	code = DBT_DEVTYP_DEVICEINTERFACE ifTrue: [^'interface'].
	code = DBT_DEVTYP_HANDLE ifTrue: [^'handle'].
	code = DBT_DEVTYP_OEM ifTrue: [^'oem'].
	code = DBT_DEVTYP_PORT ifTrue: [^'port'].
	code = DBT_DEVTYP_VOLUME ifTrue: [^'volume'].
	^'unknown']

