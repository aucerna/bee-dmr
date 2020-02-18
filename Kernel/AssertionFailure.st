Class {
	#name : #AssertionFailure,
	#superclass : #Halt,
	#category : #Kernel
}

{ #category : #accessing }
AssertionFailure >> defaultDescription [
	^'assertion failed'
]

