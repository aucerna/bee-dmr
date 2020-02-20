Class {
	#name : #Message,
	#superclass : #Object,
	#instVars : [
		'#selector',
		'#arguments'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol [
	| arguments |
]

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol argument: anotherObject [
	^self receiver: anObject selector: aSymbol arguments: {anotherObject}
]

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol arguments: anArray [
	^MessageSend new receiver: anObject selector: aSymbol arguments: anArray
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol [
	^self selector: aSymbol arguments: #()
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol argument: anObject [
	^self selector: aSymbol arguments: {anObject}
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol arguments: anArray [
	^self new selector: aSymbol; arguments: anArray
]

{ #category : #comparing }
Message >> = aMessage [
	self == aMessage ifTrue: [^true].
]

{ #category : #accessing }
Message >> argumentAt: anInteger [
	^arguments at: anInteger
]

{ #category : #accessing }
Message >> argumentAt: anInteger put: anObject [
	arguments at: anInteger put: anObject
]

{ #category : #accessing }
Message >> arguments [
	^arguments
]

{ #category : #accessing }
Message >> arguments: anArray [
	arguments := anArray
]

{ #category : #accessing }
Message >> arity [
	^selector isNil
]

{ #category : #private }
Message >> buildArguments: aCollection [
	| predefined args |
]

{ #category : #comparing }
Message >> hash [
	^selector hashWith: arguments
]

{ #category : #testing }
Message >> isMessage [
	^true
]

{ #category : #evaluating }
Message >> performOn: anObject [
	^anObject perform: selector withArguments: arguments
]

{ #category : #printing }
Message >> printOn: aStream [
	aStream
]

{ #category : #accessing }
Message >> receiver [
	^nil
]

{ #category : #accessing }
Message >> selector [
	^selector
]

{ #category : #accessing }
Message >> selector: aSymbol [
	selector := aSymbol
]
