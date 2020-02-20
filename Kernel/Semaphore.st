Class {
	#name : #Semaphore,
	#superclass : #Object,
	#instVars : [
		'#signals',
		'#waiting'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Semaphore class >> forMutualExclusion [
	^self new signal
]

{ #category : #delaying }
Semaphore >> critical: aBlock [
	^[
]

{ #category : #testing }
Semaphore >> hasWaitingProcesses [
	^waiting notEmpty
]

{ #category : #initialization }
Semaphore >> initialize [
	super initialize.
]

{ #category : #testing }
Semaphore >> isSignaled [
	^signals > 0
]

{ #category : #synchronization }
Semaphore >> signal [
	| enabled |
]

{ #category : #synchronization }
Semaphore >> wait [
	| enabled |
]

{ #category : #accessing }
Semaphore >> waitingProcesses [
	^waiting
]
