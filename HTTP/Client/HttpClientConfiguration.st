"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpClientConfiguration,
	#superclass : #HttpConfiguration,
	#instVars : [
		'vault',
		'authenticator',
		'sso',
		'persistent',
		'log'
	],
	#category : #'HTTP\Client'
}

{ #category : #accessing }
HttpClientConfiguration >> authenticator [
	^authenticator]

{ #category : #accessing }
HttpClientConfiguration >> authenticator: aSymbol [
	authenticator := aSymbol]

{ #category : #accessing }
HttpClientConfiguration >> bePersistent [
	persistent := true]

{ #category : #accessing }
HttpClientConfiguration >> credentials [
	^vault notNil ifTrue: [vault credentials] ifFalse: [super credentials]]

{ #category : #writing }
HttpClientConfiguration >> currentPassword [
	^self password]

{ #category : #services }
HttpClientConfiguration >> ignoreVault [
	vault := nil]

{ #category : #initialization }
HttpClientConfiguration >> initialize [
	super initialize.
	sso := false.
	persistent := true]

{ #category : #testing }
HttpClientConfiguration >> isPersistent [
	^persistent]

{ #category : #accessing }
HttpClientConfiguration >> logFilename [
	^log]

{ #category : #accessing }
HttpClientConfiguration >> logFilename: aFilename [
	log := aFilename]

{ #category : #services }
HttpClientConfiguration >> newAuthenticator [
	authenticator == #oidc ifTrue: [^HttpOIDCAuthenticator new].
	^HttpBasicAuthenticator new]

{ #category : #accessing }
HttpClientConfiguration >> password [
	^vault notNil ifTrue: [vault password] ifFalse: [super password]]

{ #category : #accessing }
HttpClientConfiguration >> password: aString [
	vault notNil
		ifTrue: [vault password: aString]
		ifFalse: [super password: aString]]

{ #category : #accessing }
HttpClientConfiguration >> persistent: aBoolean [
	persistent := aBoolean]

{ #category : #printing }
HttpClientConfiguration >> printTextOn: rtf [
	super printTextOn: rtf.
	vault notNil ifTrue: [
		rtf
			cr;
			useBoldWhile: [rtf nextPutAll: 'Vault: '];
			nextPutAll: vault name asString].
	rtf
		cr;
		useBoldWhile: [rtf nextPutAll: 'SSO: '];
		nextPutAll: sso asString;
		cr;
		useBoldWhile: [rtf nextPutAll: 'Persistent: '];
		nextPutAll: persistent asString.
	self usesLog ifTrue: [
		rtf
			cr;
			useBoldWhile: [rtf nextPutAll: 'Log: '];
			nextPutAll: log asString]]

{ #category : #testing }
HttpClientConfiguration >> requiresAuthorization [
	authenticator notNil ifTrue: [^true].
	sso ifTrue: [^false].
	^super requiresAuthorization]

{ #category : #accessing }
HttpClientConfiguration >> useCredentialsFrom: anObject [
	vault := anObject]

{ #category : #accessing }
HttpClientConfiguration >> useOIDC [
	authenticator := #oidc]

{ #category : #accessing }
HttpClientConfiguration >> username [
	^vault notNil ifTrue: [vault username] ifFalse: [super username]]

{ #category : #accessing }
HttpClientConfiguration >> username: aString [
	vault notNil
		ifTrue: [vault username: aString]
		ifFalse: [super username: aString]]

{ #category : #accessing }
HttpClientConfiguration >> useSingleSignOn: aBoolean [
	sso := aBoolean]

{ #category : #testing }
HttpClientConfiguration >> usesLog [
	^log notNil]

{ #category : #testing }
HttpClientConfiguration >> usesOIDC [
	^authenticator == #oidc]

{ #category : #testing }
HttpClientConfiguration >> usesSingleSignOn [
	^sso]

{ #category : #accessing }
HttpClientConfiguration >> vault [
	^vault]

{ #category : #accessing }
HttpClientConfiguration >> vaultName [
	^vault notNil ifTrue: [vault name]]

{ #category : #accessing }
HttpClientConfiguration >> vaultName: aString [
	vault := aString notNil ifTrue: [CredentialVault named: aString]]

{ #category : #accessing }
HttpClientConfiguration >> withoutAuthenticator [
	authenticator := vault := nil]

