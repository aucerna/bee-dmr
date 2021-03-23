"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.SecurityRequirement',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'schemes'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.SecurityRequirement >> addSchemeNamed: aString scope: aCollection [
	schemes isNil ifTrue: [schemes := Dictionary new].
	schemes at: aString put: aCollection]

{ #category : #converting }
OpenAPI.SecurityRequirement >> asJson [
	| json |
	json := JsonObject new.
	schemes keysAndValuesDo: [:name :scope | json at: name put: scope].
	^json]

{ #category : #accessing }
OpenAPI.SecurityRequirement >> schemes [
	^schemes]

{ #category : #accessing }
OpenAPI.SecurityRequirement >> schemes: aDictionary [
	schemes := aDictionary]

