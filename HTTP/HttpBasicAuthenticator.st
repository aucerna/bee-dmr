"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpBasicAuthenticator,
	#superclass : #HttpRequestAuthenticator,
	#category : #HTTP
}

{ #category : #accessing }
HttpBasicAuthenticator class >> type [
	^'Basic']

{ #category : #private }
HttpBasicAuthenticator >> authenticate: anHttpRequest using: anHttpConfiguration [
	| credentials memory bytes |
	credentials := anHttpConfiguration credentials base64.
	memory := UTF8
		encodeMemory: credentials
		length: credentials length // 2 - 1.
	bytes := memory bytes.
	memory clear: memory length; free.
	anHttpRequest authorization: 'Basic ' , bytes.
	bytes atAllPut: 0.
	credentials clear: credentials length; free]

{ #category : #private }
HttpBasicAuthenticator >> credentialsFrom: anHttpRequest [
	| authorization parts credentials |
	authorization := anHttpRequest authorization.
	authorization isNil ifTrue: [^nil].
	parts := authorization substrings.
	parts size < 2 ifTrue: [^nil].
	parts first = self type ifFalse: [^nil].
	credentials := Crypt32DLL current decodeBase64: parts second.
	credentials := $: split: (UTF8 decode: credentials).
	^credentials size = 2 ifTrue: [credentials first -> credentials second]]

{ #category : #testing }
HttpBasicAuthenticator >> isBasic [
	^true]

