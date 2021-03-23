"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Encoding',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'contentType',
		'headers',
		'style',
		'explode',
		'allowReserved'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Encoding >> allowReserved [
	^allowReserved]

{ #category : #accessing }
OpenAPI.Encoding >> allowReserved: aBoolean [
	allowReserved := aBoolean]

{ #category : #accessing }
OpenAPI.Encoding >> contentType [
	^contentType]

{ #category : #accessing }
OpenAPI.Encoding >> contentType: aString [
	contentType := aString]

{ #category : #accessing }
OpenAPI.Encoding >> explode [
	^explode]

{ #category : #accessing }
OpenAPI.Encoding >> explode: aBoolean [
	explode := aBoolean]

{ #category : #accessing }
OpenAPI.Encoding >> headers [
	^headers]

{ #category : #accessing }
OpenAPI.Encoding >> headers: aDictionary [
	headers := aDictionary]

{ #category : #accessing }
OpenAPI.Encoding >> style [
	^style]

{ #category : #accessing }
OpenAPI.Encoding >> style: aString [
	style := aString]

