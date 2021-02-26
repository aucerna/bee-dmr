"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UserCredentials,
	#superclass : #Object,
	#instVars : [
		'username',
		'password'
	],
	#category : #Cryptography
}

{ #category : #'instance creation' }
UserCredentials class >> fromMemory: anExternalMemory [
	^self new fromMemory: anExternalMemory]

{ #category : #'instance creation' }
UserCredentials class >> username: aString password: aPassword [
	^self new username: aString; password: aPassword]

{ #category : #'xsd types' }
UserCredentials >> base64 [
	^password base64EncodingFor: username]

{ #category : #services }
UserCredentials >> clear [
	password notNil ifTrue: [password clear]]

{ #category : #comparing }
UserCredentials >> equals: aUserCredentials [
	^username = aUserCredentials username
		and: [password equals: aUserCredentials password]]

{ #category : #services }
UserCredentials >> formFor: tenant [
	^password
		withPrefix: 'grant_type=password&username=' , username , '&password='
		suffix: '&scope=planningspace&client_id=' , tenant
			, ' resource_owner&client_secret=']

{ #category : #accessing }
UserCredentials >> fromMemory: anExternalMemory [
	| utf8 c reader u n |
	utf8 := Crypt32DLL current decodedMemoryBase64: anExternalMemory.
	c := UTF8 decodeMemory: utf8 length: utf8 length.
	reader := c readStream.
	u := reader upToAll: #[0x3a 0x00].
	username := WideString fromBytes: u.
	n := reader position.
	password := Password at: c + n length: c length - n + 1]

{ #category : #services }
UserCredentials >> json [
	^password
		withPrefix: '{"userName":"' , username , '","password":"'
		suffix: '"}']

{ #category : #accessing }
UserCredentials >> password [
	^password]

{ #category : #accessing }
UserCredentials >> password: aString [
	password := aString isString
		ifTrue: [Password on: aString]
		ifFalse: [aString]]

{ #category : #accessing }
UserCredentials >> username [
	^username]

{ #category : #accessing }
UserCredentials >> username: aString [
	username := aString]

