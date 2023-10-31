"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OLocal,
	#superclass : #OProjection,
	#instVars : [
		'index'
	],
	#category : #IR
}

{ #category : #accessing }
OLocal >> activation [
	^input activation
]

{ #category : #accessing }
OLocal >> function [
	^input
]

{ #category : #accessing }
OLocal >> index [
	^index
]

{ #category : #accessing }
OLocal >> index: anInteger [
	index := anInteger
]

{ #category : #printing }
OLocal >> primitivePrintString [
	^String streamContents: [:strm | 
		strm
			nextPut: $[;
			nextPutAll: self typeString;
			space;
			nextPut: $#;
			nextPutAll: name printString;
			nextPut: $]]
]

{ #category : #printing }
OLocal >> typeString [
	^self subclassResponsibility
]

