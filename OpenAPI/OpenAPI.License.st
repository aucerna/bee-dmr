"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.License',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'name',
		'url'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.License >> name [
	^name]

{ #category : #accessing }
OpenAPI.License >> name: aString [
	name := aString]

{ #category : #accessing }
OpenAPI.License >> url [
	^url]

{ #category : #accessing }
OpenAPI.License >> url: aString [
	url := aString]

