"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassCommentDefinition,
	#superclass : #ClassChange,
	#instVars : [
		'comment'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ClassCommentDefinition class >> fromClass: aClass [
	^self new fromClass: aClass]

{ #category : #perform }
ClassCommentDefinition >> basicPerform [
	| class |
	class := self resolveClass.
	self propertyAt: #prev put: class comment.
	class comment: self comment]

{ #category : #undo }
ClassCommentDefinition >> canUndo [
	self propertyAt: #prev ifAbsent: [^false].
	^super canUndo]

{ #category : #testing }
ClassCommentDefinition >> changesSomething [
	| class |
	class := self resolveClass ifNil: [^true].
	^class comment != comment]

{ #category : #accessing }
ClassCommentDefinition >> class: aClass [
	className := aClass name.
	aClass isCategorized ifFalse: [^self].
	aClass organization timestamp ifNotNil: [:ts | timestamp := ts].
	author := aClass organization author.
	comment := aClass comment]

{ #category : #accessing }
ClassCommentDefinition >> comment [
	^comment asString]

{ #category : #accessing }
ClassCommentDefinition >> comment: aString [
	comment := aString]

{ #category : #accessing }
ClassCommentDefinition >> currentVersion [
	| cls |
	cls := self resolveClass.
	cls isNil ifTrue: [^super currentVersion].
	^self copy comment: cls comment]

{ #category : #accessing }
ClassCommentDefinition >> fromClass: aClass [
	className := aClass name.
	comment := aClass comment.
	self project: aClass project]

{ #category : #testing }
ClassCommentDefinition >> isOrganizationChange [
	^true]

{ #category : #'filein/out' }
ClassCommentDefinition >> readFrom: aStream [
	| ast |
	ast := self parse: aStream nextChunk.
	comment := ast statements first arguments last value]

{ #category : #'squeak support' }
ClassCommentDefinition >> readFromSqueak: aStream [
	comment := aStream nextSqueakChunk.]

{ #category : #accessing }
ClassCommentDefinition >> sourceCode [
	^className , ' comment: ' , self comment storeString]

{ #category : #accessing }
ClassCommentDefinition >> sourcePosition [
	^comment]

{ #category : #'filein/out' }
ClassCommentDefinition >> squeakFileOutHeader [
	^String streamContents: [:strm | 
		strm
			nextPut: $!;
			nextPutAll: className;
			nextPutAll: ' commentStamp: ';
			nextPut: $';
			nextPutAll: '<historical>';
			nextPut: $';
			nextPutAll: ' prior: 0';
			nextPut: $!]]

{ #category : #'filein/out' }
ClassCommentDefinition >> squeakFileOutOn: aStream [
	aStream nextPutAll: self squeakFileOutHeader; nextChunkPut: comment]

{ #category : #undo }
ClassCommentDefinition >> tip [
	^className , ' comment']

{ #category : #undo }
ClassCommentDefinition >> undo [
	| prev |
	prev := self propertyAt: #prev ifAbsent: [^self].
	self projectChanges class: self resolveClass comment: prev]

