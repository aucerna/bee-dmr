"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #BrokenChange,
	#superclass : #ChangeRecord,
	#instVars : [
		'string'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
BrokenChange class >> on: aString [
	^self new string: aString]

{ #category : #perform }
BrokenChange >> basicPerform [
	Warning signal: 'Broken change cannnot be performed'.
	^nil]

{ #category : #testing }
BrokenChange >> changesSomething [
	^false]

{ #category : #testing }
BrokenChange >> isBroken [
	^true]

{ #category : #testing }
BrokenChange >> isLoggable [
	^false]

{ #category : #'filein/out' }
BrokenChange >> readFrom: aStream [
	string := aStream nextChunk]

{ #category : #'filein/out' }
BrokenChange >> sourceCode [
	^string storeString]

{ #category : #accessing }
BrokenChange >> string: aString [
	string := aString]

