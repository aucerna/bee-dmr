"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #FmlExternalModelError,
	#superclass : #FmlEvaluationError,
	#category : #FML
}

{ #category : #testing }
FmlExternalModelError >> isResumable [
	^false]

