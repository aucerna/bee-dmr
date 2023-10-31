"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ONonLocalReturn,
	#superclass : #OReturn,
	#instVars : [
		'home'
	],
	#category : #IR
}

{ #category : #printing }
ONonLocalReturn >> basicPrintString [
	^String streamContents: [:strm | 
		strm
			nextPutAll: '[nl ret ';
			nextPutAll: source primitivePrintString;
			nextPutAll: ' @ ';
			nextPutAll: home primitivePrintString;
			nextPut: $]]
]

{ #category : #copying }
ONonLocalReturn >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy home: (home duplicateWith: map)
]

{ #category : #accessing }
ONonLocalReturn >> home: anOMethod [
	home := anOMethod
]

{ #category : #testing }
ONonLocalReturn >> isNonLocal [
	^true
]

{ #category : #printing }
ONonLocalReturn >> primitivePrintString [
	^'{nl-ret}'
]

{ #category : #printing }
ONonLocalReturn >> printStringUsing: names [
	| s h |
	s := names at: source ifAbsent: '?'.
	h := names at: home ifAbsent: '?'.
	^'nl-ret ' , s , ' @ ' , h
]

