"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSEToken,
	#superclass : #PPToken,
	#instVars : [
		'type',
		'literal',
		'hasPreceedingLineTerminator'
	],
	#category : #JavaScript
}

{ #category : #'instance creation' }
JSEToken class >> on: aString type: type literalValue: literalValue [
	^(self on: aString)
		type: type;
		literalValue: literalValue;
		yourself]

{ #category : #accessing }
JSEToken >> hasPreceedingLineTerminator [
	" true if there was at least one line terminator before this token "

	^ hasPreceedingLineTerminator ifNil: [ false ]]

{ #category : #accessing }
JSEToken >> hasPreceedingLineTerminator: aHasPreceedingLineTerminator [

	hasPreceedingLineTerminator := aHasPreceedingLineTerminator.]

{ #category : #accessing }
JSEToken >> literalValue [

	^ literal]

{ #category : #accessing }
JSEToken >> literalValue: aLiteralValue [
	literal := aLiteralValue]

{ #category : #accessing }
JSEToken >> parsedValue: aValue [
	" aValue is the result of the parser "

	self literalValue: aValue]

{ #category : #accessing }
JSEToken >> type [

	^ type]

{ #category : #accessing }
JSEToken >> type: aType [

	type := aType.]

{ #category : #accessing }
JSEToken >> value [

	^ (start = 1 and: [ stop = collection size ])
		ifTrue: [ collection ]
		ifFalse: [ super value ]]

