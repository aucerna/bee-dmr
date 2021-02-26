"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #EncoderParameters,
	#superclass : #GdiPlusStructure,
	#classVars : [
		'Offsets'
	],
	#category : #GDIPlus
}

{ #category : #inspecting }
EncoderParameters class >> aspects [
	^super aspects , #(#parameters)]

{ #category : #private }
EncoderParameters class >> def [
	^<def>
	typedef struct EncoderParameters {
		UINT Count;
		EncoderParameter Parameter[1];
	} EncoderParameters;
	</def>]

{ #category : #private }
EncoderParameters class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 8;
		at: 'Count' put: 0;
		at: 'Parameter' put: 8;
		yourself]

{ #category : #accessing }
EncoderParameters class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
EncoderParameters >> Count [
	^self uLongAtOffset: Count]

{ #category : #accessing }
EncoderParameters >> Count: anInteger [
	self uLongAtOffset: Count put: anInteger]

{ #category : #accessing }
EncoderParameters >> Parameter [
	^self
		bytesAtOffset: Parameter
		count: self Count * EncoderParameter sizeInBytes]

{ #category : #accessing }
EncoderParameters >> Parameter: aByteArray [
	self
		bytesAtOffset: Parameter put: aByteArray;
		Count: aByteArray size // EncoderParameter sizeInBytes]

{ #category : #outputs }
EncoderParameters >> parameters [
	^BufferArray new
		contents: self Parameter;
		count: self Count;
		type: EncoderParameter;
		asArray]

{ #category : #outputs }
EncoderParameters >> parameters: aCollection [
	| buffer |
	buffer := BufferArray on: aCollection type: EncoderParameter.
	self Parameter: buffer asParameter]

{ #category : #accessing }
EncoderParameters >> sizeInBytes [
	^Parameter + (self Count * EncoderParameter sizeInBytes)]

