"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.OAuthFlow',
	#superclass : #'OpenAPI.Node',
	#instVars : [
		'authorizationUrl',
		'tokenUrl',
		'refreshUrl',
		'scopes'
	],
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.OAuthFlow >> authorizationUrl [
	^authorizationUrl]

{ #category : #accessing }
OpenAPI.OAuthFlow >> authorizationUrl: aString [
	authorizationUrl := aString]

{ #category : #accessing }
OpenAPI.OAuthFlow >> refreshUrl [
	^refreshUrl]

{ #category : #accessing }
OpenAPI.OAuthFlow >> refreshUrl: aString [
	refreshUrl := aString]

{ #category : #accessing }
OpenAPI.OAuthFlow >> scopes: aDictionary [
	scopes := aDictionary]

{ #category : #accessing }
OpenAPI.OAuthFlow >> tokenUrl [
	^tokenUrl]

{ #category : #accessing }
OpenAPI.OAuthFlow >> tokenUrl: aString [
	tokenUrl := aString]

