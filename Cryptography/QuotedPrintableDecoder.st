"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #QuotedPrintableDecoder,
	#superclass : #Object,
	#instVars : [
		'writer',
		'reader'
	],
	#classVars : [
		'Enter'
	],
	#category : #Cryptography
}

{ #category : #public }
QuotedPrintableDecoder class >> decode: aStream [
	| decoder |
	decoder := self on: aStream.
	^decoder contents]

{ #category : #public }
QuotedPrintableDecoder class >> decodeString: aString [
	^self decode: aString readStream]

{ #category : #initialization }
QuotedPrintableDecoder class >> initialize [
	"
	QuotedPrintableDecoder initialize
	"
	super initialize.
	Enter := Character cr , Character lf]

{ #category : #'instance creation' }
QuotedPrintableDecoder class >> new [
	^super new initialize]

{ #category : #'instance creation' }
QuotedPrintableDecoder class >> on: aStream [
	^self new on: aStream]

{ #category : #references }
QuotedPrintableDecoder class >> reference1 [
	'http://www.freesoft.org/CIE/RFC/1521/6.htm' asURL browse]

{ #category : #references }
QuotedPrintableDecoder class >> reference2 [
	'http://tools.ietf.org/html/rfc2045#section-6.7' asURL browse]

{ #category : #testing }
QuotedPrintableDecoder >> atEnd [
	^reader atEnd]

{ #category : #public }
QuotedPrintableDecoder >> contents [
	^writer contents]

{ #category : #public }
QuotedPrintableDecoder >> decode [
	[self atEnd] whileFalse: [| plain code |
		plain := reader throughAll: '='.
		self write: plain.
		self atEnd ifFalse: [
			code := self nextCode.
			code = Enter ifFalse: [self nextPutCode: code]]]]

{ #category : #private }
QuotedPrintableDecoder >> decodeSpecial: code [
	^(code size = 2 and: [code first isHexDigit] and: [code second isHexDigit])
		ifTrue: [Character
			value: code first digitValue * 16 + code second digitValue]
		ifFalse: ['=' , code]]

{ #category : #initialization }
QuotedPrintableDecoder >> initialize [
	super initialize.
	writer := '' writeStream]

{ #category : #private }
QuotedPrintableDecoder >> nextCode [
	| code |
	code := reader peek: 2.
	reader skip: code size.
	^code]

{ #category : #private }
QuotedPrintableDecoder >> nextPutCode: code [
	| char |
	char := self decodeSpecial: code.
	writer nextPutAll: char asString]

{ #category : #public }
QuotedPrintableDecoder >> on: aStream [
	reader := aStream.
	writer reset.
	self decode]

{ #category : #private }
QuotedPrintableDecoder >> write: aString [
	| stream line |
	stream := aString readStream.
	[stream atEnd] whileFalse: [
		line := stream throughAll: Enter.
		(line endsWith: Enter)
			ifTrue: [writer nextPutAll: line trimTrailingBlanks; nextPutAll: Enter]
			ifFalse: [
				(line endsWith: '=')
					ifTrue: [line := line allButLast]
					ifFalse: [self atEnd ifTrue: [line := line trimTrailingBlanks]].
				writer nextPutAll: line]]]

