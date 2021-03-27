"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataPrimitiveLiteral,
	#superclass : #ODataExpression,
	#instVars : [
		'literal',
		'value'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataPrimitiveLiteral class >> null [
	^self new value: nil; literal: 'null']

{ #category : #evaluating }
ODataPrimitiveLiteral >> literal [
	^literal]

{ #category : #evaluating }
ODataPrimitiveLiteral >> literal: aString [
	literal := aString]

{ #category : #printing }
ODataPrimitiveLiteral >> printOn: aStream [
	literal isNil
		ifTrue: [aStream nextPutAll: 'undefined primitive']
		ifFalse: [aStream nextPutAll: literal]]

{ #category : #evaluating }
ODataPrimitiveLiteral >> value [
	^value]

{ #category : #evaluating }
ODataPrimitiveLiteral >> value: anObject [
	value := anObject]

