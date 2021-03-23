"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Paths',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'paths'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Paths >> addPathTo: url [
	^paths at: url ifAbsentPut: [OpenAPI.PathItem new]]

{ #category : #converting }
OpenAPI.Paths >> asJson [
	| json |
	json := JsonObject new.
	paths keysAndValuesDo: [:path :item | json at: path put: item asJson].
	^json]

{ #category : #initialization }
OpenAPI.Paths >> initialize [
	super initialize.
	paths := OrderedDictionary new]

{ #category : #accessing }
OpenAPI.Paths >> paths [
	^paths]

{ #category : #accessing }
OpenAPI.Paths >> paths: aCollection [
	paths := aCollection]

{ #category : #accessing }
OpenAPI.Paths >> tags [
	^paths gather: #tags in: Set new]

