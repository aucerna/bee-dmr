"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationWarningException,
	#superclass : #ValidationFailureException,
	#instVars : [
		'resume'
	],
	#category : #Validations
}

{ #category : #initialization }
ValidationWarningException >> initialize [
	super initialize.
	resume := true]

{ #category : #testing }
ValidationWarningException >> isResumable [
	^resume | resignal]

{ #category : #accessing }
ValidationWarningException >> resumable: aBoolean [
	resume := aBoolean]

{ #category : #accessing }
ValidationWarningException >> validationWarning [
	^self validationFailure]

{ #category : #accessing }
ValidationWarningException >> validationWarning: aValidationWarning [
	self validationFailure: aValidationWarning]

