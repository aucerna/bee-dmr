"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Server',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'url',
		'description',
		'variables'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Server >> description [
	^description]

{ #category : #accessing }
OpenAPI.Server >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Server >> url [
	^url]

{ #category : #accessing }
OpenAPI.Server >> url: aString [
	url := aString]

{ #category : #accessing }
OpenAPI.Server >> variables [
	^variables]

{ #category : #accessing }
OpenAPI.Server >> variables: aDictionary [
	variables := aDictionary]

