"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HtmlPListSerializer,
	#superclass : #Object,
	#instVars : [
		'stream',
		'arrayItemsPerLine',
		'dictionaryItemsPerLine',
		'indentLevel'
	],
	#classVars : [
		'ReadTranslations',
		'WriteTranslations'
	],
	#category : #CSS
}

{ #category : #'class initialization' }
HtmlPListSerializer class >> initialize [
	ReadTranslations notNil ifTrue: [^self].
	ReadTranslations := Dictionary new.
	ReadTranslations
		at: $" put: $";
		at: $' put: $';
		at: $\ put: $\;
		at: $n put: Character cr;
		at: $r put: Character cr;
		at: $t put: Character tab.
	WriteTranslations := Dictionary new.
	WriteTranslations
		at: Character tab put: '\t';
		at: Character cr put: '\n';
		at: $" put: '\"';
		at: $' put: '\' , $' asString;
		at: $\ put: '\\']

{ #category : #'instance creation' }
HtmlPListSerializer class >> on: aStream [
	self initialize.
	^self basicNew on: aStream]

{ #category : #initialize }
HtmlPListSerializer >> close [
	stream close.
	stream := nil]

{ #category : #reading }
HtmlPListSerializer >> next [
	^self read]

{ #category : #reading }
HtmlPListSerializer >> nextPut: anObject [
	self write: anObject]

{ #category : #initialize }
HtmlPListSerializer >> on: aStream [
	stream := aStream.
	(stream respondsTo: #ascii) ifTrue: [stream ascii].
	arrayItemsPerLine := 5.
	dictionaryItemsPerLine := 3.
	indentLevel := 0]

{ #category : #reading }
HtmlPListSerializer >> read [
	| c |
	self skipWhitespace.
	c := stream peek.
	^c = ${ ifTrue: [self readDictionary] ifFalse: [
		c = $(
			ifTrue: [self readArray]
			ifFalse: [c = $"
				ifTrue: [self readQuotedString]
				ifFalse: [self readString]]]]

{ #category : #reading }
HtmlPListSerializer >> readArray [
	| item list |
	self skipWhitespace.
	stream peek = $(
		ifTrue: [
			stream next.
			self skipWhitespace.
			list := OrderedCollection new.
			[stream peek = $)] whileFalse: [
				item := self read.
				list add: item.
				self skipWhitespace.
				stream peek = $, ifTrue: [
					stream next.
					self skipWhitespace]].
			stream next
			"consume the trailing paren"]
		ifFalse: [
		"error of some sort here"].
	^list]

{ #category : #reading }
HtmlPListSerializer >> readDictionary [
	| c key value dict |
	self skipWhitespace.
	c := stream next.
	c = ${
		ifTrue: [
			dict := Dictionary new.
			self skipWhitespace.
			[stream peek = $}] whileFalse: [
				key := self read.
				self skipWhitespace.
				c := stream next.
				c = $= ifFalse: [self error: 'expected = here'].
				value := self read.
				self skipWhitespace.
				c := stream next.
				c = $; ifFalse: [self error: 'expected ; here'].
				self skipWhitespace.
				dict at: key put: value].
			stream next]
		ifFalse: [self error: 'not a dictionary'].
	^dict]

{ #category : #reading }
HtmlPListSerializer >> readQuotedString [
	| out c |
	out := String new writeStream.
	self skipWhitespace.
	stream peek = $" ifTrue: [
		stream next.
		[stream peek = $" & stream peek notNil] whileFalse: [
			c := stream next.
			c = $\
				ifTrue: [
					c := stream next.
					out nextPut: (ReadTranslations at: c)]
				ifFalse: [out nextPut: c]].
		stream next].
	^out contents]

{ #category : #reading }
HtmlPListSerializer >> readString [
	| out c |
	out := String new writeStream.
	self skipWhitespace.
	[
		c := stream peek.
		c isAlphanumeric | ('-_.' includes: c)]
		whileTrue: [out nextPut: stream next].
	^out contents]

{ #category : #reading }
HtmlPListSerializer >> skipWhitespace [
	[| c |
		c := stream peek.
		c notNil and: [c isBlank]]
		whileTrue: [stream next]]

{ #category : #writing }
HtmlPListSerializer >> write: object [
	object isString
		ifFalse: [self writeCollection: object]
		ifTrue: [self writeString: object asString]]

{ #category : #writing }
HtmlPListSerializer >> writeArray: aCollection [
	| itemsPerLine |
	itemsPerLine := 0.
	stream nextPutAll: '( '.
	indentLevel := indentLevel + 1.
	aCollection do: [:x | 
		self write: x.
		stream nextPutAll: ', '.
		itemsPerLine := itemsPerLine + 1.
		itemsPerLine = arrayItemsPerLine ifTrue: [
			stream cr.
			itemsPerLine := 0]].
	indentLevel := indentLevel - 1.
	aCollection isEmpty ifFalse: [stream position: stream position - 2].
	"Trim last comma space"
	stream nextPutAll: ')']

{ #category : #writing }
HtmlPListSerializer >> writeCollection: aCollection [
	aCollection isSequenceable
		ifTrue: [self writeArray: aCollection]
		ifFalse: [self writeDictionary: aCollection]]

{ #category : #writing }
HtmlPListSerializer >> writeDictionary: aCollection [
	stream nextPutAll: '{ '; nextPut: Character lf.
	indentLevel := indentLevel + 1.
	aCollection keysAndValuesDo: [:key :value | 
		0 to: indentLevel do: [:ea | stream nextPut: $ ].
		self write: key.
		stream nextPutAll: ' = '.
		self write: value.
		stream nextPutAll: '; '; nextPut: Character lf].
	indentLevel := -1.
	stream nextPutAll: '}']

{ #category : #writing }
HtmlPListSerializer >> writeIndent [
	0 to: indentLevel do: [:x | stream nextPutAll: '    ']]

{ #category : #writing }
HtmlPListSerializer >> writeString: aString [
	(aString
		detect: [:c | (c isAlphanumeric | ('_-.' includes: c)) not]
		ifNone: [nil])
		ifNil: [stream nextPutAll: aString]
		ifNotNil: [
			stream nextPut: $".
			aString
				do: [:c | stream
					nextPutAll: (WriteTranslations at: c ifAbsent: [c asString])].
			stream nextPutAll: '" ']]

