"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationInfo,
	#superclass : #ValidationFailure,
	#category : #Validations
}

{ #category : #accessors }
ValidationInfo >> exceptionClass [
	^ValidationInfoException]

{ #category : #testing }
ValidationInfo >> isInfo [
	^true]

{ #category : #testing }
ValidationInfo >> isResumable [
	^true]

