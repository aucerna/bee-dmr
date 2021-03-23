"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.ExternalDocumentation',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'description',
		'url'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.ExternalDocumentation >> description [
	^description]

{ #category : #accessing }
OpenAPI.ExternalDocumentation >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.ExternalDocumentation >> url [
	^url]

{ #category : #accessing }
OpenAPI.ExternalDocumentation >> url: aString [
	url := aString]

