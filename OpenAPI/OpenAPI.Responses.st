"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Responses',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'default',
		'statuses'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Responses >> addStatus: anInteger description: aString [
	| response |
	response := OpenAPI.Response new.
	response description: aString.
	statuses at: anInteger put: response.
	^response]

{ #category : #converting }
OpenAPI.Responses >> asJson [
	| json |
	json := JsonObject new.
	default notNil ifTrue: [json at: 'default' put: default asJson].
	statuses
		keysAndValuesDo: [:status :response | json
			at: status asString
			put: response asJson].
	^json]

{ #category : #accessing }
OpenAPI.Responses >> default [
	^default]

{ #category : #accessing }
OpenAPI.Responses >> default: anOpenAPI [
.Response
	default := anOpenAPI.Response]

{ #category : #initialization }
OpenAPI.Responses >> initialize [
	super initialize.
	statuses := Dictionary new]

{ #category : #accessing }
OpenAPI.Responses >> statuses [
	^statuses]

{ #category : #accessing }
OpenAPI.Responses >> statuses: aDictionary [
	statuses := aDictionary]

