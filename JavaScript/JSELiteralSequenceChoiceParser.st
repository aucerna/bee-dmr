"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSELiteralSequenceChoiceParser,
	#superclass : #PPParser,
	#instVars : [
		'message',
		'literals',
		'maxSize'
	],
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSELiteralSequenceChoiceParser class >> on: literals [
	^ self on: literals message: 'any of ', literals printString , ' expected']

{ #category : #'instance creation' }
JSELiteralSequenceChoiceParser class >> on: literals message: aString [
	" matches the longest literal sequence "

	^ self new initializeOn: literals message: aString]

{ #category : #initialization }
JSELiteralSequenceChoiceParser >> initializeOn: aCollection message: aString [
	message := aString.
	literals := Dictionary new.
	maxSize := 0.
	aCollection do: [:literal | 
		(literals at: literal size ifAbsentPut: [Set new]) add: literal.
		maxSize := maxSize max: literal size]]

{ #category : #initialization }
JSELiteralSequenceChoiceParser >> parseOn: aStream [
	| position readSize bestMatch literalStream |
	position := aStream position.
	readSize := 0.
	bestMatch := nil.
	literalStream := (String new: maxSize) writeStream.
	[readSize < maxSize and: [aStream atEnd not]] whileTrue: [
		literalStream nextPut: aStream next.
		readSize := readSize + 1.
		literals at: readSize ifPresent: [:buckets | | literal |
			literal := literalStream contents.
			(buckets includes: literal) ifTrue: [
				bestMatch := literal.
				position := aStream position]]].
	aStream position: position.
	^bestMatch ifNil: [PPFailure message: message from: aStream]]

