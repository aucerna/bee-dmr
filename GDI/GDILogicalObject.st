"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #GDILogicalObject,
	#superclass : #GDIObject,
	#instVars : [
		'stockObject'
	],
	#category : #GDI
}

{ #category : #services }
GDILogicalObject class >> releaseAll [
	]

{ #category : #'startup/shutdown' }
GDILogicalObject class >> sessionShutdown [
	self releaseAll]

{ #category : #initialization }
GDILogicalObject class >> startUp [
	]

{ #category : #'instance creation' }
GDILogicalObject class >> stockObject: anInteger [
	| handle object |
	handle := GDILibrary GetStockObject: anInteger.
	object := self fromHandle: handle.
	object stockObject: anInteger.
	^object]

{ #category : #accessing }
GDILogicalObject class >> structClass [
	self subclassResponsibility]

{ #category : #private }
GDILogicalObject >> createObject [
	handle isNil ifTrue: [handle := self create].
	self requireFinalization]

{ #category : #finalization }
GDILogicalObject >> finalize [
	| success |
	(handle notNil and: [self isStockObject not]) ifTrue: [
		success := GDILibrary DeleteObject: handle.
		success ifFalse: [self winError].
		handle := nil]]

{ #category : #accessing }
GDILogicalObject >> handle [
	handle isNil ifTrue: [self createObject].
	^handle]

{ #category : #private }
GDILogicalObject >> handle: anInteger [
	self ASSERT: handle isNil.
	handle := anInteger]

{ #category : #testing }
GDILogicalObject >> isStockObject [
	^stockObject notNil]

{ #category : #accessing }
GDILogicalObject >> stockObject: anInteger [
	stockObject := anInteger]

