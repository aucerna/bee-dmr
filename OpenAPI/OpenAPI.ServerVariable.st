"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.ServerVariable',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'enum',
		'default',
		'description'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.ServerVariable >> default [
	^default]

{ #category : #accessing }
OpenAPI.ServerVariable >> default: aString [
	default := aString]

{ #category : #accessing }
OpenAPI.ServerVariable >> description [
	^description]

{ #category : #accessing }
OpenAPI.ServerVariable >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.ServerVariable >> enum [
	^enum]

{ #category : #accessing }
OpenAPI.ServerVariable >> enum: aCollection [
	enum := aCollection]

