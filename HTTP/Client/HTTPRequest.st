"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HTTPRequest,
	#superclass : #InternetSessionObject,
	#instVars : [
		'connection',
		'response',
		'binary'
	],
	#category : #'HTTP\Client'
}

{ #category : #initialization }
HTTPRequest class >> availableEvents [
	^super availableEvents add: #percentSent:; yourself]

{ #category : #initialization }
HTTPRequest class >> initializeInterentReadFileConstants [
	WinInetConstants at: 'IRF_NO_WAIT' put: 8]

{ #category : #configuration }
HTTPRequest >> addFlagKeepConnection [
	self addFlag: INTERNET_FLAG_KEEP_CONNECTION]

{ #category : #configuration }
HTTPRequest >> addFlagNoAutoRedirect [
	self addFlag: INTERNET_FLAG_NO_AUTO_REDIRECT]

{ #category : #headers }
HTTPRequest >> addHeader: key value: value [
	| header |
	header := String streamContents: [:strm | 
		strm
			nextPutAll: key;
			nextPutAll: ':';
			nextPutAll: value;
			nextPut: Cr;
			nextPut: Lf].
	self addHeaders: header]

{ #category : #headers }
HTTPRequest >> addHeaders: aString [
	^self addHeaders: aString modifiers: HTTP_ADDREQ_FLAG_ADD]

{ #category : #'os messages' }
HTTPRequest >> addHeaders: aString modifiers: modifiers [
	| success string |
	string := aString externalCopy.
	success := self dll
		HttpAddRequestHeaders: self asParameter
		lpszHeaders: string asParameter
		dwHeadersLength: aString size
		dwModifiers: modifiers asParameter.
	success ifFalse: [self winError].
	string free]

{ #category : #private }
HTTPRequest >> chunkSizeFor: n [
	^n // 20 max: 1 kbytes min: 128 kbytes]

{ #category : #'open/close' }
HTTPRequest >> close [
	| result |
	result := super close.
	result ifFalse: [^result].
	connection notNil ifTrue: [connection forgetRequest: self].
	^result]

{ #category : #accessing }
HTTPRequest >> connection [
	^connection]

{ #category : #accessing }
HTTPRequest >> connection: anHTTPConnection [
	connection := anHTTPConnection]

{ #category : #'os messages' }
HTTPRequest >> endRequest [
	| success code |
	success := self dll
		HttpEndRequest: self asParameter
		lpBuffersOut: 0
		dwFlags: 0
		dwContext: 0.
	success ifFalse: [
		code := self lastWinError.
		code = ERROR_IO_PENDING ifTrue: [self wait] ifFalse: [self winError: code]]]

{ #category : #accessing }
HTTPRequest >> id [
	^handle asInteger]

{ #category : #initialization }
HTTPRequest >> initialize [
	super initialize.
	binary := true]

{ #category : #reading }
HTTPRequest >> next: count [
	| buffer read |
	buffer := ByteArray new: count.
	read := self readInto: buffer.
	^read < count ifTrue: [buffer copyFrom: 1 to: read] ifFalse: [buffer]]

{ #category : #writing }
HTTPRequest >> nextPut: aCharacter [
	self nextPutAll: aCharacter asString]

{ #category : #'os messages' }
HTTPRequest >> opened [
	self propertyAt: #open put: true]

{ #category : #'open/close' }
HTTPRequest >> openRequest: verb
objectName: objectName
version: version
referrer: referrer
acceptTypes: aCollection [
	| vb on ver ref tps ulong context |
	vb := verb externalCopy.
	on := objectName externalCopy.
	ver := version externalCopy.
	ref := referrer externalCopy.
	tps := aCollection notNil ifTrue: [
		String
			streamContents: [:strm | aCollection
				do: [:t | strm nextPutAll: t; nextPut: 0 asCharacter]]].
	tps := tps externalCopy.
	session isAsynchronous ifTrue: [context := token].
	self ASSERT: (semaphore isNil orNot: [semaphore isSignaled]).
	ulong := self dll
		HttpOpenRequest: connection asParameter
		lpszVerb: vb asParameter
		lpszObjectName: on asParameter
		lpszVersion: ver asParameter
		lpszReferrer: ref asParameter
		lplpszAcceptTypes: tps asParameter
		dwFlags: flags asParameter
		dwContext: context asParameter.
	ulong = 0 ifTrue: [self winError] ifFalse: [self handle: ulong].
	self wait.
	vb free.
	on free.
	ver free.
	ref free.
	tps free]

{ #category : #private }
HTTPRequest >> percentSent: anInteger [
	| continue |
	continue := self
		triggerEvent: #percentSent:
		with: anInteger
		defaultHandler: true.
	continue isNil ifTrue: [^true].
	^continue ifFalse: [self stopSending]; yourself]

{ #category : #'os messages' }
HTTPRequest >> queryDataAvailable [
	| available result code |
	available := ExternalInt32 external.
	result := self dll
		InternetQueryDataAvailable: self asParameter
		lpdwNumberOfBytesAvailable: available asParameter
		dwFlags: 0
		dwContext: 0.
	result ifFalse: [
		code := self lastWinError.
		code = ERROR_IO_PENDING ifTrue: [self wait] ifFalse: [
			available free.
			^self winError: code]].
	^available makeLocal asInteger]

{ #category : #queries }
HTTPRequest >> queryInfo: level [
	| index length result buffer status |
	index := ExternalInt32 external.
	length := ExternalInt32 external.
	result := self dll
		HttpQueryInfo: self asParameter
		dwInfoLevel: level asParameter
		lpBuffer: 0
		lpdwBufferLength: length asParameter
		lpdwIndex: index asParameter.
	buffer := (length asInteger + 1 * 2) externalBytes.
	result := self dll
		HttpQueryInfo: self asParameter
		dwInfoLevel: level asParameter
		lpBuffer: buffer asParameter
		lpdwBufferLength: length asParameter
		lpdwIndex: index asParameter.
	result ifFalse: [self winError].
	status := buffer makeUnicode.
	index free.
	length free.
	^status]

{ #category : #private }
HTTPRequest >> rawHeaders [
	^self queryInfo: HTTP_QUERY_RAW_HEADERS_CRLF]

{ #category : #'os messages' }
HTTPRequest >> read: bytes into: aByteArray [
	| length success read buffer |
	length := ExternalInt32 external.
	buffer := aByteArray externalCopy.
	success := self dll
		InternetReadFile: self asParameter
		lpBuffer: buffer asParameter
		dwNumberOfBytesToRead: bytes
		lpdwNumberOfBytesRead: length asParameter.
	success ifFalse: [self winError].
	read := length makeLocal asInteger.
	aByteArray replaceFirst: read with: buffer.
	buffer free.
	^read]

{ #category : #private }
HTTPRequest >> readBodyContents [
	| contents |
	contents := ByteArray streamContents: [:strm | | count |
		[
			count := self queryDataAvailable.
			count > 0]
			whileTrue: [| bytes |
				bytes := self next: count.
				strm nextPutAll: bytes]].
	binary ifTrue: [^contents].
	^UTF8 current decode: contents]

{ #category : #private }
HTTPRequest >> readHeaders [
	^HttpHeaders fromStream: self rawHeaders trimBlanks readStream]

{ #category : #reading }
HTTPRequest >> readInto: aByteArray [
	^self read: aByteArray size into: aByteArray]

{ #category : #inquiries }
HTTPRequest >> readResponse [
	response := HttpResponse forRequest: self.
	response
		headers: self readHeaders;
		body: self readBodyContents;
		status: self statusCode asInteger;
		reason: self statusText]

{ #category : #headers }
HTTPRequest >> replaceHeaders: aString [
	^self addHeaders: aString modifiers: HTTP_ADDREQ_FLAG_REPLACE]

{ #category : #inquiries }
HTTPRequest >> response [
	response isNil ifTrue: [self readResponse].
	^response]

{ #category : #sending }
HTTPRequest >> send [
	^self send: nil headers: nil]

{ #category : #sending }
HTTPRequest >> send: data [
	^self send: data headers: nil]

{ #category : #'os messages' }
HTTPRequest >> send: data headers: headers [
	| bytes h optional result n code |
	self ASSERT: data isString not.
	bytes := data isFile ifTrue: [data binaryContents] ifFalse: [data].
	h := headers externalCopy.
	bytes isNil
		ifTrue: [
			optional := nil.
			n := 0]
		ifFalse: [
			optional := bytes externalCopy.
			n := optional length].
	self ASSERT: (semaphore isNil orNot: [semaphore isSignaled]).
	result := self dll
		HttpSendRequest: self asParameter
		lpszHeaders: h asParameter
		dwHeadersLength: -1
		lpOptional: optional asParameter
		dwOptionalLength: n.
	result ifFalse: [
		code := self lastWinError.
		self winError: code].
	self wait.
	h free.
	data == optional ifFalse: [optional free].
	^result]

{ #category : #private }
HTTPRequest >> send: amount using: evaluableBuffer chunkSize: anInteger [
	| buffer written sent percent continue |
	amount = 0 ifTrue: [^self].
	written := ExternalInt32 external.
	sent := percent := 0.
	continue := true.
	[continue and: [sent < amount]] whileTrue: [| count success code p |
		buffer := evaluableBuffer evaluateWith: sent.
		count := anInteger min: amount - sent.
		success := self dll
			InternetWriteFile: self asParameter
			lpBuffer: buffer asParameter
			dwNumberOfBytesToWrite: count
			lpdwNumberOfBytesWritten: written asParameter.
		success ifFalse: [
			code := self lastWinError.
			code = ERROR_IO_PENDING
				ifTrue: [self wait]
				ifFalse: [self winError: code]].
		sent := sent + written asInteger.
		p := sent * 100 // amount.
		p > percent ifTrue: [
			percent := p.
			continue := self percentSent: percent asInteger]].
	written free.
	continue ifTrue: [self endRequest]]

{ #category : #private }
HTTPRequest >> sendBytes: bytes [
	| source n k buffer |
	bytes isExternalMemory
		ifTrue: [
			source := bytes.
			n := bytes length]
		ifFalse: [
			source := bytes asByteArray.
			n := bytes sizeInBytes].
	n = 0 ifTrue: [^self].
	k := self chunkSizeFor: n.
	buffer := k externalBytes.
	self
		send: n
		using: [:sent | 
			buffer
				replaceFrom: 1
				to: (k min: n - sent)
				with: source
				startingAt: sent + 1.
			buffer]
		chunkSize: k.
	bytes isExternalMemory ifTrue: [buffer clear].
	buffer free]

{ #category : #'os messages' }
HTTPRequest >> sendChunked: body headers: headers [
	| n buffers context success code |
	n := body isExternalMemory ifTrue: [body length] ifFalse: [body size].
	buffers := INTERNET_BUFFERS external totalSize: n; headers: headers.
	session isAsynchronous ifTrue: [context := token].
	success := self dll
		HttpSendRequestEx: self asParameter
		lpBuffersIn: buffers asParameter
		lpBuffersOut: 0
		dwFlags: 0
		dwContext: context asParameter.
	success ifFalse: [
		code := self lastWinError.
		code = ERROR_IO_PENDING ifFalse: [self winError: code]].
	self wait.
	self sendData: body.
	body isExternalMemory ifTrue: [buffers clear].
	buffers free]

{ #category : #private }
HTTPRequest >> sendData: data [
	data isFile ifTrue: [self sendFile: data] ifFalse: [self sendBytes: data]]

{ #category : #private }
HTTPRequest >> sendFile: aFile [
	| n k buffer file |
	file := aFile openReadOnly.
	n := file fileSize.
	k := self chunkSizeFor: n.
	n = 0 ifTrue: [^self].
	buffer := k externalBytes.
	[
		self
			send: n
			using: [:sent | 
				file read: k at: sent into: buffer.
				buffer]
			chunkSize: k]
		ensure: [
			buffer free.
			file close]]

{ #category : #inquiries }
HTTPRequest >> statusCode [
	^self queryInfo: HTTP_QUERY_STATUS_CODE]

{ #category : #inquiries }
HTTPRequest >> statusText [
	^self queryInfo: HTTP_QUERY_STATUS_TEXT]

{ #category : #private }
HTTPRequest >> stopSending [
	self release.
	HttpRequestCancelled signal]

