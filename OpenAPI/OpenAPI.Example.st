"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Example',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'summary',
		'description',
		'value',
		'externalValue'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Example >> description [
	^description]

{ #category : #accessing }
OpenAPI.Example >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.Example >> externalValue [
	^externalValue]

{ #category : #accessing }
OpenAPI.Example >> externalValue: aString [
	externalValue := aString]

{ #category : #accessing }
OpenAPI.Example >> summary [
	^summary]

{ #category : #accessing }
OpenAPI.Example >> summary: aString [
	summary := aString]

{ #category : #accessing }
OpenAPI.Example >> value [
	^value]

{ #category : #accessing }
OpenAPI.Example >> value: anObject [
	value := anObject]

