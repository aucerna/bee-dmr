"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonObjectValidator,
	#superclass : #DomainValidator,
	#instVars : [
		'schema'
	],
	#category : #JSON
}

{ #category : #validation }
JsonObjectValidator class >> validate: aJsonObject against: aJsonSchema [
	| suite |
	suite := self validationSuiteFor: aJsonObject.
	suite tests do: [:v | v schema: aJsonSchema].
	^suite run]

{ #category : #accessing }
JsonObjectValidator >> schema: aJsonSchema [
	schema := aJsonSchema]

{ #category : #all }
JsonObjectValidator >> validateAnyOf [
	| msg subschemas |
	schema isAnySchema ifFalse: [^self].
	subschemas := schema schemas
		collect: [:s | s isSchemaReference
			ifTrue: [self validateReference: s]
			ifFalse: [s]].
	subschemas do: [:s | (s validate: object) hasPassed ifTrue: [^self]].
	msg := String streamContents: [:strm | 
		strm nextPutAll: 'should be any of the following: '.
		schema schemas do: [:s | strm cr; nextPutAll: s asString]].
	self failBecause: msg]

{ #category : #all }
JsonObjectValidator >> validateArray [
	| subschema min max |
	schema isArraySchema ifFalse: [^self].
	self aspect: nil; valueIsArray; aspect: #size.
	min := schema minItems.
	min notNil ifTrue: [self valueIsNotBelow: min].
	max := schema maxItems.
	max notNil ifTrue: [self valueIsNotAbove: max].
	self aspect: nil.
	schema uniqueItems == true ifTrue: [self valuesAreDifferent].
	subschema := schema items.
	subschema isNil ifTrue: [^self].
	subschema isSchemaReference
		ifTrue: [subschema := self validateReference: subschema].
	object do: [:element | | validation |
		validation := subschema validate: element.
		validation hasPassed ifFalse: [self includeValidationResult: validation]]]

{ #category : #all }
JsonObjectValidator >> validateBoolean [
	schema isBooleanSchema ifFalse: [^self].
	self valueIsBoolean]

{ #category : #all }
JsonObjectValidator >> validateEnum [
	| enum options |
	enum := schema enum.
	enum isNil ifTrue: [^self].
	(enum includes: object) ifFalse: [
		options := String streamContents: [:s | 
			enum
				do: [:o | s nextPutAll: o printString]
				separatedBy: [s nextPutAll: ', ']].
		self failBecause: 'should be any of (' , options , ')']]

{ #category : #all }
JsonObjectValidator >> validateFormat [
	]

{ #category : #all }
JsonObjectValidator >> validateInteger [
	schema isIntegerSchema ifFalse: [^self].
	self valueIsInteger]

{ #category : #all }
JsonObjectValidator >> validateMultiple [
	| factor |
	schema isNumberSchema ifFalse: [^self].
	self value isNumber ifFalse: [^self].
	factor := schema multipleOf.
	factor isNil ifTrue: [^self].
	self value \\ factor = 0
		ifFalse: [self failBecause: 'is not a multiple of ' , factor asString]]

{ #category : #all }
JsonObjectValidator >> validateNot [
	| subschema |
	schema isNotSchema ifFalse: [^self].
	subschema := schema schema.
	subschema isSchemaReference
		ifTrue: [subschema := self validateReference: subschema].
	(subschema validate: object) hasPassed
		ifTrue: [self failBecause: 'should not be ' , schema schema asString]]

{ #category : #all }
JsonObjectValidator >> validateNull [
	schema isNullSchema ifFalse: [^self].
	self valueIsUndefined]

{ #category : #all }
JsonObjectValidator >> validateNumber [
	schema isNumberSchema ifFalse: [^self].
	schema isIntegerSchema ifTrue: [^self].
	self valueIsNumber]

{ #category : #all }
JsonObjectValidator >> validateObject [
	schema isObjectSchema ifFalse: [^self].
	object isJsonObject ifFalse: [self failBecause: 'object expected'].
	schema properties keysDo: [:p | self validateProperty: p]]

{ #category : #all }
JsonObjectValidator >> validateOneOf [
	| msg valid subschemas |
	schema isOneSchema ifFalse: [^self].
	subschemas := schema schemas
		collect: [:s | s isSchemaReference
			ifTrue: [self validateReference: s]
			ifFalse: [s]].
	valid := subschemas count: [:s | (s validate: object) hasPassed].
	valid = 1 ifTrue: [^self].
	msg := String streamContents: [:strm | 
		strm nextPutAll: 'should be one (and only one) of the following: '.
		schema schemas do: [:s | strm cr; nextPutAll: s asString]].
	self failBecause: msg]

{ #category : #all }
JsonObjectValidator >> validateProperty: aString [
	| validation prefix subschema |
	self aspect: aString asSymbol.
	(schema requires: aString) ifTrue: [self valueIsDefined].
	(object includesKey: aString) ifFalse: [^self].
	subschema := schema propertyAt: aString.
	subschema isSchemaReference
		ifTrue: [subschema := self validateReference: subschema].
	validation := subschema validate: self value.
	validation hasPassed ifFalse: [
		prefix := self newRtf append: aString.
		self includeValidationResult: validation withPrefix: prefix]]

{ #category : #all }
JsonObjectValidator >> validateRange [
	| min max |
	schema isNumberSchema ifFalse: [^self].
	self value isNumber ifFalse: [^self].
	min := schema minimum.
	min notNil ifTrue: [self valueIsNotBelow: min].
	min := schema exclusiveMinimum.
	min notNil ifTrue: [self valueIsAbove: min].
	max := schema maximum.
	max notNil ifTrue: [self valueIsNotAbove: max].
	max := schema exclusiveMaximum.
	max notNil ifTrue: [self valueIsBelow: max]]

{ #category : #all }
JsonObjectValidator >> validateReference: aJsonSchemaReference [
	| target |
	target := aJsonSchemaReference resolveIn: schema.
	target isNil
		ifTrue: [self
			failBecause: aJsonSchemaReference path , ' cannot be resolved'].
	^target]

{ #category : #all }
JsonObjectValidator >> validateString [
	| min max |
	schema isStringSchema ifFalse: [^self].
	self aspect: nil; valueIsString; aspect: #size.
	min := schema minLength.
	min notNil ifTrue: [self valueIsNotBelow: min].
	max := schema maxLength.
	max notNil ifTrue: [self valueIsNotAbove: max]]

