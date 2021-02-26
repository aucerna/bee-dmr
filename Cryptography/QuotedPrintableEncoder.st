"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #QuotedPrintableEncoder,
	#superclass : #Object,
	#instVars : [
		'stream',
		'charCount',
		'lineLength',
		'binaryLineBreakEncoding',
		'binaryWhiteSpaceEncoding',
		'mimeCharset',
		'mimeHeader'
	],
	#category : #Cryptography
}

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encode: aStream [

	^self new encode: aStream.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encode: aStream mimeHeader: mimeHeader mimeCharset: mimeCharset [
	^self new
		mimeHeader: mimeHeader;
		mimeCharset: mimeCharset;
		encode: aStream]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encodeBytes: aByteArray [
	^self new
		binaryLineBreakEncoding: true;
		binaryWhiteSpaceEncoding: true;
		encode: aByteArray asString readStream]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encodeBytes: aByteArray mimeHeader: mimeHeader mimeCharset: mimeCharset [
	^self new
		binaryLineBreakEncoding: true;
		binaryWhiteSpaceEncoding: true;
		mimeHeader: mimeHeader;
		mimeCharset: mimeCharset;
		encode: aByteArray asString readStream]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encodeString: aString [
	^self encode: aString readStream]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder class >> encodeString: aString mimeHeader: mimeHeader mimeCharset: mimeCharset [
	^self
		encode: aString readStream
		mimeHeader: mimeHeader
		mimeCharset: mimeCharset]

{ #category : #'instance creation' }
QuotedPrintableEncoder class >> new [

	^super new initialize; yourself.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> binaryLineBreakEncoding [

	^binaryLineBreakEncoding.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> binaryLineBreakEncoding: aBoolean [

	binaryLineBreakEncoding := aBoolean.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> binaryWhiteSpaceEncoding [

	^binaryWhiteSpaceEncoding.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> binaryWhiteSpaceEncoding: aBoolean [

	binaryWhiteSpaceEncoding := aBoolean.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> encode: aStream [
	"
	See RFC 2045 section 6.7. Quoted-Printable Content-Transfer-Encoding
	"
	aStream atEnd ifTrue: [^String new].
	mimeHeader isNil ifFalse: [
		binaryLineBreakEncoding := true.
		binaryWhiteSpaceEncoding := true.
		charCount := mimeHeader size + 2.
		lineLength := lineLength - 2
		" for the last ?= chars "].
	stream := (String new: aStream size * 15 // 10) writeStream.
	" 50% bigger "
	mimeCharset isNil ifFalse: [
		stream
			nextPutAll: '=?';
			nextPutAll: mimeCharset;
			nextPutAll: '?Q?'.
		charCount := charCount + mimeCharset size + 5].
	[aStream atEnd] whileFalse: [| char byte |
		char := aStream next.
		byte := char asInteger.
		(char isCr or: [char isLf])
			ifTrue: [
				" Rule 4: Hard Line Breaks "
			binaryLineBreakEncoding ifTrue: [self writeHex: byte] ifFalse: [
					(aStream atEnd not and: [aStream peek isLf]) ifTrue: [aStream next].
					self writeHardLineBreak]]
			ifFalse: [
				((byte between: 33 and: 60) or: [byte between: 62 and: 126])
					ifTrue: [" Rule 2: Literal representation "
			self writeChar: char]
					ifFalse: [
						(char isTab or: [char isSpace])
							ifTrue: [" Rule 3: White Space "
			self writeWhiteSpace: char]
							ifFalse: [" Rule 1: General 8bit representation "
			self writeHex: byte]]]].
	self ensureNoWhiteSpaceAtLineEnd.
	mimeCharset notNil ifTrue: [stream nextPutAll: '?='].
	^stream contents]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> ensureNoWhiteSpaceAtLineEnd [
	| char |
	stream position = 0 ifFalse: [
		stream skip: -1.
		char := stream peek.
		(char asInteger = 9 or: [char asInteger = 32])
			ifTrue: [self writeHex: char asInteger]
			ifFalse: [stream next]]]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> initialize [

	charCount := 0.
	lineLength := 76.
	binaryLineBreakEncoding := false.
	binaryWhiteSpaceEncoding := false.
	super initialize.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> lineLength [

	^lineLength.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> lineLength: anInteger [

	lineLength := anInteger.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> mimeCharset [

	^mimeCharset.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> mimeCharset: aString [

	mimeCharset := aString.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> mimeHeader [

	^mimeHeader.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> mimeHeader: aString [

	mimeHeader := aString.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> writeChar: char [
	(mimeCharset notNil and: [char = $_ or: [char = $?]])
		ifTrue: [^self writeHex: char asInteger].
	(charCount = 0 and: [char = $.]) ifTrue: [^self writeHex: char asInteger].
	lineLength isNil
		ifFalse: [charCount + 1 >= lineLength ifTrue: [self writeSoftLineBreak]].
	stream nextPut: char.
	charCount := charCount + 1]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> writeHardLineBreak [

	self ensureNoWhiteSpaceAtLineEnd.
	stream nextPut: Cr; nextPut: Lf.
	charCount := 0.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> writeHex: int [

	lineLength isNil ifFalse: [
		(charCount + 3) >= lineLength ifTrue: [ self writeSoftLineBreak ].
	].
	stream nextPut: $=.
	stream nextPut: ('0123456789ABCDEF' at: ((int bitShift: -4) bitAnd: 15) + 1).
	stream nextPut: ('0123456789ABCDEF' at: (int bitAnd: 15) + 1).
	charCount := charCount + 3.]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> writeSoftLineBreak [

	mimeCharset isNil ifFalse: [ stream nextPutAll: '?' ].
	stream nextPut: $=; 
		nextPut: Cr; 
		nextPut: Lf.
	charCount := 0.
	mimeCharset isNil ifFalse: [ 
		stream nextPutAll: ' =?'; nextPutAll: mimeCharset; nextPutAll: '?Q?'.
		charCount := charCount + mimeCharset size + 6.
	].]

{ #category : #'as yet unclassified' }
QuotedPrintableEncoder >> writeWhiteSpace: char [
	binaryWhiteSpaceEncoding ifTrue: [^self writeHex: char asInteger].
	charCount = 0 ifTrue: [^self writeHex: char asInteger].
	self writeChar: char]

