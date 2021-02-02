"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationFailure,
	#superclass : #Object,
	#instVars : [
		'object',
		'aspect',
		'validator',
		'description'
	],
	#category : #Validations
}

{ #category : #accessing }
ValidationFailure class >> classForJsonDictionary: aDictionary [
	| type |
	type := aDictionary valueAt: 'Type'.
	type = 'Failure' ifTrue: [^ValidationFailure].
	type = 'Warning' ifTrue: [^ValidationWarning].
	type = 'Info' ifTrue: [^ValidationInfo].
	type = 'Error' ifTrue: [^ValidationError].
	^self]

{ #category : #'instance creation' }
ValidationFailure class >> fromError: error whileRunning: aTestCase [
	^self new
		object: aTestCase object;
		validator: aTestCase;
		aspect: aTestCase aspectForReporting;
		description: error description]

{ #category : #'instance creation' }
ValidationFailure class >> new [
	^super new initialize]

{ #category : #comparing }
ValidationFailure >> = aValidationFailure [
	^self class = aValidationFailure class
		and: [self object = aValidationFailure object]
		and: [self aspect = aValidationFailure aspect]
		and: [self description = aValidationFailure description]]

{ #category : #accessors }
ValidationFailure >> aspect [
	^aspect]

{ #category : #accessors }
ValidationFailure >> aspect: aSymbol [
	aspect := aSymbol]

{ #category : #exceptions }
ValidationFailure >> debug [
	validator debug]

{ #category : #exceptions }
ValidationFailure >> debugAsFailure [
	validator debugAsFailure]

{ #category : #accessors }
ValidationFailure >> description [
	^description asString]

{ #category : #accessors }
ValidationFailure >> description: aString [
	description := aString]

{ #category : #accessors }
ValidationFailure >> descriptionItems [
	| items |
	items := description asString lines allButFirst.
	^items size > 0 ifTrue: [items collect: #trimBlanks]]

{ #category : #accessors }
ValidationFailure >> descriptionItems: aCollection [
	description := String streamContents: [:strm | 
		description notNil ifTrue: [strm nextPutAll: description; crtab].
		aCollection do: [:line | strm nextPutAll: line] separatedBy: [strm crtab]]]

{ #category : #accessors }
ValidationFailure >> descriptionTitle [
	^description asString upTo: Cr]

{ #category : #accessors }
ValidationFailure >> descriptionTitle: aString [
	| items |
	items := description isNil ifTrue: [''] ifFalse: [String cr , description].
	description := aString , items]

{ #category : #accessors }
ValidationFailure >> exceptionClass [
	^ValidationFailureException]

{ #category : #comparing }
ValidationFailure >> hash [
	^self object hashWith: self aspect with: self description]

{ #category : #testing }
ValidationFailure >> isInfo [
	^false]

{ #category : #testing }
ValidationFailure >> isKnownIssue [
	^false]

{ #category : #testing }
ValidationFailure >> isResumable [
	^false]

{ #category : #testing }
ValidationFailure >> isWarning [
	^false]

{ #category : #exceptions }
ValidationFailure >> newException [
	^self exceptionClass new validationFailure: self]

{ #category : #accessors }
ValidationFailure >> object [
	^object]

{ #category : #accessors }
ValidationFailure >> object: anObject [
	object := anObject]

{ #category : #accessors }
ValidationFailure >> originalObject [
	^validator originalObject]

{ #category : #accessors }
ValidationFailure >> originalObject: anObject [
	validator originalObject: anObject]

{ #category : #printing }
ValidationFailure >> printOn: aStream [
	self disableCode: [
		object class printOn: aStream.
		aStream nextPut: $@.
		aStream nextPutAll: (aspect ifNil: ['nil'])].
	description asString isEmpty
		ifFalse: [aStream nextPutAll: description asString]]

{ #category : #printing }
ValidationFailure >> printTextOn: aStream [
	aStream append: description]

{ #category : #services }
ValidationFailure >> releaseValidator [
	validator := nil]

{ #category : #exceptions }
ValidationFailure >> resignal [
	self newException resignal: true; signal]

{ #category : #exceptions }
ValidationFailure >> signalException [
	self newException signal]

{ #category : #accessors }
ValidationFailure >> text [
	^description]

{ #category : #accessors }
ValidationFailure >> validator [
	^validator]

{ #category : #accessors }
ValidationFailure >> validator: aValidator [
	validator := aValidator]

