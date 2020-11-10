"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlRecursiveDefinition,
	#superclass : #FmlEvaluationError,
	#category : #FML
}

{ #category : #accessing }
FmlRecursiveDefinition >> defaultDescription [
	^'Recursive definition']

{ #category : #testing }
FmlRecursiveDefinition >> isResumable [
	^self activeHandler isNil]

{ #category : #unclassified }
FmlRecursiveDefinition >> sunitExitWith: aValue [
	self activeHandler resume: nil asFmlValue]

{ #category : #unclassified }
FmlRecursiveDefinition >> sunitRetry [
	self activeHandler resume: nil asFmlValue]

