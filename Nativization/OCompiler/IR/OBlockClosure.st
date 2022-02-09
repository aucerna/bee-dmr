"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OBlockClosure,
	#superclass : #OInstruction,
	#instVars : [
		'firstBlock'
	],
	#category : #IR
}

{ #category : #unclassified }
OBlockClosure class >> containing: initialBlock [
	^self new firstBlock: initialBlock
]

{ #category : #unclassified }
OBlockClosure >> dissolveDeep [
	firstBlock withSuccessorsDo: [:block | block dissolveAllInstructions].
	super dissolveDeep
]

{ #category : #unclassified }
OBlockClosure >> doDuplicateWith: map [
	| copy |
	copy := super doDuplicateWith: map.
	copy firstBlock: (firstBlock duplicateWith: map).
	^copy
]

{ #category : #unclassified }
OBlockClosure >> duplicateWith: map [
	^map at: self ifAbsent: [self doDuplicateWith: map]
]

{ #category : #unclassified }
OBlockClosure >> firstBlock [
	^firstBlock
]

{ #category : #unclassified }
OBlockClosure >> firstBlock: basicBlock [
	firstBlock := basicBlock
]

{ #category : #unclassified }
OBlockClosure >> isBlockClosure [
	^true
]

{ #category : #unclassified }
OBlockClosure >> isUseless [
	^firstUse isNil
]

{ #category : #unclassified }
OBlockClosure >> lastBlock [
	^firstBlock lastBlock
]

{ #category : #unclassified }
OBlockClosure >> lastValue [
	^firstBlock lastBlock lastValue
]

{ #category : #private }
OBlockClosure >> operandsDo: aBlock [
	
]

