"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTP_STATE_INFO,
	#superclass : #HttpApiStructure,
	#classVars : [
		'Offsets'
	],
	#category : #'HTTP\Server'
}

{ #category : #inspecting }
HTTP_STATE_INFO class >> aspects [
	^#(#Flags
		#State)]

{ #category : #private }
HTTP_STATE_INFO class >> def [
	^<def>
	typedef struct {
		HTTP_PROPERTY_FLAGS Flags;
		HTTP_ENABLED_STATE  State;
	} HTTP_STATE_INFO, *PHTTP_STATE_INFO;
	</def>]

{ #category : #initialization }
HTTP_STATE_INFO class >> initializeConstants [
	self initializeEnableStateConstants]

{ #category : #initialization }
HTTP_STATE_INFO class >> initializeEnableStateConstants [
	WinConstants
		at: 'HttpEnabledStateActive' put: 0;
		at: 'HttpEnabledStateInactive' put: 1]

{ #category : #accessing }
HTTP_STATE_INFO class >> sizeInBytes [
	^sizeInBytes]

{ #category : #accessing }
HTTP_STATE_INFO >> active: aBoolean [
	| state |
	state := aBoolean
		ifTrue: [HttpEnabledStateActive]
		ifFalse: [HttpEnabledStateInactive].
	self Flags: HTTP_PROPERTY_FLAGS present; State: state]

{ #category : #accessing }
HTTP_STATE_INFO >> Flags [
	^self structureAtOffset: Flags ofClass: HTTP_PROPERTY_FLAGS]

{ #category : #accessing }
HTTP_STATE_INFO >> Flags: aHTTP_PROPERTY_FLAGS [
	self bytesAtOffset: Flags put: aHTTP_PROPERTY_FLAGS asParameter]

{ #category : #initialization }
HTTP_STATE_INFO >> initialize: anInteger [
	super initialize: anInteger.
	self Flags: HTTP_PROPERTY_FLAGS present]

{ #category : #testing }
HTTP_STATE_INFO >> isEnabled [
	^self State = HttpEnabledStateActive]

{ #category : #accessing }
HTTP_STATE_INFO >> State [
	^self uLongAtOffset: State]

{ #category : #accessing }
HTTP_STATE_INFO >> State: anInteger [
	self uLongAtOffset: State put: anInteger]

