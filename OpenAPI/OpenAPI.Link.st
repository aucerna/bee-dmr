"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Link',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'operationRef',
		'operationId',
		'parameters',
		'requestBody',
		'description',
		'server'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Link >> description [
	^description]

{ #category : #accessing }
OpenAPI.Link >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Link >> operationId [
	^operationId]

{ #category : #accessing }
OpenAPI.Link >> operationId: aString [
	operationId := aString]

{ #category : #accessing }
OpenAPI.Link >> operationRef [
	^operationRef]

{ #category : #accessing }
OpenAPI.Link >> operationRef: aString [
	operationRef := aString]

{ #category : #accessing }
OpenAPI.Link >> parameters [
	^parameters]

{ #category : #accessing }
OpenAPI.Link >> parameters: aDictionary [
	parameters := aDictionary]

{ #category : #accessing }
OpenAPI.Link >> requestBody [
	^requestBody]

{ #category : #accessing }
OpenAPI.Link >> requestBody: expression [
	requestBody := expression]

{ #category : #accessing }
OpenAPI.Link >> server [
	^server]

{ #category : #accessing }
OpenAPI.Link >> server: anOpenAPI [
.Server
	server := anOpenAPI.Server]

