"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #CustomLogging,
	#superclass : #HttpServerLogging,
	#category : #'HTTP\Server'
}

{ #category : #converting }
CustomLogging >> asCustomLogging [
	^self]

{ #category : #accessing }
CustomLogging >> filename [
	^directory \ 'request-response.log']

{ #category : #actions }
CustomLogging >> log: aString [
	| ts stream |
	ts := Timestamp now.
	stream := self filename asFile appendStream.
	[
		stream
			lineDelimiter: Character cr;
			nextPutAll: ts iso8601;
			space;
			nextPutAll: aString;
			cr]
		ensure: [stream close]]

{ #category : #actions }
CustomLogging >> logRequest: anHttpRequest [
	| line |
	line := '' writeStream.
	line
		nextPutAll: '>>REQUEST ';
		nextPutAll: anHttpRequest id asString;
		space;
		nextPutAll: anHttpRequest method;
		space;
		nextPutAll: anHttpRequest url asString reduced.
	self log: line contents]

{ #category : #actions }
CustomLogging >> logResponse: anHttpResponse [
	| line |
	line := '' writeStream.
	line
		nextPutAll: '<<RESPONSE ';
		nextPutAll: anHttpResponse requestId asString;
		space;
		nextPutAll: anHttpResponse status asString.
	self log: line contents]

{ #category : #testing }
CustomLogging >> needsSetup [
	^false]

