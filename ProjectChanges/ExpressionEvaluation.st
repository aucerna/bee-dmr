"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ExpressionEvaluation,
	#superclass : #ChangeRecord,
	#instVars : [
		'expression'
	],
	#category : #ProjectChanges
}

{ #category : #'instance creation' }
ExpressionEvaluation class >> on: aString [
	^self new expression: aString]

{ #category : #comparing }
ExpressionEvaluation >> = changeRecord [
	super = changeRecord ifFalse: [^false].
	expression = changeRecord expression ifFalse: [^false].
	^true]

{ #category : #perform }
ExpressionEvaluation >> basicPerform [
	Compiler evaluate: expression]

{ #category : #testing }
ExpressionEvaluation >> changesSomething [
	^true]

{ #category : #accessing }
ExpressionEvaluation >> classBinding [
	^UndefinedObject]

{ #category : #accessing }
ExpressionEvaluation >> expression [
	^expression]

{ #category : #accessing }
ExpressionEvaluation >> expression: aString [
	expression := aString]

{ #category : #testing }
ExpressionEvaluation >> isEvaluation [
	^true]

{ #category : #'filein/out' }
ExpressionEvaluation >> readFrom: aStream [
	expression := aStream nextChunk]

{ #category : #accessing }
ExpressionEvaluation >> refersTo [
	^{self class. expression}]

{ #category : #services }
ExpressionEvaluation >> resolveClass [
	^nil]

{ #category : #printing }
ExpressionEvaluation >> shortLabel [
	^super shortLabel abbreviatedTo: 80]

{ #category : #accessing }
ExpressionEvaluation >> sourceCode [
	^expression isNil ifTrue: [''] ifFalse: [expression]]

