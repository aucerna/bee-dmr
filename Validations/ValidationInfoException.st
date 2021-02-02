"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationInfoException,
	#superclass : #ValidationFailureException,
	#category : #Validations
}

{ #category : #testing }
ValidationInfoException >> isResumable [
	^true]

{ #category : #accessing }
ValidationInfoException >> validationInfo [
	^self validationFailure]

{ #category : #accessing }
ValidationInfoException >> validationInfo: aValidationInfo [
	self validationFailure: aValidationInfo]

