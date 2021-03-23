"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.MediaType',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'schema',
		'example',
		'examples',
		'encoding'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.MediaType >> encoding [
	^encoding]

{ #category : #accessing }
OpenAPI.MediaType >> encoding: aDictionary [
	encoding := aDictionary]

{ #category : #accessing }
OpenAPI.MediaType >> example [
	^example]

{ #category : #accessing }
OpenAPI.MediaType >> example: anObject [
	example := anObject]

{ #category : #accessing }
OpenAPI.MediaType >> examples [
	^examples]

{ #category : #accessing }
OpenAPI.MediaType >> examples: aDictionary [
	examples := aDictionary]

{ #category : #accessing }
OpenAPI.MediaType >> schema [
	^schema]

{ #category : #accessing }
OpenAPI.MediaType >> schema: anOpenAPI [
.Schema
	schema := anOpenAPI.Schema]

