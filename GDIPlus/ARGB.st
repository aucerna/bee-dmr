"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ARGB,
	#superclass : #ExternalInt32,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #accessing }
ARGB class >> def [
	^<def>
	typedef struct addrinfo {
		BYTE blue;
		BYTE green;
		BYTE red;
		BYTE alpha;
	} ARGB;
	</def>]

{ #category : #'instance creation' }
ARGB class >> from: aColor [
	^self new from: aColor asARGBColor]

{ #category : #'instance creation' }
ARGB class >> fromColor: aColor [
	^self from: aColor]

{ #category : #'instance creation' }
ARGB class >> fromInteger: anInteger [
	^self new
		alpha: (anInteger bitShift: -24);
		red: ((anInteger bitShift: -16) bitAnd: 255);
		green: ((anInteger bitShift: -8) bitAnd: 255);
		blue: (anInteger bitAnd: 255)]

{ #category : #accessing }
ARGB >> alpha [
	^self byteAtOffset: alpha]

{ #category : #accessing }
ARGB >> alpha: anInteger [
	self byteAtOffset: alpha put: anInteger]

{ #category : #accessing }
ARGB >> alphaLevel [
	^self alpha asFloat / 255.0]

{ #category : #converting }
ARGB >> asColor [
	^ARGBColor
		alpha: self alpha
		red: self red
		green: self green
		blue: self blue]

{ #category : #converting }
ARGB >> asInteger [
	^(self alpha bitShift: 24) + (self red bitShift: 16) + (self green
		bitShift: 8)
		+ self blue]

{ #category : #accessing }
ARGB >> blue [
	^self byteAtOffset: blue]

{ #category : #accessing }
ARGB >> blue: anInteger [
	self byteAtOffset: blue put: anInteger]

{ #category : #accessing }
ARGB >> from: anARGBColor [
	self
		alpha: anARGBColor alpha;
		red: anARGBColor red;
		green: anARGBColor green;
		blue: anARGBColor blue]

{ #category : #accessing }
ARGB >> green [
	^self byteAtOffset: green]

{ #category : #accessing }
ARGB >> green: anInteger [
	self byteAtOffset: green put: anInteger]

{ #category : #printing }
ARGB >> printOn: aStream [
	aStream
		nextPutAll: self class name , ' { ' , self asColor printString , ' } ']

{ #category : #accessing }
ARGB >> red [
	^self byteAtOffset: red]

{ #category : #accessing }
ARGB >> red: anInteger [
	self byteAtOffset: red put: anInteger]

