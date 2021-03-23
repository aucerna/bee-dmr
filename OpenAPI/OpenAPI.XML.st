"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.XML',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'name',
		'namespace',
		'prefix',
		'attribute',
		'wrapped'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.XML >> attribute [
	^attribute]

{ #category : #accessing }
OpenAPI.XML >> attribute: aBoolean [
	attribute := aBoolean]

{ #category : #accessing }
OpenAPI.XML >> name [
	^name]

{ #category : #accessing }
OpenAPI.XML >> name: aString [
	name := aString]

{ #category : #accessing }
OpenAPI.XML >> namespace [
	^namespace]

{ #category : #accessing }
OpenAPI.XML >> namespace: aString [
	namespace := aString]

{ #category : #accessing }
OpenAPI.XML >> prefix [
	^prefix]

{ #category : #accessing }
OpenAPI.XML >> prefix: aString [
	prefix := aString]

{ #category : #accessing }
OpenAPI.XML >> wrapped [
	^wrapped]

{ #category : #accessing }
OpenAPI.XML >> wrapped: aBoolean [
	wrapped := aBoolean]

