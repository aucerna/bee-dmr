"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #DomainValidator,
	#superclass : #Validator,
	#category : #Validations
}

{ #category : #inquiries }
DomainValidator class >> invalidNameCharacters [
	^'"*/?|:\[]']

{ #category : #private }
DomainValidator class >> isAbstract [
	^self == DomainValidator]

{ #category : #private }
DomainValidator class >> rootClass [
	^DomainValidator]

{ #category : #queries }
DomainValidator class >> validationAspectCount [
	"
	DomainValidator validationAspectCount
	"
	^self allSubclasses sum: [:c | 
		c selectors sum: [:s | | count |
			count := 0.
			(c >> s) parseTree
				messagesDo: [:node | (#(#aspect:) includes: node selector value)
					ifTrue: [count := count + 1]].
			(count = 0 and: [s includesString: 'alidat']) ifTrue: [count := 1].
			count]]]

{ #category : #queries }
DomainValidator class >> validationCount [
	"
	DomainValidator validationCount
	"
	^self allSubclasses sum: [:c | 
		c selectors sum: [:s | | count |
			count := 0.
			(c >> s) parseTree messagesDo: [:node | 
				(#(#inform: #failBecause: #warnBecause:) includes: node selector value)
					ifTrue: [count := count + 1]].
			count]]]

{ #category : #'validation helpers' }
DomainValidator >> areIncreasing: aCollection [
	self areIncreasing: aCollection from: 1]

{ #category : #'validation helpers' }
DomainValidator >> areIncreasing: aCollection from: index [
	^self areIncreasing: aCollection from: index to: aCollection size]

{ #category : #'validation helpers' }
DomainValidator >> areIncreasing: aCollection from: index1 to: index2 [
	| index prev |
	self areDefined: aCollection.
	aCollection isEmpty ifTrue: [^self].
	(aCollection isIncreasingFrom: index1 to: index2) ifTrue: [^self].
	prev := aCollection at: index1.
	index := (index1 + 1 to: index2) detect: [:i | | xi test |
		xi := aCollection at: i.
		test := xi isUndefinedValue not
			and: [prev isUndefinedValue not]
			and: [xi <= prev].
		xi isUndefinedValue ifFalse: [prev := xi].
		test].
	self failValidationBecause: (self mustBeIncreasingAt: index)]

{ #category : #'validation helpers' }
DomainValidator >> areNonDecreasing: aCollection [
	self areNonDecreasing: aCollection from: 1]

{ #category : #'validation helpers' }
DomainValidator >> areNonDecreasing: aCollection from: firstIndex [
	self areNonDecreasing: aCollection from: firstIndex to: aCollection size]

{ #category : #'validation helpers' }
DomainValidator >> areNonDecreasing: aCollection from: firstIndex to: lastIndex [
	| index prev |
	self areDefined: aCollection.
	aCollection isEmpty ifTrue: [^self].
	(aCollection isNonDecreasingFrom: firstIndex to: lastIndex) ifTrue: [^self].
	prev := aCollection at: firstIndex.
	index := (firstIndex + 1 to: lastIndex) detect: [:i | | xi test |
		xi := aCollection at: i.
		test := xi isUndefinedValue not
			and: [prev isUndefinedValue not]
			and: [xi < prev].
		xi isUndefinedValue ifFalse: [prev := xi].
		test].
	self failValidationBecause: (self mustBeNonDecreasingAt: index)]

{ #category : #private }
DomainValidator >> emphasize: aString [
	| emphasized text |
	emphasized := aString ifNil: ['unknown'].
	text := self newRtf.
	text link: emphasized.
	^text]

{ #category : #'test support' }
DomainValidator >> inheritanceValidation [
	#testSupport.
	self failBecause: 'Object doesnt inherit from CsrCompositePane']

{ #category : #inquiries }
DomainValidator >> invalidNameCharacters [
	^self class invalidNameCharacters]

{ #category : #'message patterns' }
DomainValidator >> mustBeIncreasing [
	^self prettyPrint , ' must have increasing values']

{ #category : #'message patterns' }
DomainValidator >> mustBeNonDecreasingAt: index [
	^self prettyPrint , ' decreases at index ' , index printString]

{ #category : #services }
DomainValidator >> validateFilename: aFilename header: header [
	self
		validateFilename: aFilename asFilename
		invalidCharacters: #()
		header: header]

{ #category : #'validation helpers' }
DomainValidator >> validateFilename: aFilename invalidCharacters: aCollection header: header [
	| validation folder |
	validation := aFilename
		runValidation: #validateNameInvalidCharacters:header:
		with: aCollection
		with: header.
	self includeValidationResult: validation.
	folder := aFilename parentPath.
	folder directoryExists ifFalse: [
		self
			failBecause: header , ' refers to folder ' , folder asString
				, ' which does not exist']]

{ #category : #services }
DomainValidator >> validateResourceName: aString [
	self validateResourceName: aString head: 'The name']

{ #category : #services }
DomainValidator >> validateResourceName: aString head: header [
	| forbidden chars |
	(aString isNil or: [aString trimBlanks isEmpty])
		ifTrue: [self failBecause: header value , ' should not be blank'].
	aString trimBlanks ~= aString ifTrue: [
		self
			failBecause: header value , ' starts or finishes with a blank character'].
	forbidden := self invalidNameCharacters.
	(aString includesAny: forbidden) ifTrue: [
		chars := String streamContents: [:str | 
			forbidden allButLast do: [:ch | str nextPut: ch; space].
			str nextPutAll: 'or '; nextPut: forbidden last].
		self
			failBecause: header value
				, ' contains some of the following characters: '
				, chars]]

{ #category : #'validation helpers - values' }
DomainValidator >> valuesAreIncreasing [
	self areIncreasing: self value]

{ #category : #'validation helpers - values' }
DomainValidator >> valuesAreNotDecreasing [
	self areNonDecreasing: self value]

