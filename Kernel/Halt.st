Class {
	#name : #Halt,
	#superclass : #Exception,
	#category : #Kernel
}

{ #category : #accessing }
Halt class >> ignoreSignals: aBoolean [
	Ignore := aBoolean
]

{ #category : #accessing }
Halt >> defaultDescription [
	^'halt'
]

