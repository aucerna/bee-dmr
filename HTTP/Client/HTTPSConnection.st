"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTPSConnection,
	#superclass : #HTTPConnection,
	#category : #'HTTP\Client'
}

{ #category : #initialization }
HTTPSConnection >> initializeFlags [
	super initializeFlags.
	self addFlagSecure]

{ #category : #initialization }
HTTPSConnection >> initializePort [
	port := INTERNET_DEFAULT_HTTPS_PORT]

{ #category : #'open/close' }
HTTPSConnection >> newRequest [
	^super newRequest addFlag: INTERNET_FLAG_SECURE]

{ #category : #accessing }
HTTPSConnection >> requestClass [
	^HTTPSRequest]

