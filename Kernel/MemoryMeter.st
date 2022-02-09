"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MemoryMeter,
	#superclass : #Object,
	#instVars : [
		'memory',
		'runs',
		'time',
		'maxPause',
		'youngFreed',
		'oldGrown',
		'grows',
		'shrinks',
		'rescued'
	],
	#category : #Kernel
}

{ #category : #accessing }
MemoryMeter >> initialize [
	runs := OrderedCollection new: 1000
]

{ #category : #accessing }
MemoryMeter >> measure: aBlock [
	| eden from old remembered milliseconds tenured cradled run ephemerons |
	eden := memory eden usedBytes.
	from := memory from usedBytes.
	old := memory old usedBytes.
	remembered := memory rememberedSet size.
	ephemerons := memory unreachableEphemerons size.
	milliseconds := Time millisecondsToRun: aBlock.
	tenured := memory old usedBytes - old.
	cradled := memory from usedBytes.
	run := GenGCPass new
		time: milliseconds;
		oldSize: old;
		youngSize: eden + from;
		cradled: cradled;
		tenured: tenured;
		rememberedBefore: remembered;
		rememberedAfter: memory rememberedSet size;
		rescued: memory unreachableEphemerons size - ephemerons.
	runs add: run
]

{ #category : #accessing }
MemoryMeter >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
MemoryMeter >> runs [
	^runs
]

{ #category : #accessing }
MemoryMeter >> statistics [
	^'GC passes: ' , runs size asString
]

