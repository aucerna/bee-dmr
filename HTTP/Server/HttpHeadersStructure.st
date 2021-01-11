"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpHeadersStructure,
	#superclass : #HttpApiStructure,
	#classVars : [
		'KnownHeaderConstants'
	],
	#category : #'HTTP\Server'
}

{ #category : #accessing }
HttpHeadersStructure class >> headerNameAt: index [
	^self knownHeaders at: index ifAbsent: nil]

{ #category : #initialization }
HttpHeadersStructure class >> initializeKnownHeaderConstants [
	| headers |
	headers := Dictionary new.
	WinConstants keysAndValuesDo: [:key :value | | header |
		(key beginsWith: 'HttpHeader') ifTrue: [
			header := key allButFirst: 'HttpHeader' size.
			header := String streamContents: [:strm | 
				header subwords
					do: [:word | strm nextPutAll: word]
					separatedBy: [strm nextPut: $-]].
			headers at: value put: header]].
	KnownHeaderConstants := headers keys asArray sort
		collect: [:i | headers at: i]]

{ #category : #accessing }
HttpHeadersStructure class >> knownHeaders [
	KnownHeaderConstants isNil ifTrue: [self initializeKnownHeaderConstants].
	^KnownHeaderConstants]

{ #category : #output }
HttpHeadersStructure >> Accept [
	^self headerAt: HttpHeaderAccept]

{ #category : #input }
HttpHeadersStructure >> Accept: aString [
	self headerAt: HttpHeaderAccept put: aString]

{ #category : #output }
HttpHeadersStructure >> AcceptCharset [
	^self headerAt: HttpHeaderAcceptCharset]

{ #category : #input }
HttpHeadersStructure >> AcceptCharset: aString [
	self headerAt: HttpHeaderAcceptCharset put: aString]

{ #category : #output }
HttpHeadersStructure >> AcceptEncoding [
	^self headerAt: HttpHeaderAcceptEncoding]

{ #category : #input }
HttpHeadersStructure >> AcceptEncoding: aString [
	self headerAt: HttpHeaderAcceptEncoding put: aString]

{ #category : #output }
HttpHeadersStructure >> AcceptLanguage [
	^self headerAt: HttpHeaderAcceptLanguage]

{ #category : #input }
HttpHeadersStructure >> AcceptLanguage: aString [
	self headerAt: HttpHeaderAcceptLanguage put: aString]

{ #category : #output }
HttpHeadersStructure >> Allow [
	^self headerAt: HttpHeaderAllow]

{ #category : #input }
HttpHeadersStructure >> Allow: aString [
	self headerAt: HttpHeaderAllow put: aString]

{ #category : #output }
HttpHeadersStructure >> Authorization [
	^self headerAt: HttpHeaderAuthorization]

{ #category : #input }
HttpHeadersStructure >> Authorization: aString [
	self headerAt: HttpHeaderAuthorization put: aString]

{ #category : #output }
HttpHeadersStructure >> CacheControl [
	^self headerAt: HttpHeaderCacheControl]

{ #category : #input }
HttpHeadersStructure >> CacheControl: aString [
	self headerAt: HttpHeaderCacheControl put: aString]

{ #category : #output }
HttpHeadersStructure >> Connection [
	^self headerAt: HttpHeaderConnection]

{ #category : #input }
HttpHeadersStructure >> Connection: aString [
	self headerAt: HttpHeaderConnection put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentEncoding [
	^self headerAt: HttpHeaderContentEncoding]

{ #category : #input }
HttpHeadersStructure >> ContentEncoding: aString [
	self headerAt: HttpHeaderContentEncoding put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentLanguage [
	^self headerAt: HttpHeaderContentLanguage]

{ #category : #input }
HttpHeadersStructure >> ContentLanguage: aString [
	self headerAt: HttpHeaderContentLanguage put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentLength [
	^self headerAt: HttpHeaderContentLength]

{ #category : #input }
HttpHeadersStructure >> ContentLength: aString [
	self headerAt: HttpHeaderContentLength put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentLocation [
	^self headerAt: HttpHeaderContentLocation]

{ #category : #input }
HttpHeadersStructure >> ContentLocation: aString [
	self headerAt: HttpHeaderContentLocation put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentMd5 [
	^self headerAt: HttpHeaderContentMd5]

{ #category : #input }
HttpHeadersStructure >> ContentMd5: aString [
	self headerAt: HttpHeaderContentMd5 put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentRange [
	^self headerAt: HttpHeaderContentRange]

{ #category : #input }
HttpHeadersStructure >> ContentRange: aString [
	self headerAt: HttpHeaderContentRange put: aString]

{ #category : #output }
HttpHeadersStructure >> ContentType [
	^self headerAt: HttpHeaderContentType]

{ #category : #input }
HttpHeadersStructure >> ContentType: aString [
	self headerAt: HttpHeaderContentType put: aString]

{ #category : #output }
HttpHeadersStructure >> Cookie [
	^self headerAt: HttpHeaderCookie]

{ #category : #input }
HttpHeadersStructure >> Cookie: aString [
	self headerAt: HttpHeaderCookie put: aString]

{ #category : #output }
HttpHeadersStructure >> Date [
	^self headerAt: HttpHeaderDate]

{ #category : #input }
HttpHeadersStructure >> Date: aString [
	self headerAt: HttpHeaderDate put: aString]

{ #category : #output }
HttpHeadersStructure >> Expect [
	^self headerAt: HttpHeaderExpect]

{ #category : #input }
HttpHeadersStructure >> Expect: aString [
	self headerAt: HttpHeaderExpect put: aString]

{ #category : #output }
HttpHeadersStructure >> Expires [
	^self headerAt: HttpHeaderExpires]

{ #category : #input }
HttpHeadersStructure >> Expires: aString [
	self headerAt: HttpHeaderExpires put: aString]

{ #category : #output }
HttpHeadersStructure >> From [
	^self headerAt: HttpHeaderFrom]

{ #category : #input }
HttpHeadersStructure >> From: aString [
	self headerAt: HttpHeaderFrom put: aString]

{ #category : #private }
HttpHeadersStructure >> headerAt: offset [
	| data |
	data := self
		bytesAtOffset: offset * HTTP_KNOWN_HEADER sizeInBytes
			+ self knownHeadersOffset
		count: HTTP_KNOWN_HEADER sizeInBytes.
	^HTTP_KNOWN_HEADER usingBytes: data]

{ #category : #private }
HttpHeadersStructure >> headerAt: offset put: aString [
	| header |
	header := HTTP_KNOWN_HEADER with: aString.
	self
		bytesAtOffset: offset * HTTP_KNOWN_HEADER sizeInBytes
			+ self knownHeadersOffset
		put: header contents.
	header transferRegistryTo: self]

{ #category : #services }
HttpHeadersStructure >> headerNameAt: index [
	^self class headerNameAt: index]

{ #category : #output }
HttpHeadersStructure >> Host [
	^self headerAt: HttpHeaderHost]

{ #category : #input }
HttpHeadersStructure >> Host: aString [
	self headerAt: HttpHeaderHost put: aString]

{ #category : #output }
HttpHeadersStructure >> IfMatch [
	^self headerAt: HttpHeaderIfMatch]

{ #category : #input }
HttpHeadersStructure >> IfMatch: aString [
	self headerAt: HttpHeaderIfMatch put: aString]

{ #category : #output }
HttpHeadersStructure >> IfModifiedSince [
	^self headerAt: HttpHeaderIfModifiedSince]

{ #category : #input }
HttpHeadersStructure >> IfModifiedSince: aString [
	self headerAt: HttpHeaderIfModifiedSince put: aString]

{ #category : #output }
HttpHeadersStructure >> IfNoneMatch [
	^self headerAt: HttpHeaderIfNoneMatch]

{ #category : #input }
HttpHeadersStructure >> IfNoneMatch: aString [
	self headerAt: HttpHeaderIfNoneMatch put: aString]

{ #category : #output }
HttpHeadersStructure >> IfRange [
	^self headerAt: HttpHeaderIfRange]

{ #category : #input }
HttpHeadersStructure >> IfRange: aString [
	self headerAt: HttpHeaderIfRange put: aString]

{ #category : #output }
HttpHeadersStructure >> IfUnmodifiedSince [
	^self headerAt: HttpHeaderIfUnmodifiedSince]

{ #category : #input }
HttpHeadersStructure >> IfUnmodifiedSince: aString [
	self headerAt: HttpHeaderIfUnmodifiedSince put: aString]

{ #category : #output }
HttpHeadersStructure >> KeepAlive [
	^self headerAt: HttpHeaderKeepAlive]

{ #category : #input }
HttpHeadersStructure >> KeepAlive: aString [
	self headerAt: HttpHeaderKeepAlive put: aString]

{ #category : #output }
HttpHeadersStructure >> KnownHeaders [
	| count data buffer |
	count := self maxHeaders.
	data := self
		bytesAtOffset: self knownHeadersOffset
		count: HTTP_KNOWN_HEADER sizeInBytes * count.
	buffer := BufferArray new
		type: HTTP_KNOWN_HEADER;
		count: count;
		contents: data.
	^buffer asArray]

{ #category : #accessing }
HttpHeadersStructure >> KnownHeaders: aHTTP_KNOWN_HEADER [
	self
		bytesAtOffset: self knownHeadersOffset
		put: aHTTP_KNOWN_HEADER asParameter]

{ #category : #private }
HttpHeadersStructure >> knownHeadersOffset [
	^self subclassResponsibility]

{ #category : #output }
HttpHeadersStructure >> LastModified [
	^self headerAt: HttpHeaderLastModified]

{ #category : #input }
HttpHeadersStructure >> LastModified: aString [
	self headerAt: HttpHeaderLastModified put: aString]

{ #category : #output }
HttpHeadersStructure >> MaxForwards [
	^self headerAt: HttpHeaderMaxForwards]

{ #category : #input }
HttpHeadersStructure >> MaxForwards: aString [
	self headerAt: HttpHeaderMaxForwards put: aString]

{ #category : #private }
HttpHeadersStructure >> maxHeaders [
	self subclassResponsibility]

{ #category : #output }
HttpHeadersStructure >> Pragma [
	^self headerAt: HttpHeaderPragma]

{ #category : #input }
HttpHeadersStructure >> Pragma: aString [
	self headerAt: HttpHeaderPragma put: aString]

{ #category : #printing }
HttpHeadersStructure >> printOn: aStream [
	super printOn: aStream.
	aStream cr.
	self KnownHeaders withIndexDo: [:h :i | | name |
		name := self headerNameAt: i - 1.
		aStream
			nextPutAll: name;
			nextPut: $:;
			space;
			nextPutAll: h rawValue;
			cr]]

{ #category : #output }
HttpHeadersStructure >> ProxyAuthorization [
	^self headerAt: HttpHeaderProxyAuthorization]

{ #category : #input }
HttpHeadersStructure >> ProxyAuthorization: aString [
	self headerAt: HttpHeaderProxyAuthorization put: aString]

{ #category : #output }
HttpHeadersStructure >> Range [
	^self headerAt: HttpHeaderRange]

{ #category : #input }
HttpHeadersStructure >> Range: aString [
	self headerAt: HttpHeaderRange put: aString]

{ #category : #output }
HttpHeadersStructure >> Referer [
	^self headerAt: HttpHeaderReferer]

{ #category : #input }
HttpHeadersStructure >> Referer: aString [
	self headerAt: HttpHeaderReferer put: aString]

{ #category : #output }
HttpHeadersStructure >> Te [
	^self headerAt: HttpHeaderTe]

{ #category : #input }
HttpHeadersStructure >> Te: aString [
	self headerAt: HttpHeaderTe put: aString]

{ #category : #output }
HttpHeadersStructure >> Trailer [
	^self headerAt: HttpHeaderTrailer]

{ #category : #input }
HttpHeadersStructure >> Trailer: aString [
	self headerAt: HttpHeaderTrailer put: aString]

{ #category : #output }
HttpHeadersStructure >> trailers [
	| buffer |
	buffer := BufferArray
		at: self pTrailers
		count: self TrailerCount
		type: HTTP_UNKNOWN_HEADER.
	^buffer asArray]

{ #category : #output }
HttpHeadersStructure >> TransferEncoding [
	^self headerAt: HttpHeaderTransferEncoding]

{ #category : #input }
HttpHeadersStructure >> TransferEncoding: aString [
	self headerAt: HttpHeaderTransferEncoding put: aString]

{ #category : #output }
HttpHeadersStructure >> Translate [
	^self headerAt: HttpHeaderTranslate]

{ #category : #input }
HttpHeadersStructure >> Translate: aString [
	self headerAt: HttpHeaderTranslate put: aString]

{ #category : #output }
HttpHeadersStructure >> unknownHeaders [
	| buffer |
	buffer := BufferArray
		at: self pUnknownHeaders
		count: self UnknownHeaderCount
		type: HTTP_UNKNOWN_HEADER.
	^buffer asArray]

{ #category : #input }
HttpHeadersStructure >> unknownHeaders: aCollection [
	| collection buffer |
	collection := aCollection collect: [:assoc | | header |
		header := HTTP_UNKNOWN_HEADER name: assoc key value: assoc value.
		header transferRegistryTo: self].
	buffer := BufferArray on: collection type: HTTP_UNKNOWN_HEADER.
	buffer := buffer externalCopy.
	self
		pUnknownHeaders: buffer pointedMemory;
		UnknownHeaderCount: aCollection size]

{ #category : #output }
HttpHeadersStructure >> Upgrade [
	^self headerAt: HttpHeaderUpgrade]

{ #category : #input }
HttpHeadersStructure >> Upgrade: aString [
	self headerAt: HttpHeaderUpgrade put: aString]

{ #category : #output }
HttpHeadersStructure >> UserAgent [
	^self headerAt: HttpHeaderUserAgent]

{ #category : #input }
HttpHeadersStructure >> UserAgent: aString [
	self headerAt: HttpHeaderUserAgent put: aString]

{ #category : #output }
HttpHeadersStructure >> Via [
	^self headerAt: HttpHeaderVia]

{ #category : #input }
HttpHeadersStructure >> Via: aString [
	self headerAt: HttpHeaderVia put: aString]

{ #category : #output }
HttpHeadersStructure >> Warning [
	^self headerAt: HttpHeaderWarning]

{ #category : #input }
HttpHeadersStructure >> Warning: aString [
	self headerAt: HttpHeaderWarning put: aString]

