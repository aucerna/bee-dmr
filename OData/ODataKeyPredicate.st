"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataKeyPredicate,
	#superclass : #Object,
	#instVars : [
		'predicate'
	],
	#category : #OData
}

{ #category : #private }
ODataKeyPredicate >> predicate [
	^predicate]

{ #category : #private }
ODataKeyPredicate >> predicate: expression [
	predicate := expression]

{ #category : #printing }
ODataKeyPredicate >> printOn: aStream [
	aStream nextPut: $(.
	predicate printOn: aStream.
	aStream nextPut: $)]

