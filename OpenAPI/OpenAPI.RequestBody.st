"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.RequestBody',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'description',
		'content',
		'required'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.RequestBody >> content [
	^content]

{ #category : #accessing }
OpenAPI.RequestBody >> content: aDictionary [
	content := aDictionary]

{ #category : #accessing }
OpenAPI.RequestBody >> description [
	^description]

{ #category : #accessing }
OpenAPI.RequestBody >> description: aString [
	description := aString]

{ #category : #initialization }
OpenAPI.RequestBody >> initialize [
	super initialize.
	required := false.
	content := Dictionary new]

{ #category : #accessing }
OpenAPI.RequestBody >> plainText [
	| schema |
	schema := OpenAPI.Schema new.
	schema type: 'string'.
	self schema: schema]

{ #category : #accessing }
OpenAPI.RequestBody >> required [
	^required]

{ #category : #accessing }
OpenAPI.RequestBody >> required: aBoolean [
	required := aBoolean]

{ #category : #accessing }
OpenAPI.RequestBody >> schema: anOpenAPI [
.Schema
	| type |
	type := OpenAPI.MediaType new.
	type schema: anOpenAPI.Schema.
	content at: anOpenAPI.Schema mediaType asString put: type]

