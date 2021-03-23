"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Response',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'description',
		'headers',
		'content',
		'links'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Response >> content [
	^content]

{ #category : #accessing }
OpenAPI.Response >> content: aDictionary [
	content := aDictionary]

{ #category : #accessing }
OpenAPI.Response >> content: aString type: anOpenAPI [
.MediaType
	content isNil ifTrue: [content := Dictionary new].
	content at: aString put: anOpenAPI.MediaType]

{ #category : #accessing }
OpenAPI.Response >> description [
	^description]

{ #category : #accessing }
OpenAPI.Response >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Response >> headers [
	^headers]

{ #category : #accessing }
OpenAPI.Response >> headers: aDictionary [
	headers := aDictionary]

{ #category : #accessing }
OpenAPI.Response >> jsonSchema: anOpenAPI [
.Schema
	| type |
	type := OpenAPI.MediaType new.
	type schema: anOpenAPI.Schema.
	self content: 'application/json' type: type]

{ #category : #accessing }
OpenAPI.Response >> jsonType: aString [
	| schema |
	schema := OpenAPI.Schema new.
	schema type: aString.
	self jsonSchema: schema]

{ #category : #accessing }
OpenAPI.Response >> links [
	^links]

{ #category : #accessing }
OpenAPI.Response >> links: aDictionary [
	links := aDictionary]

