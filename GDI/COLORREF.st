"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #COLORREF,
	#superclass : #ExternalInt32,
	#classVars : [
		'Offsets'
	],
	#category : #GDI
}

{ #category : #accessing }
COLORREF class >> def [
	^<def>
typedef struct COLORREF {
	union  {
			struct  {
					BYTE byRed; // 0
					BYTE byGreen; // 1
					BYTE byBlue; // 2
					BYTE byAlpha; // 3
				}; // sizeInBytes = 4 ; // 0
			DWORD c; // 0
		}; // sizeInBytes = 4 ; // 0
} COLORREF; // sizeInBytes = 4
	</def>]

{ #category : #'instance creation' }
COLORREF class >> from: aColor [
	aColor isColor ifTrue: [^self fromColor: aColor].
	aColor = -1 ifTrue: [^self usingBytes: #[16rFF 16rFF 16rFF 16rFF]].
	self error: 'invalid color argument']

{ #category : #'instance creation' }
COLORREF class >> fromColor: aColor [
	^self new from: aColor]

{ #category : #'instance creation' }
COLORREF class >> fromInteger: anInteger [
	^self new longAtOffset: 0 put: anInteger; yourself]

{ #category : #accessing }
COLORREF class >> sizeInBytes [
	^4]

{ #category : #converting }
COLORREF >> asColor [
	^Color red: self red green: self green blue: self blue]

{ #category : #converting }
COLORREF >> asInteger [
	^self longAtOffset: byRed]

{ #category : #output }
COLORREF >> blue [
	^self byBlue]

{ #category : #input }
COLORREF >> blue: anInteger [
	self byBlue: anInteger]

{ #category : #accessing }
COLORREF >> byBlue [
	^self byteAtOffset: byBlue]

{ #category : #accessing }
COLORREF >> byBlue: anInteger [
	self byteAtOffset: byBlue put: anInteger]

{ #category : #accessing }
COLORREF >> byGreen [
	^self byteAtOffset: byGreen]

{ #category : #accessing }
COLORREF >> byGreen: anInteger [
	self byteAtOffset: byGreen put: anInteger]

{ #category : #accessing }
COLORREF >> byRed [
	^self byteAtOffset: byRed]

{ #category : #accessing }
COLORREF >> byRed: anInteger [
	self byteAtOffset: byRed put: anInteger]

{ #category : #accessing }
COLORREF >> from: aColor [
	self
		red: aColor red;
		green: aColor green;
		blue: aColor blue]

{ #category : #output }
COLORREF >> green [
	^self byGreen]

{ #category : #input }
COLORREF >> green: anInteger [
	self byGreen: anInteger]

{ #category : #printing }
COLORREF >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPutAll: ' (16r';
		nextPutAll: self asInteger hex;
		nextPut: $)]

{ #category : #output }
COLORREF >> red [
	^self byRed]

{ #category : #accessing }
COLORREF >> red: anInteger [
	self byRed: anInteger]

