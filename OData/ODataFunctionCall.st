"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ODataFunctionCall,
	#superclass : #ODataExpression,
	#instVars : [
		'name',
		'arguments'
	],
	#category : #OData
}

{ #category : #'instance creation' }
ODataFunctionCall class >> name: aString argument: anODataExpression [
	^self new name: aString; arguments: {anODataExpression}]

{ #category : #'instance creation' }
ODataFunctionCall class >> name: aString arguments: aCollection [
	^self new name: aString; arguments: aCollection]

{ #category : #accessing }
ODataFunctionCall >> arguments [
	^arguments]

{ #category : #accessing }
ODataFunctionCall >> arguments: aCollection [
	arguments := aCollection]

{ #category : #initialization }
ODataFunctionCall >> initialize [
	super initialize.
	name := 'unknown'.
	arguments := #()]

{ #category : #testing }
ODataFunctionCall >> isFunctionCall [
	^true]

{ #category : #accessing }
ODataFunctionCall >> name [
	^name]

{ #category : #accessing }
ODataFunctionCall >> name: aString [
	name := aString]

{ #category : #printing }
ODataFunctionCall >> printOn: aStream [
	aStream nextPutAll: name; space; nextPut: $(.
	arguments
		do: [:arg | arg printOn: aStream]
		separatedBy: [aStream nextPut: $,; space].
	aStream nextPut: $)]

