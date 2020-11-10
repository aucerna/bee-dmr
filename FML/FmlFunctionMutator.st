"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFunctionMutator,
	#superclass : #FmlVisitor,
	#instVars : [
		'function',
		'replacement',
		'expression'
	],
	#category : #FML
}

{ #category : #accessing }
FmlFunctionMutator >> expression [
	^expression]

{ #category : #testing }
FmlFunctionMutator >> isBinaryToBinary [
	^function isSymbol and: [replacement isSymbol]]

{ #category : #testing }
FmlFunctionMutator >> isBinaryToFunction [
	^function isSymbol andNot: [replacement isSymbol]]

{ #category : #testing }
FmlFunctionMutator >> isFunctionToBinary [
	^function isSymbol not and: [replacement isSymbol]]

{ #category : #testing }
FmlFunctionMutator >> isFunctionToFunction [
	^function isSymbol not andNot: [replacement isSymbol]]

{ #category : #private }
FmlFunctionMutator >> mutate: aString to: anotherString [
	function := aString.
	replacement := anotherString]

{ #category : #private }
FmlFunctionMutator >> mutateB: anFmlBinaryExpression [
	self isBinaryToBinary ifTrue: [^self mutateBB: anFmlBinaryExpression].
	self isBinaryToFunction ifTrue: [^self mutateBF: anFmlBinaryExpression].
	self ASSERT: false]

{ #category : #private }
FmlFunctionMutator >> mutateBB: anFmlBinaryExpression [
	anFmlBinaryExpression operator: replacement]

{ #category : #private }
FmlFunctionMutator >> mutateBF: anFmlBinaryExpression [
	| f |
	f := FmlFunctionCall
		name: replacement
		arguments: anFmlBinaryExpression arguments.
	expression == anFmlBinaryExpression
		ifTrue: [expression := f]
		ifFalse: [expression replaceNode: anFmlBinaryExpression with: f]]

{ #category : #private }
FmlFunctionMutator >> mutateF: anFmlFunctionCall [
	self isFunctionToFunction ifTrue: [^self mutateFF: anFmlFunctionCall].
	self isFunctionToBinary ifTrue: [^self mutateFB: anFmlFunctionCall].
	self ASSERT: false]

{ #category : #private }
FmlFunctionMutator >> mutateFB: anFmlFunctionCall [
	| args b |
	args := anFmlFunctionCall arguments.
	self ASSERT: args size = 2.
	b := FmlBinaryExpression
		left: args first
		operator: replacement
		right: args second.
	expression == anFmlFunctionCall
		ifTrue: [expression := b]
		ifFalse: [expression replaceNode: anFmlFunctionCall with: b]]

{ #category : #private }
FmlFunctionMutator >> mutateFF: anFmlFunctionCall [
	anFmlFunctionCall name: replacement]

{ #category : #visiting }
FmlFunctionMutator >> visitBinary: anFmlBinaryExpression [
	super visitBinary: anFmlBinaryExpression.
	anFmlBinaryExpression operatorString asSymbol == function
		ifTrue: [self mutateB: anFmlBinaryExpression]]

{ #category : #visiting }
FmlFunctionMutator >> visitFunctionCall: anFmlFunctionCall [
	super visitFunctionCall: anFmlFunctionCall.
	anFmlFunctionCall name = function ifTrue: [self mutateF: anFmlFunctionCall]]

{ #category : #visiting }
FmlFunctionMutator >> visitNode: amFmlExpression [
	expression isNil ifTrue: [expression := amFmlExpression]]

