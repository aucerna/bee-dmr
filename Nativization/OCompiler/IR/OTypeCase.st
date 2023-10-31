"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OTypeCase,
	#superclass : #Object,
	#instVars : [
		'token',
		'method',
		'probability'
	],
	#category : #IR
}

{ #category : #testing }
OTypeCase >> isStatic [
	^method notNil
]

{ #category : #accessing }
OTypeCase >> method [
	^method
]

{ #category : #accessing }
OTypeCase >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : #printing }
OTypeCase >> printOn: aStream [
	aStream
		nextPutAll: 'case <';
		print: token;
		nextPutAll: '> (';
		print: probability;
		nextPutAll: ') ';
		print: method
]

{ #category : #accessing }
OTypeCase >> probability [
	^probability
]

{ #category : #accessing }
OTypeCase >> probability: aNumber [
	probability := aNumber
]

{ #category : #accessing }
OTypeCase >> token [
	^token
]

{ #category : #accessing }
OTypeCase >> token: anObject [
	token := anObject
]

