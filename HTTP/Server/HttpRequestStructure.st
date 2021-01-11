"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpRequestStructure,
	#superclass : #HttpApiStructure,
	#category : #'HTTP\Server'
}

{ #category : #accessing }
HttpRequestStructure >> authenticationInfo [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> authorizationStatus [
	^self authenticationInfo
		ifNotNil: [:struct | struct info ifNotNil: [:auth | auth AuthStatus]]]

{ #category : #accessing }
HttpRequestStructure >> CookedUrl [
	^self subclassResponsibility]

{ #category : #metaprogramming }
HttpRequestStructure >> doesNotUnderstand: aMessage [
	| selector |
	selector := aMessage selector.
	^(selector arity <= 1 and: [HTTP_REQUEST_HEADERS canUnderstand: selector])
		ifTrue: [aMessage performOn: self Headers]
		ifFalse: [super doesNotUnderstand: aMessage]]

{ #category : #accessing }
HttpRequestStructure >> EntityChunkCount [
	^self subclassResponsibility]

{ #category : #output }
HttpRequestStructure >> entityChunks [
	| buffer memory |
	memory := self pEntityChunks.
	^memory isValid ifTrue: [
		buffer := BufferArray
			at: memory
			count: self EntityChunkCount
			type: HTTP_DATA_CHUNK.
		buffer localCopy asArray]]

{ #category : #accessing }
HttpRequestStructure >> Flags [
	^self subclassResponsibility]

{ #category : #testing }
HttpRequestStructure >> hasMoreData [
	^self Flags isOnBit: HTTP_REQUEST_FLAG_MORE_ENTITY_BODY_EXISTS]

{ #category : #accessing }
HttpRequestStructure >> Headers [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> headers [
	| headers struct |
	headers := Dictionary new.
	struct := self Headers.
	struct KnownHeaders withIndexDo: [:h :i | | name |
		h hasData ifTrue: [
			name := struct headerNameAt: i.
			headers at: name put: h rawValue]].
	struct unknownHeaders do: [:h | headers at: h name put: h rawValue].
	^headers]

{ #category : #output }
HttpRequestStructure >> id [
	^self RequestId]

{ #category : #testing }
HttpRequestStructure >> isComplete [
	^self CookedUrl uri asString notEmpty]

{ #category : #accessing }
HttpRequestStructure >> pEntityChunks [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> pRawUrl [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> pRawUrl: anInteger [
	self subclassResponsibility]

{ #category : #printing }
HttpRequestStructure >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: 'Id:';
		space;
		nextPutAll: self RequestId asString]

{ #category : #accessing }
HttpRequestStructure >> pSslInfo [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> pUnknownVerb [
	^self subclassResponsibility]

{ #category : #output }
HttpRequestStructure >> rawUrl [
	| memory |
	memory := self pRawUrl.
	^memory isValid
		ifTrue: [String fromMemory: memory length: self RawUrlLength]]

{ #category : #input }
HttpRequestStructure >> rawUrl: aString [
	| memory |
	memory := aString asByteArray externalCopy.
	self pRawUrl: memory; RawUrlLength: memory length]

{ #category : #accessing }
HttpRequestStructure >> RawUrlLength [
	^self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> RawUrlLength: anInteger [
	self subclassResponsibility]

{ #category : #accessing }
HttpRequestStructure >> RequestId [
	^self subclassResponsibility]

{ #category : #output }
HttpRequestStructure >> sslInfo [
	| memory |
	memory := self pSslInfo.
	^memory isValid ifTrue: [HTTP_SSL_INFO fromMemory: memory]]

{ #category : #output }
HttpRequestStructure >> unknownVerb [
	| memory |
	memory := self pUnknownVerb.
	^memory isValid
		ifTrue: [String fromMemory: memory length: self UnknownVerbLength]]

{ #category : #accessing }
HttpRequestStructure >> UnknownVerbLength [
	^self subclassResponsibility]

{ #category : #output }
HttpRequestStructure >> verbName [
	^#('Unparsed'
		'Unknown'
		'Invalid'
		'OPTIONS'
		'GET'
		'HEAD'
		'POST'
		'PUT'
		'DELETE'
		'TRACE'
		'CONNECT'
		'TRACK'
		'MOVE'
		'COPY'
		'PROPFIND'
		'PROPPATCH'
		'MKCOL'
		'LOCK'
		'UNLOCK'
		'SEARCH') at: self Verb + 1]

