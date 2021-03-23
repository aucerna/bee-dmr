"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.PathItem',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'ref',
		'summary',
		'description',
		'get',
		'put',
		'post',
		'delete',
		'options',
		'head',
		'patch',
		'trace',
		'servers',
		'parameters'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.PathItem >> delete [
	^delete]

{ #category : #accessing }
OpenAPI.PathItem >> delete: anOpenAPI [
.Operation
	delete := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> description [
	^description]

{ #category : #accessing }
OpenAPI.PathItem >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.PathItem >> get [
	^get]

{ #category : #accessing }
OpenAPI.PathItem >> get: anOpenAPI [
.Operation
	get := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> head [
	^head]

{ #category : #accessing }
OpenAPI.PathItem >> head: anOpenAPI [
.Operation
	head := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> options [
	^options]

{ #category : #accessing }
OpenAPI.PathItem >> options: anOpenAPI [
.Operation
	options := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> parameters [
	^parameters]

{ #category : #accessing }
OpenAPI.PathItem >> parameters: aCollection [
	parameters := aCollection]

{ #category : #accessing }
OpenAPI.PathItem >> patch [
	^patch]

{ #category : #accessing }
OpenAPI.PathItem >> patch: anOpenAPI [
.Operation
	patch := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> post [
	^post]

{ #category : #accessing }
OpenAPI.PathItem >> post: anOpenAPI [
.Operation
	post := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> put [
	^put]

{ #category : #accessing }
OpenAPI.PathItem >> put: anOpenAPI [
.Operation
	put := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> ref [
	^ref]

{ #category : #accessing }
OpenAPI.PathItem >> ref: aString [
	ref := aString]

{ #category : #accessing }
OpenAPI.PathItem >> servers [
	^servers]

{ #category : #accessing }
OpenAPI.PathItem >> servers: aCollection [
	^aCollection]

{ #category : #accessing }
OpenAPI.PathItem >> summary [
	^summary]

{ #category : #accessing }
OpenAPI.PathItem >> summary: aString [
	summary := aString]

{ #category : #services }
OpenAPI.PathItem >> tags [
	^Array streamContents: [:strm | 
		get notNil ifTrue: [strm nextPutAll: get tags].
		put notNil ifTrue: [strm nextPutAll: put tags].
		post notNil ifTrue: [strm nextPutAll: post tags].
		delete notNil ifTrue: [strm nextPutAll: delete tags].
		options notNil ifTrue: [strm nextPutAll: options tags].
		head notNil ifTrue: [strm nextPutAll: head tags].
		patch notNil ifTrue: [strm nextPutAll: patch tags].
		trace notNil ifTrue: [strm nextPutAll: trace tags]]]

{ #category : #accessing }
OpenAPI.PathItem >> trace [
	^trace]

{ #category : #accessing }
OpenAPI.PathItem >> trace: anOpenAPI [
.Operation
	trace := anOpenAPI.Operation]

{ #category : #accessing }
OpenAPI.PathItem >> verb: aString operation: anOpenAPI [
.Operation
	| verb |
	verb := aString asLowercase.
	verb = 'get' ifTrue: [^self get: anOpenAPI.Operation].
	verb = 'put' ifTrue: [^self put: anOpenAPI.Operation].
	verb = 'post' ifTrue: [^self post: anOpenAPI.Operation].
	verb = 'delete' ifTrue: [^self delete: anOpenAPI.Operation].
	verb = 'options' ifTrue: [^self options: anOpenAPI.Operation].
	verb = 'head' ifTrue: [^self head: anOpenAPI.Operation].
	verb = 'patch' ifTrue: [^self patch: anOpenAPI.Operation].
	verb = 'trace' ifTrue: [^self trace: anOpenAPI.Operation].
	self ASSERT: false]

