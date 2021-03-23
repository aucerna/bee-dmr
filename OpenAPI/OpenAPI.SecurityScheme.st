"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.SecurityScheme',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'type',
		'description',
		'name',
		'in',
		'scheme',
		'bearerFormat',
		'flows',
		'openIdConnectUrl'
	],
	#category : #OpenAPI
}

{ #category : #private }
OpenAPI.SecurityScheme class >> basic [
	^self new type: 'http'; scheme: 'basic']

{ #category : #accessing }
OpenAPI.SecurityScheme >> bearerFormat [
	^bearerFormat]

{ #category : #accessing }
OpenAPI.SecurityScheme >> bearerFormat: aString [
	bearerFormat := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> description [
	^description]

{ #category : #accessing }
OpenAPI.SecurityScheme >> description: aString [
	description := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> flows [
	^flows]

{ #category : #accessing }
OpenAPI.SecurityScheme >> flows: anOpenAPI [
.OAuthFlows
	flows := anOpenAPI.OAuthFlows]

{ #category : #accessing }
OpenAPI.SecurityScheme >> in [
	^in]

{ #category : #accessing }
OpenAPI.SecurityScheme >> in: aString [
	in := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> name [
	^name]

{ #category : #accessing }
OpenAPI.SecurityScheme >> name: aString [
	name := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> openIdConnectUrl [
	^openIdConnectUrl]

{ #category : #accessing }
OpenAPI.SecurityScheme >> openIdConnectUrl: aString [
	openIdConnectUrl := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> scheme [
	^scheme]

{ #category : #accessing }
OpenAPI.SecurityScheme >> scheme: aString [
	scheme := aString]

{ #category : #accessing }
OpenAPI.SecurityScheme >> type [
	^type]

{ #category : #accessing }
OpenAPI.SecurityScheme >> type: aString [
	type := aString]

