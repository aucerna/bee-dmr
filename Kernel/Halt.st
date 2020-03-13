"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

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

