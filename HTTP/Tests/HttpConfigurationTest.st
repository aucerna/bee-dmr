"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpConfigurationTest,
	#superclass : #TestCase,
	#category : #'HTTP\Tests'
}

{ #category : #all }
HttpConfigurationTest >> testTP44691 [
	| registry |
	registry := CredentialVault named: 'TP44691'.
	registry username: 'testTP44691' password: ''.
	[| configuration |
		configuration := HttpClientConfiguration new vaultName: 'TP44691'.
		self
			assert: configuration username = 'testTP44691';
			assert: configuration password isEmpty]
		ensure: [registry delete]]

