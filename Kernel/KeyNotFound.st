Class {
	#name : #KeyNotFound,
	#superclass : #Error,
	#instVars : [
		'#object'
	],
	#category : #Kernel
}

{ #category : #signaling }
KeyNotFound class >> signalFor: anObject [
	^self new object: anObject; signal
]

{ #category : #accessing }
KeyNotFound >> defaultDescription [
	| string |
]

{ #category : #accessing }
KeyNotFound >> object: anObject [
	object := anObject
]
