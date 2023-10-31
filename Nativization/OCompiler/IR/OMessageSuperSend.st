"
	Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #OMessageSuperSend,
	#superclass : #OMessageSend,
	#instVars : [
		'method'
	],
	#category : #IR
}

{ #category : #testing }
OMessageSuperSend >> isSuperSend [
	^true
]

{ #category : #accessing }
OMessageSuperSend >> method [
	method
]

{ #category : #accessing }
OMessageSuperSend >> method: aCompiledMethod [
	method := aCompiledMethod
]

