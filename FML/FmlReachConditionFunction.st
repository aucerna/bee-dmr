"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlReachConditionFunction,
	#superclass : #FmlFunctionCall,
	#instVars : [
		'solved'
	],
	#category : #FML
}

{ #category : #testing }
FmlReachConditionFunction class >> canOptimize: aFmlFunctionCall [
	| receiver |
	aFmlFunctionCall name = 'if' ifFalse: [^false].
	receiver := aFmlFunctionCall receiver.
	^receiver isBinaryExpression and: [receiver isReachCondition]]

{ #category : #'instance creation' }
FmlReachConditionFunction class >> optimize: aFmlFunctionCall [
	^aFmlFunctionCall shallowCopyTo: self new]

{ #category : #evaluation }
FmlReachConditionFunction >> evaluateWith: anFmlEvaluator [
	| receiver value |
	solved notNil ifTrue: [^solved evaluateWith: anFmlEvaluator].
	value := super evaluateWith: anFmlEvaluator.
	receiver := arguments first.
	receiver wasConditionReached
		ifTrue: [solved := receiver evaluate value
			ifTrue: [arguments second]
			ifFalse: [arguments last]].
	^value]

{ #category : #copying }
FmlReachConditionFunction >> postCopy [
	super postCopy.
	solved := nil]

