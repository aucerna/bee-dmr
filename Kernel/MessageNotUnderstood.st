Class {
	#name : #MessageNotUnderstood,
	#superclass : #Error,
	#instVars : [
		'#message',
		'#receiver'
	],
	#category : #Kernel
}

{ #category : #signaling }
MessageNotUnderstood class >> message: aMessage [
	^self new message: aMessage; signal
]

{ #category : #signaling }
MessageNotUnderstood class >> message: aMessage receiver: anObject [
	^self new message: aMessage; receiver: anObject; signal
]

{ #category : #actions }
MessageNotUnderstood >> defaultAction [
	Processor activeProcess
]

{ #category : #accessing }
MessageNotUnderstood >> defaultDescription [
	| selector |
]

{ #category : #testing }
MessageNotUnderstood >> isResumable [
	^message notNil and: [receiver respondsTo: message selector]
]

{ #category : #accessing }
MessageNotUnderstood >> message [
	^message
]

{ #category : #accessing }
MessageNotUnderstood >> message: aMessage [
	message := aMessage
]

{ #category : #accessing }
MessageNotUnderstood >> receiver [
	^receiver
]

{ #category : #accessing }
MessageNotUnderstood >> receiver: anObject [
	receiver := anObject
]
