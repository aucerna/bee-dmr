"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpServerLogging,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'directory'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
HttpServerLogging class >> iis [
	^IISLogging new]

{ #category : #'instance creation' }
HttpServerLogging class >> ncsa [
	^NCSALogging new]

{ #category : #'instance creation' }
HttpServerLogging class >> new [
	^super new initialize]

{ #category : #'instance creation' }
HttpServerLogging class >> raw [
	^RawLogging]

{ #category : #'instance creation' }
HttpServerLogging class >> w3c [
	^W3CLogging new]

{ #category : #converting }
HttpServerLogging >> asCustomLogging [
	^CustomLogging new directory: directory]

{ #category : #converting }
HttpServerLogging >> asIISLogging [
	^IISLogging new directory: directory]

{ #category : #converting }
HttpServerLogging >> asNCSALogging [
	^NCSALogging new directory: directory]

{ #category : #converting }
HttpServerLogging >> asRawLogging [
	^RawLogging new directory: directory]

{ #category : #converting }
HttpServerLogging >> asW3CLogging [
	^W3CLogging new directory: directory]

{ #category : #accessing }
HttpServerLogging >> directory [
	^directory]

{ #category : #accessing }
HttpServerLogging >> directory: aDirectory [
	directory := aDirectory]

{ #category : #accessing }
HttpServerLogging >> disable [
	enabled := false]

{ #category : #accessing }
HttpServerLogging >> enable [
	enabled := true]

{ #category : #initialization }
HttpServerLogging >> initialize [
	super initialize.
	enabled := false]

{ #category : #testing }
HttpServerLogging >> isEnabled [
	^enabled]

{ #category : #actions }
HttpServerLogging >> logRequest: anHttpRequest [
	]

{ #category : #actions }
HttpServerLogging >> logResponse: anHttpResponse [
	]

{ #category : #testing }
HttpServerLogging >> needsSetup [
	^true]

{ #category : #accessing }
HttpServerLogging >> type [
	^self subclassResponsibility]

