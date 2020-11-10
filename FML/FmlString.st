"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlString,
	#superclass : #FmlValue,
	#instVars : [
		'string'
	],
	#category : #FML
}

{ #category : #constants }
FmlString class >> typeName [
	^'String']

{ #category : #'instance creation' }
FmlString class >> with: aString [
	^self new value: aString]

{ #category : #functions }
FmlString >> + anFmlString [
	| tail |
	tail := anFmlString value.
	tail isString ifFalse: [^self argumentIn: #'+' shouldBe: FmlString].
	^self class with: string , anFmlString value]

{ #category : #comparing }
FmlString >> < anFmlValue [
	anFmlValue isString ifFalse: [^self argumentIn: #'<' shouldBe: FmlString].
	^anFmlValue performOperation: #'<' receiverValue: self value]

{ #category : #comparing }
FmlString >> <= anFmlValue [
	anFmlValue isString ifFalse: [^self argumentIn: #'<=' shouldBe: FmlString].
	^anFmlValue performOperation: #'<=' receiverValue: self value]

{ #category : #comparing }
FmlString >> > anFmlValue [
	anFmlValue isString ifFalse: [^self argumentIn: #'>' shouldBe: FmlString].
	^anFmlValue performOperation: #'>' receiverValue: self value]

{ #category : #comparing }
FmlString >> >= anFmlValue [
	anFmlValue isString ifFalse: [^self argumentIn: #'>=' shouldBe: FmlString].
	^anFmlValue performOperation: #'>=' receiverValue: self value]

{ #category : #visiting }
FmlString >> acceptVisitor: fmlVisitor [
	fmlVisitor visitFmlString: self]

{ #category : #functions }
FmlString >> asLowercase [
	^self class with: string asLowercase]

{ #category : #functions }
FmlString >> asUppercase [
	^self class with: string asUppercase]

{ #category : #testing }
FmlString >> canReferToVariable [
	^true]

{ #category : #functions }
FmlString >> capitalized [
	^self class with: string capitalized]

{ #category : #accessing }
FmlString >> columnIndexInTable: anFmlTable [
	| specs c |
	specs := anFmlTable columnSpecs.
	c := specs findFirst: [:s | s label = string] ifAbsent: 0.
	^c = 0 ifFalse: [c]]

{ #category : #functions }
FmlString >> copyFrom: i to: j [
	| substring start end |
	start := i isUndefinedValue ifTrue: [1] ifFalse: [i value].
	start isNumber
		ifFalse: [^self
			argument: 'firstIndex'
			in: 'copyFromTo'
			shouldBe: FmlNumber].
	end := j isUndefinedValue ifTrue: [string size] ifFalse: [j value].
	end isNumber
		ifFalse: [^self argument: 'lastIndex' in: 'copyFromTo' shouldBe: FmlNumber].
	start := start max: 1.
	end := end min: string size.
	substring := string copyFrom: start asInteger to: end asInteger.
	^self class with: substring]

{ #category : #comparing }
FmlString >> equals: anFmlValue [
	^(string = anFmlValue value) asFmlValue
]

{ #category : #functions }
FmlString >> includesString: anFmlString [
	anFmlString isString
		ifFalse: [^self argumentIn: 'includesString' shouldBe: FmlString].
	^(string includesString: anFmlString value) asFmlValue]

{ #category : #accessing }
FmlString >> inferredUnit [
	^StringUnit defaultInstance]

{ #category : #testing }
FmlString >> isFmlString [
	^true]

{ #category : #testing }
FmlString >> isMagicConstant [
	^false]

{ #category : #testing }
FmlString >> isString [
	^true]

{ #category : #functions }
FmlString >> length [
	^string size asFmlValue]

{ #category : #comparing }
FmlString >> max: anFmlString [
	anFmlString isString ifFalse: [^self argumentIn: #max shouldBe: FmlString].
	^(anFmlString <= self) value ifTrue: [self] ifFalse: [anFmlString]]

{ #category : #comparing }
FmlString >> min: anFmlString [
	anFmlString isString ifFalse: [^self argumentIn: #min shouldBe: FmlString].
	^(self <= anFmlString) value ifTrue: [self] ifFalse: [anFmlString]]

{ #category : #private }
FmlString >> referredVariableUnit [
	self anyReferredVariable ifNotNil: [:v | ^v unit].
	^nil]

{ #category : #accessing }
FmlString >> value [
	^string]

{ #category : #accessing }
FmlString >> value: aString [
	string := aString]

