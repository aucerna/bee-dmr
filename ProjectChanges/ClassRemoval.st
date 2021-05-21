"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassRemoval,
	#superclass : #ClassChange,
	#instVars : [
		'prev'
	],
	#category : #ProjectChanges
}

{ #category : #testing }
ClassRemoval >> acceptsAsPrev: aChangeRecord [
	^className = aChangeRecord className
		and: [aChangeRecord isKindOf: ClassDefinition]]

{ #category : #accessing }
ClassRemoval >> basicPerform [
	| class |
	class := self resolveClass.
	class isNil ifTrue: [^nil].
	BeeModule aboutToRemoveClass: class.
	(self project includesClass: class) ifTrue: [self project
		removeClass: class].
	prev := class changeLink.
	class removeFromSystem]

{ #category : #testing }
ClassRemoval >> canOverride: aChangeRecord [
	^aChangeRecord isClassChange
		and: [aChangeRecord className = className]
		and: [aChangeRecord changesJustOneClass]]

{ #category : #accessing }
ClassRemoval >> changeForCurrentVersion [
	| cls |
	cls := self resolveClass.
	^cls isNil ifTrue: [self] ifFalse: [ClassDefinition fromClass: cls]]

{ #category : #testing }
ClassRemoval >> changesSomething [
	^self resolveClass notNil]

{ #category : #'filein/out' }
ClassRemoval >> completeHeaderSpec [
	| spec |
	spec := super completeHeaderSpec.
	spec add: #prev.
	^spec]

{ #category : #accessing }
ClassRemoval >> prev [
	^prev]

{ #category : #accessing }
ClassRemoval >> prev: ref [
	prev := ref]

{ #category : #accessing }
ClassRemoval >> sourceCode [
	^className , ' removeFromSystem']

{ #category : #accessing }
ClassRemoval >> sourcePosition [
	^nil]

{ #category : #undo }
ClassRemoval >> tip [
	^'Removal of class ' , className]

{ #category : #testing }
ClassRemoval >> tracksHistory [
	^true]

{ #category : #undo }
ClassRemoval >> undo [
	self prevChange
		ifNotNil: [:change | self projectChanges
			defineClass: change definition
			notifying: nil]]

