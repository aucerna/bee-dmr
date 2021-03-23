"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.OAuthFlows',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'implicit',
		'password',
		'clientCredentials',
		'authorizationCode'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.OAuthFlows >> authorizationCode [
	^authorizationCode]

{ #category : #accessing }
OpenAPI.OAuthFlows >> authorizationCode: anOpenAPI [
.OAuthFlow
	authorizationCode := anOpenAPI.OAuthFlow]

{ #category : #accessing }
OpenAPI.OAuthFlows >> clientCredentials [
	^clientCredentials]

{ #category : #accessing }
OpenAPI.OAuthFlows >> clientCredentials: anOpenAPI [
.OAuthFlow
	clientCredentials := anOpenAPI.OAuthFlow]

{ #category : #accessing }
OpenAPI.OAuthFlows >> implicit [
	^implicit]

{ #category : #accessing }
OpenAPI.OAuthFlows >> implicit: anOpenAPI [
.OAuthFlow
	implicit := anOpenAPI.OAuthFlow]

{ #category : #accessing }
OpenAPI.OAuthFlows >> password [
	^password]

{ #category : #accessing }
OpenAPI.OAuthFlows >> password: anOpenAPI [
.OAuthFlow
	password := anOpenAPI.OAuthFlow]

