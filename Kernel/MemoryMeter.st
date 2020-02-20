Class {
	#name : #MemoryMeter,
	#superclass : #Object,
	#instVars : [
		'#memory',
		'#runs',
		'#time',
		'#maxPause',
		'#youngFreed',
		'#oldGrown',
		'#grows',
		'#shrinks',
		'#rescued'
	],
	#category : #Kernel
}

{ #category : #accessing }
MemoryMeter >> growIfTime [
	memory old percentageOfCommitedUsed > 90 ifTrue: [
]

{ #category : #accessing }
MemoryMeter >> initialize [
	runs := 0.
]

{ #category : #accessing }
MemoryMeter >> measure: aBlock [
	| eden from old milliseconds |
]

{ #category : #accessing }
MemoryMeter >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
MemoryMeter >> statistics [
	^String streamContents: [:s | 
]

{ #category : #accessing }
MemoryMeter >> statitistics [
	^String streamContents: [:s | 
]

{ #category : #accessing }
MemoryMeter >> throughput [
	^time = 0
]
