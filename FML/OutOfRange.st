"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #OutOfRange,
	#superclass : #FmlEvaluationError,
	#category : #FML
}

{ #category : #accessing }
OutOfRange >> defaultDescription [
	^'Value out of range']

