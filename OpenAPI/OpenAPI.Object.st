"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Object',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'openapi',
		'info',
		'servers',
		'paths',
		'components',
		'security',
		'tags',
		'externalDocs'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Object class >> currentVersion [
	^'3.0.0']

{ #category : #accessing }
OpenAPI.Object >> addBasicAuthentication [
	| requirement |
	components
		addSecurityScheme: OpenAPI.SecurityScheme basic
		named: 'basicAuth'.
	security isNil ifTrue: [security := OrderedCollection new].
	requirement := OpenAPI.SecurityRequirement new
		addSchemeNamed: 'basicAuth'
		scope: #().
	security add: requirement]

{ #category : #accessing }
OpenAPI.Object >> addServer: anOpenAPI [
.Server
	servers isNil ifTrue: [servers := OrderedCollection new].
	servers add: anOpenAPI.Server]

{ #category : #accessing }
OpenAPI.Object >> components [
	^components]

{ #category : #accessing }
OpenAPI.Object >> components: anOpenAPI [
.Components
	components := anOpenAPI.Components]

{ #category : #accessing }
OpenAPI.Object >> externalDocs [
	^externalDocs]

{ #category : #accessing }
OpenAPI.Object >> externalDocs: anOpenAPI [
.ExternalDocumentation
	externalDocs := anOpenAPI.ExternalDocumentation]

{ #category : #accessing }
OpenAPI.Object >> info [
	^info]

{ #category : #accessing }
OpenAPI.Object >> info: anOpenAPI [
.Info
	info := anOpenAPI.Info]

{ #category : #initialization }
OpenAPI.Object >> initialize [
	super initialize.
	openapi := self class currentVersion.
	info := OpenAPI.Info new.
	paths := OpenAPI.Paths new.
	components := OpenAPI.Components new]

{ #category : #services }
OpenAPI.Object >> json [
	^JsonWriter write: self asJson]

{ #category : #accessing }
OpenAPI.Object >> openapi [
	^openapi]

{ #category : #accessing }
OpenAPI.Object >> openapi: aString [
	openapi := aString]

{ #category : #accessing }
OpenAPI.Object >> paths [
	^paths]

{ #category : #accessing }
OpenAPI.Object >> paths: aCollection [
	paths := aCollection]

{ #category : #accessing }
OpenAPI.Object >> security [
	^security]

{ #category : #accessing }
OpenAPI.Object >> security: aCollection [
	security := aCollection]

{ #category : #accessing }
OpenAPI.Object >> servers [
	^servers]

{ #category : #accessing }
OpenAPI.Object >> servers: aCollection [
	servers := aCollection]

{ #category : #accessing }
OpenAPI.Object >> tags [
	^tags]

{ #category : #accessing }
OpenAPI.Object >> tags: aCollection [
	tags := aCollection]

