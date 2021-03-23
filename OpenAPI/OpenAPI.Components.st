"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Components',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'schemas',
		'responses',
		'parameters',
		'examples',
		'requestBodies',
		'headers',
		'securitySchemes',
		'links',
		'callbacks'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Components >> addSchema: anOpenAPI.Schema [
named: aString
	schemas isNil ifTrue: [schemas := Dictionary new].
	schemas at: aString put: anOpenAPI.Schema]

{ #category : #accessing }
OpenAPI.Components >> addSecurityScheme: anOpenAPI.SecurityScheme [
named: aString
	securitySchemes isNil ifTrue: [securitySchemes := Dictionary new].
	securitySchemes at: aString put: anOpenAPI.SecurityScheme]

{ #category : #accessing }
OpenAPI.Components >> callbacks [
	^callbacks]

{ #category : #accessing }
OpenAPI.Components >> callbacks: aDictionary [
	callbacks := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> examples [
	^examples]

{ #category : #accessing }
OpenAPI.Components >> examples: aDictionary [
	examples := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> headers [
	^headers]

{ #category : #accessing }
OpenAPI.Components >> headers: aDictionary [
	headers := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> links [
	^links]

{ #category : #accessing }
OpenAPI.Components >> links: aDictionary [
	links := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> parameters [
	^parameters]

{ #category : #accessing }
OpenAPI.Components >> parameters: aDictionary [
	parameters := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> requestBodies [
	^requestBodies]

{ #category : #accessing }
OpenAPI.Components >> requestBodies: aDictionary [
	requestBodies := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> responses [
	^responses]

{ #category : #accessing }
OpenAPI.Components >> responses: aDictionary [
	responses := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> schemas [
	^schemas]

{ #category : #accessing }
OpenAPI.Components >> schemas: aDictionary [
	schemas := aDictionary]

{ #category : #accessing }
OpenAPI.Components >> securitySchemes [
	^securitySchemes]

{ #category : #accessing }
OpenAPI.Components >> securitySchemes: aDictionary [
	securitySchemes := aDictionary]

