Class {
	#name : #CallbackStackLink,
	#superclass : #Object,
	#instVars : [
		'#base',
		'#top',
		'#next'
	],
	#category : #Kernel
}

{ #category : #queries }
CallbackStackLink class >> after: aCallbackStackLink [
	^self new next: aCallbackStackLink
]

{ #category : #accessing }
CallbackStackLink >> base [
	^base
]

{ #category : #accessing }
CallbackStackLink >> base: anInteger [
	base := anInteger
]

{ #category : #initialization }
CallbackStackLink >> forgetStackPointers [
	base := nil.	top := nil
]

{ #category : #testing }
CallbackStackLink >> isInCallback [
	^next !== nil
]

{ #category : #accessing }
CallbackStackLink >> next [
	^next
]

{ #category : #accessing }
CallbackStackLink >> next: aCallbackStackLink [
	next := aCallbackStackLink
]

{ #category : #initialization }
CallbackStackLink >> recordStackPointers [
	| frame dropped |	frame := StackFrameCursor top.	dropped := 4.	dropped timesRepeat: [frame moveNext].	base := frame current.	top := frame previous + 8 _asPointer		- 8 _asPointer "is going to push 2 arguments for ffiCall:withArguments"
]

{ #category : #accessing }
CallbackStackLink >> top [
	^top
]

