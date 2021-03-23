"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Operation',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'tags',
		'summary',
		'description',
		'externalDocs',
		'operationId',
		'parameters',
		'requestBody',
		'responses',
		'callbacks',
		'deprecated',
		'security',
		'servers'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Operation >> addParameter: anOpenAPI [
.Parameter
	parameters add: anOpenAPI.Parameter]

{ #category : #accessing }
OpenAPI.Operation >> addResponse: status description: aString [
	^responses addStatus: status description: aString]

{ #category : #accessing }
OpenAPI.Operation >> callbacks [
	^callbacks]

{ #category : #accessing }
OpenAPI.Operation >> callbacks: aDictionary [
	callbacks := aDictionary]

{ #category : #accessing }
OpenAPI.Operation >> deprecated [
	^deprecated]

{ #category : #accessing }
OpenAPI.Operation >> deprecated: aBoolean [
	deprecated := aBoolean]

{ #category : #accessing }
OpenAPI.Operation >> description [
	^description]

{ #category : #accessing }
OpenAPI.Operation >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Operation >> externalDocs [
	^externalDocs]

{ #category : #accessing }
OpenAPI.Operation >> externalDocs: anOpenAPI [
.ExternalDocumentation
	externalDocs := anOpenAPI.ExternalDocumentation]

{ #category : #initialization }
OpenAPI.Operation >> initialize [
	super initialize.
	deprecated := false.
	parameters := OrderedCollection new.
	responses := OpenAPI.Responses new]

{ #category : #accessing }
OpenAPI.Operation >> operationId [
	^operationId]

{ #category : #accessing }
OpenAPI.Operation >> operationId: aString [
	operationId := aString]

{ #category : #accessing }
OpenAPI.Operation >> parameters: aCollection [
	parameters := aCollection]

{ #category : #accessing }
OpenAPI.Operation >> requestBody [
	^requestBody]

{ #category : #accessing }
OpenAPI.Operation >> requestBody: anOpenAPI [
.RequestBody
	requestBody := anOpenAPI.RequestBody]

{ #category : #accessing }
OpenAPI.Operation >> responses [
	^responses]

{ #category : #accessing }
OpenAPI.Operation >> responses: anOpenAPI [
.Responses
	responses := anOpenAPI.Responses]

{ #category : #accessing }
OpenAPI.Operation >> security [
	^security]

{ #category : #accessing }
OpenAPI.Operation >> security: aCollection [
	security := aCollection]

{ #category : #accessing }
OpenAPI.Operation >> servers [
	^servers]

{ #category : #accessing }
OpenAPI.Operation >> servers: aCollection [
	servers := aCollection]

{ #category : #accessing }
OpenAPI.Operation >> summary [
	^summary]

{ #category : #accessing }
OpenAPI.Operation >> summary: aString [
	summary := aString]

{ #category : #accessing }
OpenAPI.Operation >> tag: aString [
	tags := {aString}]

{ #category : #accessing }
OpenAPI.Operation >> tags [
	^tags]

{ #category : #accessing }
OpenAPI.Operation >> tags: aCollection [
	tags := aCollection]

