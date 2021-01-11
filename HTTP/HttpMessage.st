"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpMessage,
	#superclass : #Object,
	#instVars : [
		'id',
		'headers',
		'body'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
HttpMessage class >> fromStream: aStream [
	^self new readFrom: aStream]

{ #category : #'instance creation' }
HttpMessage class >> new [
	^super new initialize]

{ #category : #headers }
HttpMessage >> accept [
	^headers accept]

{ #category : #headers }
HttpMessage >> addHeader: name value: aString [
	headers at: name put: aString]

{ #category : #headers }
HttpMessage >> addHeaders: aDictionary [
	headers addAll: aDictionary]

{ #category : #headers }
HttpMessage >> authorization [
	^headers authorization]

{ #category : #entity }
HttpMessage >> binaryData: data [
	self data: data type: MediaType binary]

{ #category : #accessing }
HttpMessage >> body [
	^body]

{ #category : #accessing }
HttpMessage >> body: aString [
	body := aString]

{ #category : #headers }
HttpMessage >> closeConnection [
	headers closeConnection]

{ #category : #headers }
HttpMessage >> contentCharset [
	| type charset |
	type := self contentType.
	type isNil ifTrue: [^nil].
	charset := type readStream upToAll: 'charset='; upTo: $;.
	^charset notEmpty ifTrue: [charset]]

{ #category : #headers }
HttpMessage >> contentLength [
	headers contentLength ifNotNil: [:length | ^length asInteger].
	^self hasData ifTrue: [body sizeInBytes] ifFalse: [0]]

{ #category : #headers }
HttpMessage >> contentLength: anInteger [
	headers contentLength: anInteger]

{ #category : #headers }
HttpMessage >> contentType [
	^headers contentType]

{ #category : #headers }
HttpMessage >> contentType: aMediaType [
	headers contentType: aMediaType]

{ #category : #headers }
HttpMessage >> cookieAt: aString [
	| cookie |
	cookie := self cookies valueAt: aString asLowercase.
	^cookie value]

{ #category : #entity }
HttpMessage >> data [
	self hasBinaryData ifTrue: [^body].
	self hasUTF8Data ifTrue: [
		^body isExternalMemory
			ifTrue: [String fromMemory: body]
			ifFalse: [String fromUTF8: body]].
	self hasJsonEntity ifTrue: [^body asString].
	^body]

{ #category : #entity }
HttpMessage >> data: data format: aSymbol [
	| type |
	type := self typeFromFormat: aSymbol.
	self ASSERT: type notNil.
	self data: data type: type]

{ #category : #entity }
HttpMessage >> data: data type: aMediaType [
	| type n |
	type := aMediaType supportsCharset
		ifTrue: [aMediaType utf8]
		ifFalse: [aMediaType].
	body := (aMediaType supportsCharset and: [data isString])
		ifTrue: [data utf8]
		ifFalse: [data].
	n := body isExternalMemory
		ifTrue: [body length]
		ifFalse: [body sizeInBytes].
	self contentType: type; contentLength: n]

{ #category : #entity }
HttpMessage >> formEntity [
	| data form parts raw |
	self ASSERT: self hasFormEntity.
	raw := String fromUTF8: body.
	data := PercentEncoder decode: raw.
	form := OrderedDictionary new.
	parts := $& split: data asString.
	parts do: [:part | | input value |
		input := $= split: part.
		value := input size >= 2 ifTrue: [input second].
		form at: input first put: value].
	^form]

{ #category : #entity }
HttpMessage >> formEntity: aDictionary [
	| encoder form |
	encoder := PercentEncoder.
	form := String streamContents: [:strm | 
		aDictionary associations
			do: [:pair | 
				strm
					nextPutAll: (encoder encode: pair key);
					nextPut: $=;
					nextPutAll: (encoder encode: pair value)]
			separatedBy: [strm nextPut: $&]].
	self data: form type: MediaType form]

{ #category : #testing }
HttpMessage >> hasAuthorization [
	^self authorization notNil]

{ #category : #testing }
HttpMessage >> hasBinaryData [
	| type |
	type := self mediaType.
	^type notNil and: [type isBinary]]

{ #category : #testing }
HttpMessage >> hasData [
	^body isEmptyOrNil not]

{ #category : #testing }
HttpMessage >> hasFormEntity [
	| type |
	type := self mediaType.
	^type notNil and: [type isUrlEncodedForm]]

{ #category : #testing }
HttpMessage >> hasHtmlEntity [
	| type |
	type := self mediaType.
	^type notNil and: [type isHtml]]

{ #category : #testing }
HttpMessage >> hasJsonEntity [
	| type |
	type := self mediaType.
	^type notNil and: [type isJson] and: [body notNil]]

{ #category : #testing }
HttpMessage >> hasUTF8Data [
	| type |
	self hasData ifFalse: [^false].
	type := self mediaType.
	type isNil ifTrue: [^false].
	type charset = 'utf-8' ifTrue: [^true].
	type charset notNil ifTrue: [^false].
	^type isUrlEncodedForm or: [type isHtml] or: [type isXml]]

{ #category : #headers }
HttpMessage >> headerAt: aString [
	^headers at: aString]

{ #category : #accessing }
HttpMessage >> headers [
	^headers]

{ #category : #accessing }
HttpMessage >> headers: anHttpHeaders [
	headers := anHttpHeaders isDictionary
		ifTrue: [HttpHeaders withAll: anHttpHeaders]
		ifFalse: [anHttpHeaders]]

{ #category : #headers }
HttpMessage >> headerString [
	^String streamContents: [:strm | headers writeOn: strm]]

{ #category : #entity }
HttpMessage >> htmlEntity [
	| raw parser |
	self ASSERT: self hasHtmlEntity.
	raw := String fromUTF8: body.
	parser := Smalltalk at: #HtmlDocument ifAbsent: [^raw].
	^parser parse: raw]

{ #category : #entity }
HttpMessage >> htmlEntity: html [
	self data: html asString type: MediaType html]

{ #category : #accessing }
HttpMessage >> id [
	^id]

{ #category : #initialization }
HttpMessage >> initialize [
	super initialize.
	headers := HttpHeaders new]

{ #category : #entity }
HttpMessage >> jsonData: aString [
	self data: aString type: MediaType json]

{ #category : #entity }
HttpMessage >> jsonEntity [
	| raw parser |
	self ASSERT: self hasJsonEntity.
	raw := String fromUTF8: body.
	parser := Smalltalk at: #JsonParser ifAbsent: [^raw].
	^parser parse: raw]

{ #category : #entity }
HttpMessage >> jsonEntity: anObject [
	| writer json |
	writer := Smalltalk
		at: #JsonWriter
		ifAbsent: [self error: 'No JSON writer'].
	json := writer write: anObject.
	self data: json type: MediaType json]

{ #category : #headers }
HttpMessage >> location [
	^headers location]

{ #category : #'media types' }
HttpMessage >> mediaType [
	^self contentType ifNotNil: [:h | MediaType fromString: h]]

{ #category : #headers }
HttpMessage >> noCache [
	headers noCache]

{ #category : #printing }
HttpMessage >> printOn: aStream [
	aStream nextPutAll: self asText asString]

{ #category : #reading }
HttpMessage >> readFrom: aStream [
	headers := HttpHeaders fromStream: aStream.
	aStream notEmpty ifTrue: [body := aStream next: self contentLength]]

{ #category : #testing }
HttpMessage >> shouldCloseConnection [
	^headers connection ifNil: [false] ifNotNil: [:c | c asLowercase = 'close']]

{ #category : #data }
HttpMessage >> textData: aString [
	self data: aString type: MediaType text]

{ #category : #'media types' }
HttpMessage >> typeFromFormat: aSymbol [
	(MediaType respondsTo: aSymbol) ifTrue: [^MediaType perform: aSymbol].
	^nil]

{ #category : #entity }
HttpMessage >> utf8Data: data [
	body := data isByteArray ifTrue: [data] ifFalse: [data utf8].
	self contentType: MediaType text utf8; contentLength: body sizeInBytes]

{ #category : #headers }
HttpMessage >> varyAccept [
	headers varyAccept]

{ #category : #accessing }
HttpMessage >> version [
	^'HTTP/1.1']

{ #category : #accessing }
HttpMessage >> webSocketHeaders [
	^headers webSocketHeaders]

{ #category : #writing }
HttpMessage >> writeOn: aStream [
	headers writeOn: aStream.
	aStream crlf.
	body notNil ifTrue: [aStream nextPutAll: body asString]]

{ #category : #headers }
HttpMessage >> wwwAuthenticate: type realm: realm [
	headers wwwAuthenticate: type realm: realm]

