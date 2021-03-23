"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Discriminator',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'propertyName',
		'mapping'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Discriminator >> mapping [
	^mapping]

{ #category : #accessing }
OpenAPI.Discriminator >> mapping: aDictionary [
	mapping := aDictionary]

{ #category : #accessing }
OpenAPI.Discriminator >> propertyName [
	^propertyName]

{ #category : #accessing }
OpenAPI.Discriminator >> propertyName: aString [
	propertyName := aString]

