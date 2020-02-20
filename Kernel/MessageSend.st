Class {
	#name : #MessageSend,
	#superclass : #Message,
	#instVars : [
		'#receiver'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
MessageSend class >> receiver: anObject selector: aSymbol arguments: anArray [
	^self new receiver: anObject selector: aSymbol arguments: anArray
]

{ #category : #comparing }
MessageSend >> = aMessage [
	super = aMessage ifFalse: [^false].
]

{ #category : #evaluating }
MessageSend >> evaluate [
	^self perform
]

{ #category : #evaluating }
MessageSend >> evaluateFor: anObject [
	^self evaluateWithArguments: {anObject}
]

{ #category : #evaluating }
MessageSend >> evaluateWith: argObject [
	^selector arity = 1
]

{ #category : #evaluating }
MessageSend >> evaluateWithArguments: anArray [
	| args |
]

{ #category : #comparing }
MessageSend >> hash [
	^receiver hashWith: selector with: arguments
]

{ #category : #converting }
MessageSend >> newProcess [
	^Process new evaluating: self
]

{ #category : #evaluating }
MessageSend >> perform [
	^self performOn: receiver
]

{ #category : #printing }
MessageSend >> printOn: aStream [
	aStream
]

{ #category : #accessing }
MessageSend >> receiver [
	^receiver
]

{ #category : #accessing }
MessageSend >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MessageSend >> receiver: anObject selector: aSymbol arguments: anArray [
	receiver := anObject.
]

{ #category : #evaluating }
MessageSend >> value [
	^self perform
]

{ #category : #evaluating }
MessageSend >> value: value1 value: value2 [
	arguments
]
