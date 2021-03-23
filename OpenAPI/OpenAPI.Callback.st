"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Callback',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'callbacks'
	],
	#category : #OpenAPI
}

{ #category : #converting }
OpenAPI.Callback >> asJson [
	| json |
	json := JsonObject new.
	callbacks
		keysAndValuesDo: [:expression :callback | json
			at: expression
			put: callback asJson].
	^json]

{ #category : #accessing }
OpenAPI.Callback >> callbacks [
	^callbacks]

{ #category : #accessing }
OpenAPI.Callback >> callbacks: aDictionary [
	callbacks := aDictionary]

