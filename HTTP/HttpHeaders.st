"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpHeaders,
	#superclass : #Object,
	#instVars : [
		'headers'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpHeaders class >> forWebSocketKey: key [
	^self new requestWebSocket: key]

{ #category : #'instance creation' }
HttpHeaders class >> fromStream: aStream [
	^self new readFrom: aStream]

{ #category : #'instance creation' }
HttpHeaders class >> new [
	^super new initialize]

{ #category : #constants }
HttpHeaders class >> webSocketVersion [
	^13]

{ #category : #'instance creation' }
HttpHeaders class >> withAll: aDictionary [
	^self new addAll: aDictionary]

{ #category : #common }
HttpHeaders >> accept [
	^self at: 'Accept']

{ #category : #common }
HttpHeaders >> accept: aMediaType [
	self at: 'Accept' add: aMediaType asString]

{ #category : #common }
HttpHeaders >> acceptCharset: aString [
	self at: 'Accept-Charset' put: aString]

{ #category : #websockets }
HttpHeaders >> acceptWebSocket: acceptKey [
	self upgradeToWebSocket; upgradeConnection; webSocketAccept: acceptKey]

{ #category : #common }
HttpHeaders >> accessControlAllowHeaders: aString [
	self at: 'Access-Control-Allow-Headers' put: aString]

{ #category : #common }
HttpHeaders >> accessControlAllowMethods: aCollection [
	| methods |
	methods := String streamContents: [:strm | 
		aCollection
			do: [:method | strm nextPutAll: method]
			separatedBy: [strm nextPut: $,]].
	self at: 'Access-Control-Allow-Methods' put: methods]

{ #category : #common }
HttpHeaders >> accessControlAllowOrigin: aString [
	self at: 'Access-Control-Allow-Origin' put: aString]

{ #category : #common }
HttpHeaders >> accessControlRequestHeaders [
	^self at: 'Access-Control-Request-Headers']

{ #category : #common }
HttpHeaders >> accessControlRequestMethod [
	^self at: 'Access-Control-Request-Method']

{ #category : #accessing }
HttpHeaders >> addAll: aDictionary [
	aDictionary isNil ifTrue: [^self].
	headers addAll: aDictionary]

{ #category : #accessing }
HttpHeaders >> at: aString [
	^headers valueAt: aString]

{ #category : #accessing }
HttpHeaders >> at: name add: value [
	| current new |
	current := self at: name.
	new := current notNil ifTrue: [current , '; ' , value] ifFalse: [value].
	self at: name put: new]

{ #category : #accessing }
HttpHeaders >> at: name put: value [
	headers at: name put: value]

{ #category : #common }
HttpHeaders >> authorization [
	^self at: 'Authorization']

{ #category : #common }
HttpHeaders >> authorization: aString [
	self at: 'Authorization' put: aString]

{ #category : #common }
HttpHeaders >> closeConnection [
	self connection: 'close']

{ #category : #common }
HttpHeaders >> connection [
	^self at: 'Connection']

{ #category : #common }
HttpHeaders >> connection: aString [
	self at: 'Connection' put: aString]

{ #category : #common }
HttpHeaders >> contentDisposition [
	^self at: 'Content-Disposition']

{ #category : #common }
HttpHeaders >> contentDisposition: aString [
	self at: 'Content-Disposition' put: aString]

{ #category : #common }
HttpHeaders >> contentLength [
	^self at: 'Content-Length']

{ #category : #common }
HttpHeaders >> contentLength: anInteger [
	self at: 'Content-Length' put: anInteger asString]

{ #category : #common }
HttpHeaders >> contentType [
	^self at: 'Content-Type']

{ #category : #common }
HttpHeaders >> contentType: aMediaType [
	self at: 'Content-Type' put: aMediaType asString]

{ #category : #common }
HttpHeaders >> cookie [
	^self at: 'Cookie']

{ #category : #common }
HttpHeaders >> cookie: aString [
	headers at: 'Cookie' put: aString]

{ #category : #private }
HttpHeaders >> delimeter [
	^String with: Character cr with: Character lf]

{ #category : #enumerating }
HttpHeaders >> do: aBlock [
	aBlock argumentCount = 1
		ifTrue: [headers associationsDo: aBlock]
		ifFalse: [headers keysAndValuesDo: aBlock]]

{ #category : #testing }
HttpHeaders >> hasContentLength [
	^self contentLength notNil]

{ #category : #testing }
HttpHeaders >> hasTransferEncoding [
	^self transferEncoding notNil]

{ #category : #common }
HttpHeaders >> host: aString [
	headers at: 'Host' put: aString]

{ #category : #initialization }
HttpHeaders >> initialize [
	super initialize.
	headers := OrderedDictionary new]

{ #category : #testing }
HttpHeaders >> isEmpty [
	^headers isEmpty]

{ #category : #common }
HttpHeaders >> keepAlive [
	self connection: 'Keep-Alive']

{ #category : #enumerating }
HttpHeaders >> keysAndValuesDo: aBlock [
	headers keysAndValuesDo: aBlock]

{ #category : #common }
HttpHeaders >> location [
	^self at: 'Location']

{ #category : #common }
HttpHeaders >> location: aString [
	self at: 'Location' put: aString]

{ #category : #common }
HttpHeaders >> noCache [
	self at: 'Cache-Control' put: 'no-cache']

{ #category : #testing }
HttpHeaders >> notEmpty [
	^headers notEmpty]

{ #category : #common }
HttpHeaders >> origin [
	^self at: 'Origin']

{ #category : #printing }
HttpHeaders >> printOn: aStream [
	self isEmpty
		ifTrue: [super printOn: aStream]
		ifFalse: [headers associations printOn: aStream]]

{ #category : #printing }
HttpHeaders >> printTextOn: rtf [
	headers associations
		do: [:header | 
			rtf
				useColor: Color brown while: [rtf nextPutAll: header key];
				nextPutAll: ': ';
				useColor: Color black while: [rtf nextPutAll: header value]]
		separatedBy: [rtf cr]]

{ #category : #reading }
HttpHeaders >> readFrom: aStream [
	| separator line |
	separator := $:.
	[
		line := aStream nextLine.
		line notEmpty]
		whileTrue: [| name value |
			line := line readStream.
			name := line upTo: separator.
			value := line upToEnd trimBlanks.
			value notEmpty ifTrue: [self at: name put: value]]]

{ #category : #common }
HttpHeaders >> referer [
	^(self at: 'Referer') ifNil: [self at: 'Referrer']]

{ #category : #websockets }
HttpHeaders >> requestWebSocket: clientKey [
	self
		upgradeToWebSocket;
		upgradeConnection;
		webSocketVersion: self class webSocketVersion asString;
		webSocketKey: clientKey]

{ #category : #common }
HttpHeaders >> setCookie [
	^self at: 'Set-Cookie']

{ #category : #common }
HttpHeaders >> setCookie: aString [
	self at: 'Set-Cookie' put: aString]

{ #category : #common }
HttpHeaders >> transferEncoding [
	^self at: 'Transfer-Encoding']

{ #category : #common }
HttpHeaders >> upgrade [
	^self at: 'Upgrade']

{ #category : #common }
HttpHeaders >> upgrade: aString [
	self at: 'Upgrade' put: aString]

{ #category : #common }
HttpHeaders >> upgradeConnection [
	self connection: 'Upgrade']

{ #category : #testing }
HttpHeaders >> upgradesConnection [
	| connection |
	connection := self connection ifNil: ''.
	^connection asLowercase = 'upgrade']

{ #category : #testing }
HttpHeaders >> upgradesToWebSocket [
	| upgrade |
	upgrade := self upgrade ifNil: ''.
	^upgrade asLowercase = 'websocket']

{ #category : #websockets }
HttpHeaders >> upgradeToWebSocket [
	self upgrade: 'websocket']

{ #category : #common }
HttpHeaders >> userAgent [
	^self at: 'User-Agent']

{ #category : #common }
HttpHeaders >> userAgent: aString [
	self at: 'User-Agent' put: aString]

{ #category : #common }
HttpHeaders >> varyAccept [
	self at: 'Vary' put: 'Accept']

{ #category : #common }
HttpHeaders >> webSocketAccept [
	^self at: 'Sec-WebSocket-Accept']

{ #category : #websockets }
HttpHeaders >> webSocketAccept: aString [
	self at: 'Sec-WebSocket-Accept' put: aString]

{ #category : #websockets }
HttpHeaders >> webSocketHeaders [
	^#(
		'Sec-WebSocket-Accept' 
		'Sec-WebSocket-Key' 
		'Sec-WebSocket-Version' 
		'Connection'
		'Upgrade'
		'Host')
		select: [:n | headers includesKey: n]
		thenCollect: [:n | headers associationAt: n]]

{ #category : #websockets }
HttpHeaders >> webSocketKey [
	^self at: 'Sec-WebSocket-Key']

{ #category : #websockets }
HttpHeaders >> webSocketKey: aString [
	self at: 'Sec-WebSocket-Key' put: aString]

{ #category : #websockets }
HttpHeaders >> webSocketVersion [
	^self at: 'Sec-WebSocket-Version']

{ #category : #websockets }
HttpHeaders >> webSocketVersion: aString [
	self at: 'Sec-WebSocket-Version' put: aString]

{ #category : #writing }
HttpHeaders >> writeOn: aStream [
	| separator |
	separator := $:.
	headers keysAndValuesDo: [:name :value | 
		aStream
			nextPutAll: name;
			nextPut: separator;
			space;
			nextPutAll: value;
			crlf]]

{ #category : #common }
HttpHeaders >> wwwAuthenticate: type realm: realm [
	self at: 'WWW-Authenticate' put: type , ' realm= ' , realm]

