"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SCOPE_ID,
	#superclass : #WindowsStructure,
	#classVars : [
		'Offsets'
	],
	#category : #sockets
}

{ #category : #private }
SCOPE_ID class >> def [
	^<def>
	typedef struct {
		union {
			struct {
				ULONG  Zone;
				ULONG  Level;
			};
		ULONG  Value;
		};
	} SCOPE_ID, *PSCOPE_ID;
	</def>]

{ #category : #private }
SCOPE_ID class >> offsets64 [
	^PoolDictionary new
		at: 'sizeInBytes' put: 4;
		at: 'Zone' put: 0;
		at: 'Level' put: 3;
		at: 'Value' put: 0;
		yourself]

{ #category : #accessing }
SCOPE_ID class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
SCOPE_ID >> Level [
	^self uLongAtOffset: Level]

{ #category : #accessing }
SCOPE_ID >> Level: anInteger [
	self uLongAtOffset: Level put: anInteger]

{ #category : #accessing }
SCOPE_ID >> Value [
	^self uLongAtOffset: Value]

{ #category : #accessing }
SCOPE_ID >> Value: anInteger [
	self uLongAtOffset: Value put: anInteger]

{ #category : #accessing }
SCOPE_ID >> Zone [
	^self uLongAtOffset: Zone]

{ #category : #accessing }
SCOPE_ID >> Zone: anInteger [
	self uLongAtOffset: Zone put: anInteger]

