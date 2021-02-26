"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #QuotedPrintableValidator,
	#superclass : #DomainValidator,
	#instVars : [
		'stream'
	],
	#category : #Cryptography
}

{ #category : #all }
QuotedPrintableValidator >> checkCharacter: aCharacter [
	aCharacter isCr ifTrue: [^self].
	aCharacter isLf ifTrue: [^self].
	aCharacter isTab ifTrue: [^self].
	(aCharacter between: $  and: $~) ifFalse: [
		self
			failBecause: self prettyPrint , ' includes the invalid character '
				, aCharacter name
				, ' at position '
				, stream position printString]]

{ #category : #all }
QuotedPrintableValidator >> checkCode [
	| code c1 c2 |
	code := stream peek: 2.
	code size = 2
		ifFalse: [self failBecause: self prettyPrint , ' has an unexpected end'].
	stream skip: 2.
	c1 := code first.
	c2 := code second.
	(c1 isCr and: [c2 isLf]) ifTrue: [^self].
	((c1 isDigit or: [c1 isHexDigit and: [c1 isUppercase]])
		and: [c2 isDigit or: [c2 isHexDigit and: [c2 isUppercase]]])
		ifFalse: [
			self
				failBecause: self prettyPrint , ' includes the invalid code ' , code
					, ' at position '
					, (stream position - 2) printString]]

{ #category : #emphasis }
QuotedPrintableValidator >> emphasize: aString [
	^self newRtf underline: aString]

{ #category : #all }
QuotedPrintableValidator >> prettyPrint [
	^self emphasize: 'Quoted-Printable string']

{ #category : #all }
QuotedPrintableValidator >> validate [
	| ch |
	stream := object readStream.
	[stream atEnd] whileFalse: [
		ch := stream next.
		ch = $= ifTrue: [self checkCode] ifFalse: [self checkCharacter: ch]]]

