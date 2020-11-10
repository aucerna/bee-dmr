"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlParserError,
	#superclass : #Error,
	#instVars : [
		'expression'
	],
	#category : #FML
}

{ #category : #signaling }
FmlParserError class >> expression: aString signal: messageText [
	^self new description: messageText; expression: aString; signal]

{ #category : #accessing }
FmlParserError >> expression [
	^expression]

{ #category : #accessing }
FmlParserError >> expression: aString [
	expression := aString]

{ #category : #testing }
FmlParserError >> isUnknownFunction [
	^self description asLowercase includesString: 'unknown function']

