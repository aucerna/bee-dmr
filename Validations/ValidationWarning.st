"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationWarning,
	#superclass : #ValidationFailure,
	#instVars : [
		'resumable'
	],
	#category : #Validations
}

{ #category : #accessors }
ValidationWarning >> exceptionClass [
	^ValidationWarningException]

{ #category : #initialization }
ValidationWarning >> initialize [
	resumable := true]

{ #category : #testing }
ValidationWarning >> isResumable [
	^resumable]

{ #category : #testing }
ValidationWarning >> isWarning [
	^true]

{ #category : #exceptions }
ValidationWarning >> newException [
	^super newException resumable: resumable]

{ #category : #accessors }
ValidationWarning >> resumable: aBoolean [
	resumable := aBoolean]

