"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Function,
	#superclass : #Object,
	#instVars : [
		'evaluable'
	],
	#category : #NumericalMethods
}

{ #category : #'instance creation' }
Function class >> on: evaluable [
	^self new on: evaluable]

{ #category : #accessing }
Function >> derivative [
	^nil]

{ #category : #evaluating }
Function >> evaluateWith: x [
	^evaluable evaluateWith: x]

{ #category : #accessing }
Function >> on: anObject [
	evaluable := anObject]

{ #category : #evaluating }
Function >> valueAt: x [
	^self evaluateWith: x]

