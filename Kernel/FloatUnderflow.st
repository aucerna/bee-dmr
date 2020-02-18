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

