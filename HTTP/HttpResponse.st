"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpResponse,
	#superclass : #HttpMessage,
	#instVars : [
		'status',
		'reason',
		'request'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpResponse class >> forRequest: anHttpRequest [
	^self new forRequest: anHttpRequest]

{ #category : #status }
HttpResponse >> accepted [
	status := HTTP_STATUS_ACCEPTED.
	reason := 'The request has been accepted for processing, but the processing has not been completed']

{ #category : #headers }
HttpResponse >> accessControlAllowHeaders: aString [
	headers accessControlAllowHeaders: aString]

{ #category : #headers }
HttpResponse >> accessControlAllowMethods: aCollection [
	headers accessControlAllowMethods: aCollection]

{ #category : #headers }
HttpResponse >> accessControlAllowOrigin: aString [
	headers accessControlAllowOrigin: aString]

{ #category : #headers }
HttpResponse >> attachment [
	| disposition filename |
	disposition := self contentDisposition readStream.
	filename := disposition throughAll: 'attachment; filename='; upTo: $;.
	^(filename size > 0 and: [filename first = $"] and: [filename last = $"])
		ifTrue: [filename copyFrom: 2 to: filename size - 1]
		ifFalse: [filename]]

{ #category : #headers }
HttpResponse >> attachment: aFilename [
	self
		contentDisposition: 'attachment; filename='
			, aFilename asFilename entityName doubleQuoted
			, ';']

{ #category : #status }
HttpResponse >> badMethod [
	status := HTTP_STATUS_BAD_METHOD.
	reason := 'The HTTP verb used is not allowed.']

{ #category : #status }
HttpResponse >> badRequest [
	status := HTTP_STATUS_BAD_REQUEST.
	reason := 'The request could not be processed by the server due to invalid syntax.']

{ #category : #status }
HttpResponse >> badRequest: details [
	self badRequest; textData: details]

{ #category : #request }
HttpResponse >> clientIP [
	^request clientIP]

{ #category : #status }
HttpResponse >> conflict [
	status := HTTP_STATUS_CONFLICT.
	reason := 'The request could not be completed due to a conflict with the current state of the resource. The user should resubmit with more information.']

{ #category : #headers }
HttpResponse >> contentDisposition [
	^headers contentDisposition]

{ #category : #headers }
HttpResponse >> contentDisposition: aString [
	headers contentDisposition: aString]

{ #category : #accessing }
HttpResponse >> contentType [
	^super contentType ifNotNil: [:type | type reduced]]

{ #category : #headers }
HttpResponse >> cookie [
	^self setCookie]

{ #category : #headers }
HttpResponse >> cookies [
	^self propertyAt: #cookies ifAbsentPut: [| cookies |
		cookies := Dictionary new.
		self cookie ifNotNil: [:c | cookies at: c name put: c].
		cookies]]

{ #category : #status }
HttpResponse >> created [
	status := HTTP_STATUS_CREATED.
	reason := 'Ok']

{ #category : #status }
HttpResponse >> error [
	status := HTTP_STATUS_SERVER_ERROR.
	reason := 'The server encountered an unexpected condition which prevented it from fulfilling the request']

{ #category : #status }
HttpResponse >> error: aString [
	self error.
	reason := 'Unexpected Error: ' , aString]

{ #category : #status }
HttpResponse >> forbidden [
	status := HTTP_STATUS_FORBIDDEN.
	reason := 'The server understood the request, but is refusing to fulfill it.']

{ #category : #status }
HttpResponse >> forbidden: details [
	self forbidden; textData: details]

{ #category : #accessing }
HttpResponse >> forRequest: anHttpRequest [
	request := anHttpRequest.
	id := request id]

{ #category : #testing }
HttpResponse >> hasContentLength [
	^headers hasContentLength]

{ #category : #testing }
HttpResponse >> hasCreatedStatus [
	^status = HTTP_STATUS_CREATED]

{ #category : #testing }
HttpResponse >> hasError [
	^status >= 400]

{ #category : #testing }
HttpResponse >> hasNoContentStatus [
	^status = HTTP_STATUS_NO_CONTENT]

{ #category : #testing }
HttpResponse >> hasTransferEncoding [
	^headers hasTransferEncoding]

{ #category : #testing }
HttpResponse >> hasWebSocketAccept [
	^headers webSocketAccept notNil]

{ #category : #request }
HttpResponse >> host [
	^request host]

{ #category : #initialization }
HttpResponse >> initialize [
	super initialize.
	status := HTTP_STATUS_OK]

{ #category : #testing }
HttpResponse >> isAccepted [
	^status = HTTP_STATUS_ACCEPTED]

{ #category : #testing }
HttpResponse >> isBadRequest [
	^status = HTTP_STATUS_BAD_REQUEST]

{ #category : #testing }
HttpResponse >> isConflict [
	^status = HTTP_STATUS_CONFLICT]

{ #category : #testing }
HttpResponse >> isDenied [
	^status = HTTP_STATUS_DENIED]

{ #category : #testing }
HttpResponse >> isForbidden [
	^status = HTTP_STATUS_FORBIDDEN]

{ #category : #testing }
HttpResponse >> isHttpResponse [
	^true]

{ #category : #testing }
HttpResponse >> isNotFound [
	^status = HTTP_STATUS_NOT_FOUND]

{ #category : #testing }
HttpResponse >> isOk [
	^status = HTTP_STATUS_OK]

{ #category : #testing }
HttpResponse >> isRedirect [
	^status between: 300 and: 399]

{ #category : #status }
HttpResponse >> isUnauthorized [
	^self isDenied]

{ #category : #status }
HttpResponse >> moveTo: url [
	status := HTTP_STATUS_MOVED.
	headers location: url reduced]

{ #category : #status }
HttpResponse >> noContent [
	status := HTTP_STATUS_NO_CONTENT.
	reason := 'The server has fulfilled the request, but there is no new information to send back.']

{ #category : #status }
HttpResponse >> notFound [
	status := HTTP_STATUS_NOT_FOUND.
	reason := 'The server has not found anything matching the requested URI (Uniform Resource Identifier).']

{ #category : #status }
HttpResponse >> ok [
	status := HTTP_STATUS_OK.
	reason := 'Ok']

{ #category : #request }
HttpResponse >> port [
	^request port]

{ #category : #printing }
HttpResponse >> printTextOn: rtf [
	rtf
		useColor: Color darkGreen while: [
			rtf bold: status asString.
			reason notNil ifTrue: [
				rtf
					nextPutAll: ' (';
					append: reason;
					nextPut: $)]];
		space;
		useColor: Color darkGray
		while: [rtf nextPutAll: self version asString];
		cr.
	headers printTextOn: rtf.
	rtf
		cr;
		useColor: Color brown while: [rtf nextPutAll: 'Body: '].
	self data printTextOn: rtf]

{ #category : #request }
HttpResponse >> queryString [
	^request queryString]

{ #category : #reading }
HttpResponse >> readFrom: aStream [
	| line version |
	line := aStream nextLine.
	line isEmpty ifTrue: [line := aStream nextLine].
	line := line readStream.
	version := line upTo: Character space.
	self ASSERT: version = 'HTTP/1.1'.
	status := (line upTo: Character space) asInteger.
	reason := line upToEnd.
	super readFrom: aStream]

{ #category : #accessing }
HttpResponse >> reason [
	^reason]

{ #category : #accessing }
HttpResponse >> reason: aString [
	reason := aString]

{ #category : #status }
HttpResponse >> redirectTo: url [
	status := HTTP_STATUS_REDIRECT_METHOD.
	headers location: url reduced]

{ #category : #request }
HttpResponse >> referer [
	^request referer]

{ #category : #accessing }
HttpResponse >> request [
	^request]

{ #category : #accessing }
HttpResponse >> requestId [
	^id]

{ #category : #request }
HttpResponse >> serverIP [
	^request serverIP]

{ #category : #request }
HttpResponse >> serviceName [
	^request serviceName]

{ #category : #request }
HttpResponse >> serviceName: aString [
	request serviceName: aString]

{ #category : #headers }
HttpResponse >> setCookie [
	^headers setCookie ifNotNil: [:raw | HttpCookie fromString: raw]]

{ #category : #headers }
HttpResponse >> setCookie: anHttpCookie [
	headers setCookie: anHttpCookie asString]

{ #category : #headers }
HttpResponse >> setCookie: name with: value [
	| cookie |
	cookie := HttpCookie new name: name; value: value.
	self setCookie: cookie]

{ #category : #accessing }
HttpResponse >> status [
	^status]

{ #category : #accessing }
HttpResponse >> status: anInteger [
	status := anInteger]

{ #category : #accessing }
HttpResponse >> substatus [
	^0]

{ #category : #testing }
HttpResponse >> switchesProtocols [
	^status = HTTP_STATUS_SWITCH_PROTOCOLS]

{ #category : #status }
HttpResponse >> switchProtocols [
	status := HTTP_STATUS_SWITCH_PROTOCOLS.
	reason := 'The server has switched protocols in an upgrade header.']

{ #category : #status }
HttpResponse >> unauthorized [
	status := HTTP_STATUS_DENIED.
	reason := 'The requested resource requires user authentication.']

{ #category : #status }
HttpResponse >> unavailable [
	status := HTTP_STATUS_SERVICE_UNAVAIL.
	reason := 'The service is temporarily unavailable.']

{ #category : #status }
HttpResponse >> unsupported [
	status := HTTP_STATUS_NOT_SUPPORTED.
	reason := 'The server does not support the functionality required to fulfill the request.']

{ #category : #request }
HttpResponse >> uri [
	^request uri]

{ #category : #request }
HttpResponse >> userAgent [
	^request userAgent]

{ #category : #request }
HttpResponse >> username [
	^request username]

{ #category : #request }
HttpResponse >> username: aString [
	request username: aString]

{ #category : #request }
HttpResponse >> verb [
	^request verb]

{ #category : #websockets }
HttpResponse >> webSocketAccepted: acceptKey [
	self switchProtocols.
	headers acceptWebSocket: acceptKey]

{ #category : #writing }
HttpResponse >> writeOn: aStream [
	aStream nextPutAll: self version; space.
	status printOn: aStream.
	aStream space; nextPutAll: reason; crlf.
	super writeOn: aStream]

