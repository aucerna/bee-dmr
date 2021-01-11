"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpOIDCAuthenticator,
	#superclass : #HttpRequestAuthenticator,
	#instVars : [
		'token'
	],
	#category : #HTTP
}

{ #category : #private }
HttpOIDCAuthenticator >> authenticate: anHttpRequest using: anHttpConfiguration [
	| credentials |
	token isNil ifTrue: [^self].
	credentials := token value.
	anHttpRequest authorization: token key , ' ' , credentials]

{ #category : #testing }
HttpOIDCAuthenticator >> hasOIDCToken [
	^token notNil]

{ #category : #accessing }
HttpOIDCAuthenticator >> token [
	^token]

{ #category : #private }
HttpOIDCAuthenticator >> useToken: anAssociation [
	token := anAssociation]

