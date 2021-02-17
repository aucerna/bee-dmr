"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DISPLAY_DEVICE,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
DISPLAY_DEVICE class >> def [
	^<def>
	typedef struct _DISPLAY_DEVICE {
		DWORD cb;
		TCHAR DeviceName[32];
		TCHAR DeviceString[128];
		DWORD StateFlags;
		TCHAR DeviceID[128];
		TCHAR DeviceKey[128];
	} DISPLAY_DEVICE, *PDISPLAY_DEVICE;
	</def>]

{ #category : #accessing }
DISPLAY_DEVICE class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
DISPLAY_DEVICE >> cb [
	^self uLongAtOffset: cb]

{ #category : #accessing }
DISPLAY_DEVICE >> cb: anInteger [
	self uLongAtOffset: cb put: anInteger]

{ #category : #accessing }
DISPLAY_DEVICE >> DeviceID [
	^self stringAtOffset: DeviceID count: 128 * 2]

{ #category : #output }
DISPLAY_DEVICE >> deviceID [
	^self DeviceID reduced]

{ #category : #output }
DISPLAY_DEVICE >> deviceKey [
	^self DeviceKey reduced]

{ #category : #accessing }
DISPLAY_DEVICE >> DeviceKey [
	^self stringAtOffset: DeviceKey count: 128 * 2]

{ #category : #accessing }
DISPLAY_DEVICE >> DeviceName [
	^self stringAtOffset: DeviceName count: 32 * 2]

{ #category : #output }
DISPLAY_DEVICE >> deviceName [
	^self DeviceName reduced]

{ #category : #accessing }
DISPLAY_DEVICE >> DeviceString [
	^self stringAtOffset: DeviceString count: 128 * 2]

{ #category : #output }
DISPLAY_DEVICE >> deviceString [
	^self DeviceString reduced]

{ #category : #printing }
DISPLAY_DEVICE >> flagString [
	^String streamContents: [:strm | self printFlagsOn: strm]]

{ #category : #private }
DISPLAY_DEVICE >> hasFlag: anInteger [
	^(self StateFlags bitAnd: anInteger) = anInteger]

{ #category : #initialization }
DISPLAY_DEVICE >> initialize: anInteger [
	super initialize: anInteger.
	self cb: anInteger]

{ #category : #testing }
DISPLAY_DEVICE >> isActive [
	^self hasFlag: DISPLAY_DEVICE_ACTIVE]

{ #category : #testing }
DISPLAY_DEVICE >> isDesktop [
	^self hasFlag: DISPLAY_DEVICE_ATTACHED_TO_DESKTOP]

{ #category : #testing }
DISPLAY_DEVICE >> isPrimary [
	^self hasFlag: DISPLAY_DEVICE_PRIMARY_DEVICE]

{ #category : #testing }
DISPLAY_DEVICE >> isPseudo [
	^self hasFlag: DISPLAY_DEVICE_MIRRORING_DRIVER]

{ #category : #testing }
DISPLAY_DEVICE >> isRemovable [
	^self hasFlag: DISPLAY_DEVICE_REMOVABLE]

{ #category : #testing }
DISPLAY_DEVICE >> isVGACompatible [
	^self hasFlag: DISPLAY_DEVICE_VGA_COMPATIBLE]

{ #category : #printing }
DISPLAY_DEVICE >> printFlagsOn: aStream [
	self isDesktop ifTrue: [aStream nextPutAll: ' [Desktop]'].
	self isPseudo ifTrue: [aStream nextPutAll: ' [Pseudo]'].
	self isRemovable ifTrue: [aStream nextPutAll: ' [Removable]'].
	self isVGACompatible ifTrue: [aStream nextPutAll: ' [VGA+]'].
	self isPrimary ifTrue: [aStream nextPutAll: ' [Primary]']]

{ #category : #printing }
DISPLAY_DEVICE >> printOn: aStream [
	aStream nextPutAll: self deviceString.
	self printFlagsOn: aStream]

{ #category : #accessing }
DISPLAY_DEVICE >> StateFlags [
	^self uLongAtOffset: StateFlags]

{ #category : #marshaling }
DISPLAY_DEVICE >> stringAtOffset: offset count: n [
	| data unicode index |
	data := self bytesAtOffset: offset count: n.
	unicode := UTF16 current decode: data.
	index := unicode findLast: [:ch | ch asInteger > 0].
	^unicode copyFrom: 1 to: index]

