"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DEVNAMES,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
DEVNAMES class >> def [
	^<def>
	typedef struct tagDEVNAMES {
		WORD wDriverOffset;
		WORD wDeviceOffset;
		WORD wOutputOffset;
		WORD wDefault;
	} DEVNAMES, *LPDEVNAMES;
	</def>]

{ #category : #'instance creation' }
DEVNAMES class >> from: aDEVNAMES [
	^self new from: aDEVNAMES]

{ #category : #'instance creation' }
DEVNAMES class >> fromMemory: anExternalMemory [
	| struct |
	struct := self atMemory: anExternalMemory.
	^self from: struct]

{ #category : #accessing }
DEVNAMES class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
DEVNAMES >> default: aBoolean [
	self wDefault: aBoolean asParameter]

{ #category : #output }
DEVNAMES >> device [
	^self dnDevice]

{ #category : #output }
DEVNAMES >> dnDevice [
	^self stringAtOffset: self wDeviceOffset * 2]

{ #category : #input }
DEVNAMES >> dnDevice: aByteArray [
	self bytesAtOffset: self wDeviceOffset * 2 put: aByteArray]

{ #category : #output }
DEVNAMES >> dnDriver [
	^self stringAtOffset: self wDriverOffset * 2]

{ #category : #input }
DEVNAMES >> dnDriver: aByteArray [
	self bytesAtOffset: self wDriverOffset * 2 put: aByteArray]

{ #category : #output }
DEVNAMES >> dnOutput [
	^self stringAtOffset: self wOutputOffset * 2]

{ #category : #input }
DEVNAMES >> dnOutput: aByteArray [
	self bytesAtOffset: self wOutputOffset * 2 put: aByteArray]

{ #category : #output }
DEVNAMES >> driver [
	^self dnDriver]

{ #category : #private }
DEVNAMES >> from: aDEVNAMES [
	| driver device output size offset |
	driver := aDEVNAMES driver utf16z.
	device := aDEVNAMES device utf16z.
	output := aDEVNAMES output utf16z.
	size := self class sizeInBytes + driver sizeInBytes + device sizeInBytes
		+ output sizeInBytes.
	self initialize: size external: false.
	offset := self class sizeInBytes // 2.
	self wDriverOffset: offset; dnDriver: driver.
	offset := offset + (driver size // 2).
	self wDeviceOffset: offset; dnDevice: device.
	offset := offset + (device size // 2).
	self wOutputOffset: offset; dnOutput: output.
	self default: aDEVNAMES isDefault]

{ #category : #testing }
DEVNAMES >> isDefault [
	^self wDefault = DN_DEFAULTPRN]

{ #category : #output }
DEVNAMES >> output [
	^self dnOutput]

{ #category : #testing }
DEVNAMES >> printsToFile [
	self output includesString: 'FILE:']

{ #category : #accessing }
DEVNAMES >> wDefault [
	^self uShortAtOffset: wDefault]

{ #category : #accessing }
DEVNAMES >> wDefault: anInteger [
	self uShortAtOffset: wDefault put: anInteger]

{ #category : #accessing }
DEVNAMES >> wDeviceOffset [
	^self uShortAtOffset: wDeviceOffset]

{ #category : #accessing }
DEVNAMES >> wDeviceOffset: anInteger [
	self uShortAtOffset: wDeviceOffset put: anInteger]

{ #category : #accessing }
DEVNAMES >> wDriverOffset [
	^self uShortAtOffset: wDriverOffset]

{ #category : #accessing }
DEVNAMES >> wDriverOffset: anInteger [
	self uShortAtOffset: wDriverOffset put: anInteger]

{ #category : #accessing }
DEVNAMES >> wOutputOffset [
	^self uShortAtOffset: wOutputOffset]

{ #category : #accessing }
DEVNAMES >> wOutputOffset: anInteger [
	self uShortAtOffset: wOutputOffset put: anInteger]

