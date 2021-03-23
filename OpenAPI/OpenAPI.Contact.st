"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Contact',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'name',
		'url',
		'email'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Contact >> email [
	^email]

{ #category : #accessing }
OpenAPI.Contact >> email: aString [
	email := aString]

{ #category : #accessing }
OpenAPI.Contact >> name [
	^name]

{ #category : #accessing }
OpenAPI.Contact >> name: aString [
	name := aString]

{ #category : #accessing }
OpenAPI.Contact >> url [
	^url]

{ #category : #accessing }
OpenAPI.Contact >> url: aString [
	url := aString]

