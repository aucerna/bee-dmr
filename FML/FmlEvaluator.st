"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlEvaluator,
	#superclass : #Object,
	#category : #FML
}

{ #category : #'instance creation' }
FmlEvaluator class >> new [
	^current ifNil: [current := super new]]

{ #category : #evaluation }
FmlEvaluator >> evaluate: anFmlExpression [
	^anFmlExpression evaluateWith: self]

{ #category : #evaluation }
FmlEvaluator >> evaluateVariable: variable [
	^variable value]

