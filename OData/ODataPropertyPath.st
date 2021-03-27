"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataPropertyPath,
	#superclass : #ODataExpression,
	#instVars : [
		'levels'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataPropertyPath class >> fromString: aString [
	^self new levels: {aString}]

{ #category : #operations }
ODataPropertyPath >> , anObject [
	anObject class = ODataLambdaOperator ifTrue: [^anObject pathPrefix: self].
	levels := anObject class = self class
		ifTrue: [levels , anObject levels]
		ifFalse: [levels copyWith: anObject]]

{ #category : #initialization }
ODataPropertyPath >> initialize [
	super initialize.
	levels := Array new]

{ #category : #operations }
ODataPropertyPath >> levels [
	^levels]

{ #category : #operations }
ODataPropertyPath >> levels: aCollection [
	levels := aCollection]

{ #category : #printing }
ODataPropertyPath >> printOn: aStream [
	levels withNextDo: [:l1 :l2 | 
		l1 isString
			ifTrue: [aStream nextPutAll: l1]
			ifFalse: [l1 printOn: aStream].
		l2 class == ODataKeyPredicate ifFalse: [aStream nextPut: $/]].
	levels last isString
		ifTrue: [aStream nextPutAll: levels last]
		ifFalse: [levels last printOn: aStream]]

