"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Reference',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'ref'
	],
	#category : #OpenAPI
}

{ #category : #converting }
OpenAPI.Reference >> asJson [
	^JsonObject new at: '$ref' put: ref; yourself]

{ #category : #productions }
OpenAPI.Reference >> mediaType [
	^MediaType json]

{ #category : #accessing }
OpenAPI.Reference >> ref [
	^ref]

{ #category : #accessing }
OpenAPI.Reference >> ref: aString [
	ref := aString]

