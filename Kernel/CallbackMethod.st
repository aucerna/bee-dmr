"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CallbackMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#instVars : [
		'receiver'
	],
	#category : #Kernel
}

{ #category : #accessing }
CallbackMethod class >> pragma [
	^#callback
]

{ #category : #testing }
CallbackMethod >> isCallback [
	^true
]

{ #category : #accessing }
CallbackMethod >> receiver [
	^receiver
]

{ #category : #accessing }
CallbackMethod >> receiver: anObject [
	receiver := anObject
]

