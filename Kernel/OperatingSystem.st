"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OperatingSystem,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#category : #Kernel
}

{ #category : #accessing }
OperatingSystem class >> current [
	^Current
]

{ #category : #memory }
OperatingSystem >> lastError [
	^self subclassResponsibility
]

{ #category : #memory }
OperatingSystem >> reserve: size near: address [
	| limit |
	limit := (1 bitShift: WordSize * 8 - 2) - size.
	^self reserve: size near: address limit: limit
]

{ #category : #memory }
OperatingSystem >> reserveAndCommit: size near: address [
	| limit |
	limit := (1 bitShift: WordSize * 8 - 2) - size.
	^self reserveAndCommit: size near: address limit: limit
]

