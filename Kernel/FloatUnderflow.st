"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #FloatUnderflow,
	#superclass : #Notification,
	#category : #Kernel
}

{ #category : #'error handling' }
FloatUnderflow >> defaultAction [
	^0.0
]

{ #category : #accessing }
FloatUnderflow >> type [
	^#underflow
]

