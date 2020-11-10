"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlLazyEvaluationArg,
	#superclass : #Object,
	#instVars : [
		'expression',
		'index',
		'value'
	],
	#category : #FML
}

{ #category : #'instance creation' }
FmlLazyEvaluationArg class >> on: anFmlExpression [
	^self new expression: anFmlExpression]

{ #category : #'instance creation' }
FmlLazyEvaluationArg class >> on: anFmlExpression atIndex: anInteger [
	^self new expression: anFmlExpression; index: anInteger]

{ #category : #converting }
FmlLazyEvaluationArg >> asFmlValue [
	^self]

{ #category : #evaluating }
FmlLazyEvaluationArg >> columnSelectorFor: symbol [
	^(symbol numArgs = 0
		ifTrue: [symbol, 'AtColumn:']
		ifFalse: [symbol, 'atColumn:']) asSymbol]

{ #category : #metaprogramming }
FmlLazyEvaluationArg >> doesNotUnderstand: aMessage [
	^self value asFmlValue perform: aMessage selector withArguments: aMessage arguments]

{ #category : #accessing }
FmlLazyEvaluationArg >> evaluated [
	^index isNil ifTrue: [self value asFmlValue] ifFalse: [self value]]

{ #category : #accessing }
FmlLazyEvaluationArg >> expression [
	^expression]

{ #category : #accessing }
FmlLazyEvaluationArg >> expression: aFmlExpression [
	expression := aFmlExpression]

{ #category : #accessing }
FmlLazyEvaluationArg >> index [
	^index]

{ #category : #accessing }
FmlLazyEvaluationArg >> index: anInteger [
	index := anInteger]

{ #category : #testing }
FmlLazyEvaluationArg >> isArrayValued [
	^index isNil and: [expression isArrayValued]]

{ #category : #testing }
FmlLazyEvaluationArg >> isNumber [
	^self value isNumber]

{ #category : #testing }
FmlLazyEvaluationArg >> isTableValued [
	^expression isTableValued]

{ #category : #testing }
FmlLazyEvaluationArg >> isUndefinedValue [
	^self value isUndefinedValue]

{ #category : #accessing }
FmlLazyEvaluationArg >> performFunction: symbol withArgs: argArray atColumn: idx [
	| cs |
	^(self respondsTo: (cs := self columnSelectorFor: symbol))
		ifTrue: [self perform: cs withArguments: (argArray copyWith: idx)]
		ifFalse: [
			self value asFmlValue
				performFunction: symbol
				withArgs: argArray
				atColumn: idx]]

{ #category : #evaluating }
FmlLazyEvaluationArg >> previousValue: first atColumn: col [
	^col = 1 ifTrue: [first value] ifFalse: [self valueAt: col - 1]]

{ #category : #printing }
FmlLazyEvaluationArg >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: expression printString;
		nextPut: $).
	index isNil ifFalse: [
		aStream
			nextPut: $[;
			nextPutAll: index printString;
			nextPut: $]]]

{ #category : #accessing }
FmlLazyEvaluationArg >> value [
	value notNil ifTrue: [^value].
	value := index isNil
		ifTrue: [expression evaluate value]
		ifFalse: [expression evaluateAt: index].
	^value]

{ #category : #evaluating }
FmlLazyEvaluationArg >> valueAt: idx [
	(index notNil and: [index ~= idx]) ifTrue: [
		self
			error: 'Receiver expression ' , expression printString
				, ' cannot be evaluated at index '
				, idx printString].
	(index isNil and: [value notNil]) ifTrue: [^value valueAt: idx].
	index = idx ifTrue: [^value].
	^FmlLazyEvaluationArg on: expression atIndex: idx]

