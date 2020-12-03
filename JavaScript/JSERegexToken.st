"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JSERegexToken,
	#superclass : #JSEToken,
	#instVars : [
		'flags',
		'startToken',
		'stopToken'
	],
	#category : #JavaScript
}

{ #category : #accessing }
JSERegexToken >> flags [
	" an optional string "

	^ flags ifNil: [ nil ]]

{ #category : #accessing }
JSERegexToken >> flags: aString [

	flags := aString.]

{ #category : #accessing }
JSERegexToken >> literalValue [
	" use the original string "

	literal isNil 
		ifTrue: [ literal := self value ].
	^ literal]

{ #category : #accessing }
JSERegexToken >> parsedValue: aValue [
	" use the original string "]

