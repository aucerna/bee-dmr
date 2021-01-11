"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_PROPERTY_FLAGS,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
HTTP_PROPERTY_FLAGS class >> absent [
	^self new]

{ #category : #inspecting }
HTTP_PROPERTY_FLAGS class >> aspects [
	^#(#Present)]

{ #category : #accessing }
HTTP_PROPERTY_FLAGS class >> def [
	^<def>
	typedef struct {
		ULONG Present:1;
	}HTTP_PROPERTY_FLAGS, *PHTTP_PROPERTY_FLAGS;
	</def>]

{ #category : #'instance creation' }
HTTP_PROPERTY_FLAGS class >> present [
	^self new bePresent]

{ #category : #'instance creation' }
HTTP_PROPERTY_FLAGS class >> present: aBoolean [
	^aBoolean ifTrue: [self present] ifFalse: [self absent]]

{ #category : #accessing }
HTTP_PROPERTY_FLAGS class >> sizeInBytes [
	^sizeInBytes]

{ #category : #input }
HTTP_PROPERTY_FLAGS >> bePresent [
	self Present: 1]

{ #category : #accessing }
HTTP_PROPERTY_FLAGS >> Present [
	^self uLongAtOffset: Present]

{ #category : #accessing }
HTTP_PROPERTY_FLAGS >> Present: anInteger [
	self uLongAtOffset: Present put: anInteger]

