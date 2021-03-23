"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Tag',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'name',
		'description',
		'externalDocs'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Tag >> description [
	^description]

{ #category : #accessing }
OpenAPI.Tag >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Tag >> externalDocs [
	^externalDocs]

{ #category : #accessing }
OpenAPI.Tag >> externalDocs: anOpenAPI [
.ExternalDocumentation
	externalDocs := anOpenAPI.ExternalDocumentation]

{ #category : #accessing }
OpenAPI.Tag >> name [
	^name]

{ #category : #accessing }
OpenAPI.Tag >> name: aString [
	name := aString]

