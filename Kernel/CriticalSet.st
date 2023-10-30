"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CriticalSet,
	#superclass : #Object,
	#instVars : [
		'contents',
		'changed'
	],
	#category : #Kernel
}

{ #category : #accessing }
CriticalSet >> add: element [
	^[
		changed := true.
		contents add: element] evaluateAtomically
]

{ #category : #accessing }
CriticalSet >> asArray [
	^Array withAll: self
]

{ #category : #accessing }
CriticalSet >> contents: aSet [
	contents := aSet
]

{ #category : #accessing }
CriticalSet >> do: aBlock [
	[| done |
		done := contents class new.
		[
			changed := false.
			contents copy do: [:elem | 
				(done includes: elem) ifFalse: [
					done add: elem.
					aBlock value: elem]].
			changed] whileTrue] evaluateAtomically
]

{ #category : #accessing }
CriticalSet >> ephemeronsDo: aBlock [
	[| done |
		done := contents class new.
		[
			changed := false.
			contents copy ephemeronsDo: [:ephemeron | 
				(done includes: ephemeron) ifFalse: [
					done add: ephemeron.
					aBlock value: ephemeron]].
			changed] whileTrue] evaluateAtomically
]

{ #category : #accessing }
CriticalSet >> finalizer: evaluableAction [
	contents finalizer: evaluableAction
]

{ #category : #accessing }
CriticalSet >> includes: anObject [
	^contents includes: anObject
]

{ #category : #accessing }
CriticalSet >> postCopy [
	contents := contents copy
]

{ #category : #accessing }
CriticalSet >> rehash [
	^contents rehash
]

{ #category : #accessing }
CriticalSet >> remove: anObject ifAbsent: aBlock [
	^[contents remove: anObject ifAbsent: aBlock] evaluateAtomically
]

{ #category : #accessing }
CriticalSet >> rescue: anEphemeron [
	contents rescue: anEphemeron
]

{ #category : #accessing }
CriticalSet >> size [
	^contents size
]

