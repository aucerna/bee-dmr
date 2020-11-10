"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlFullEvaluator,
	#superclass : #FmlEvaluator,
	#category : #FML
}

{ #category : #evaluation }
FmlFullEvaluator >> evaluate: anFmlExpression [
	^anFmlExpression evaluateWith: self]

{ #category : #evaluation }
FmlFullEvaluator >> evaluateVariable: variable [
	^variable fullValue]

