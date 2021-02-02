"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ValidationFailureException,
	#superclass : #Error,
	#instVars : [
		'failure',
		'resignal',
		'outer'
	],
	#category : #Validations
}

{ #category : #'instance creation' }
ValidationFailureException class >> new [
	^super new initialize]

{ #category : #accessors }
ValidationFailureException >> description [
	^failure description asString]

{ #category : #initialization }
ValidationFailureException >> initialize [
	super initialize.
	resignal := outer := false]

{ #category : #testing }
ValidationFailureException >> isResumable [
	^resignal | outer]

{ #category : #handling }
ValidationFailureException >> outer [
	| prev |
	prev := outer.
	outer := true.
	[self basicOuter] ensure: [outer := prev]]

{ #category : #printing }
ValidationFailureException >> printTextOn: rtf [
	failure printTextOn: rtf]

{ #category : #accessors }
ValidationFailureException >> resignal: aBoolean [
	resignal := aBoolean]

{ #category : #accessors }
ValidationFailureException >> sunitExitWith: returnValue [
	resignal
		ifTrue: [self resume: returnValue]
		ifFalse: [super sunitExitWith: returnValue]]

{ #category : #accessors }
ValidationFailureException >> sunitRetry [
	resignal ifTrue: [self resume]]

{ #category : #accessors }
ValidationFailureException >> validationFailure [
	^failure]

{ #category : #accessors }
ValidationFailureException >> validationFailure: aValidationFailure [
	failure := aValidationFailure]

