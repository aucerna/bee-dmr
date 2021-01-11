"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestAuthenticator,
	#superclass : #Object,
	#instVars : [
		'realm'
	],
	#category : #HTTP
}

{ #category : #initialization }
HttpRequestAuthenticator class >> default [
	^self defaultClass new]

{ #category : #initialization }
HttpRequestAuthenticator class >> defaultClass [
	^HttpBasicAuthenticator]

{ #category : #'instance creation' }
HttpRequestAuthenticator class >> for: realm [
	^self new realm: realm]

{ #category : #private }
HttpRequestAuthenticator class >> type: aString [
	"
	HttpRequestAuthenticator type: 'Basic'
	"
	^self allSubclasses detect: [:c | c type = aString] ifNone: nil]

{ #category : #inquiries }
HttpRequestAuthenticator >> credentialsFrom: anHttpRequest [
	self subclassResponsibility]

{ #category : #testing }
HttpRequestAuthenticator >> hasOIDCToken [
	^false]

{ #category : #testing }
HttpRequestAuthenticator >> isBasic [
	^false]

{ #category : #accessing }
HttpRequestAuthenticator >> realm [
	^realm]

{ #category : #accessing }
HttpRequestAuthenticator >> realm: aString [
	realm := aString]

{ #category : #accessing }
HttpRequestAuthenticator >> type [
	^self class type]

{ #category : #inquiries }
HttpRequestAuthenticator >> usernameFrom: anHttpRequest [
	^(self credentialsFrom: anHttpRequest)
		ifNotNil: [:credentials | credentials key]]

