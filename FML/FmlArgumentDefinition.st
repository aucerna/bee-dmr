"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlArgumentDefinition,
	#superclass : #Object,
	#instVars : [
		'name',
		'optional',
		'unit'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlArgumentDefinition class >> fromString: aString [
	self ASSERT: aString notEmpty.
	^aString first = $[
		ifTrue: [
			self ASSERT: aString last = $].
			(self named: (aString copyFrom: 2 to: aString size - 1)) beOptional]
		ifFalse: [self named: aString]]

{ #category : #'instance creation' }
FmlArgumentDefinition class >> named: aString [
	^self new name: aString]

{ #category : #'instance creation' }
FmlArgumentDefinition class >> new [
	^super new initialize]

{ #category : #testing }
FmlArgumentDefinition >> allowsMagicConstants [
	| u |
	u := self inferredUnit.
	^u notNil and: [u isNumberUnit]]

{ #category : #converting }
FmlArgumentDefinition >> asJson [
	^JsonObject new
		at: 'Name' put: name;
		at: 'Optional' put: optional;
		yourself]

{ #category : #accessing }
FmlArgumentDefinition >> beObligatory [
	optional := false]

{ #category : #accessing }
FmlArgumentDefinition >> beOptional [
	optional := true]

{ #category : #accessing }
FmlArgumentDefinition >> inferredUnit [
	unit isNil ifTrue: [unit := self inferUnit].
	^unit == #nil ifFalse: [unit]]

{ #category : #accessing }
FmlArgumentDefinition >> inferUnit [
	(#('day' 'digits' 'firstPeriod' 'life' 'logic' 'month' 'order' 'period' 'periods' 
		'position' 'positions' 'probability' 'repetitions' 'row' 'significance' 'type' 'year')
		includes: name)
		ifTrue: [^NumberUnit integer].
	(#('exponent' 'lambda' 'rate' 'annualRate' 'confidence' 'P90/P10')
		includes: name)
		ifTrue: [^NumberUnit defaultInstance].
	(#('error') includes: name) ifTrue: [^PercentUnit percent].
	(name asLowercase includesString: 'index') ifTrue: [^NumberUnit integer].
	(name asLowercase includesString: 'column') ifTrue: [^NumberUnit integer].
	(name asLowercase includesString: 'date') ifTrue: [^DateUnit defaultInstance].
	(name asLowercase includesString: 'boolean')
		ifTrue: [^BooleanUnit defaultInstance].
	(name asLowercase includesString: 'string')
		ifTrue: [^StringUnit defaultInstance].
	(#('cumulative') includes: name) ifTrue: [^BooleanUnit defaultInstance].
	^#nil]

{ #category : #initialization }
FmlArgumentDefinition >> initialize [
	super initialize.
	name := 'unnamed'.
	optional := false]

{ #category : #testing }
FmlArgumentDefinition >> isMandatory [
	^optional not]

{ #category : #testing }
FmlArgumentDefinition >> isOptional [
	^optional]

{ #category : #accessing }
FmlArgumentDefinition >> name [
	^name]

{ #category : #accessing }
FmlArgumentDefinition >> name: aString [
	name = aString ifTrue: [^self].
	name := aString.
	unit := nil]

{ #category : #printing }
FmlArgumentDefinition >> printOn: aStream [
	optional ifTrue: [aStream nextPut: $[].
	aStream nextPutAll: name.
	optional ifTrue: [aStream nextPut: $]]]

{ #category : #testing }
FmlArgumentDefinition >> refersToColumn [
	^name asLowercase includesString: 'column']

