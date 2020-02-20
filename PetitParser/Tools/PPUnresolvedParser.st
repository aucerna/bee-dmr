Class {
	#name : #PPUnresolvedParser,
	#superclass : #PPParser,
	#category : #Tools
}

{ #category : #testing }
PPUnresolvedParser >> isUnresolved [
	^ true
]

{ #category : #parsing }
PPUnresolvedParser >> parseOn: aStream [
	self error: self printString , ' need to be resolved before execution.'
]

