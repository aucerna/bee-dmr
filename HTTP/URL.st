"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #URL,
	#superclass : #Object,
	#instVars : [
		'scheme',
		'user',
		'password',
		'host',
		'port',
		'segments',
		'query',
		'fragment'
	],
	#category : #HTTP
}

{ #category : #'instance creation' }
URL class >> fromString: aString [
	| url |
	url := URLParser urlFrom: aString.
	^url ifNil: [self relativeFromString: aString]]

{ #category : #'instance creation' }
URL class >> new [
	^super new initialize]

{ #category : #'instance creation' }
URL class >> relativeFromString: aString [
	^URLParser relativeUrlFrom: aString]

{ #category : #services }
URL >> , aString [
	| url segment |
	url := self copy.
	self hasPath
		ifTrue: [
			segment := self isSlash
				ifTrue: [aString]
				ifFalse: [segments last , aString].
			url segmentAt: segments size put: segment]
		ifFalse: [url addSegment: aString].
	^url]

{ #category : #services }
URL >> / anURL [
	anURL isString ifTrue: [^self / anURL asURL].
	self ASSERT: anURL isRelative.
	self DENY: self hasQuery.
	^self copy removeTrailingSlash
		addSegments: anURL segments;
		query: anURL query]

{ #category : #comparing }
URL >> = anURL [
	self class == anURL class ifFalse: [^false].
	scheme = anURL scheme ifFalse: [^false].
	host = anURL host ifFalse: [^false].
	self port = anURL port ifFalse: [^false].
	fragment = anURL fragment ifFalse: [^false].
	(query equalsTo: anURL query) ifFalse: [^false].
	segments = anURL segments ifFalse: [^false].
	^true]

{ #category : #accessing }
URL >> addPath: aString [
	| parts |
	parts := $/ split: aString.
	parts := parts reject: #isEmpty.
	self addSegments: parts]

{ #category : #accessing }
URL >> addSegment: aString [
	segments add: nil.
	self segmentAt: segments size put: aString]

{ #category : #accessing }
URL >> addSegments: aCollection [
	aCollection do: [:segment | self addSegment: segment]]

{ #category : #accessing }
URL >> addTrailingSlash [
	self hasTrailingSlash ifFalse: [self addSegment: '/']]

{ #category : #converting }
URL >> asHttp [
	^self isHttp ifTrue: [self] ifFalse: [self copy beHttp]]

{ #category : #converting }
URL >> asURL [
	^self]

{ #category : #converting }
URL >> asWebSocketURL [
	^self isSecure ifTrue: [self asWss] ifFalse: [self asWs]]

{ #category : #converting }
URL >> asWs [
	^self isWs ifTrue: [self] ifFalse: [self copy beWs]]

{ #category : #converting }
URL >> asWss [
	^self isWss ifTrue: [self] ifFalse: [self copy beWss]]

{ #category : #inquiries }
URL >> baseUri [
	| base |
	self isSlash ifTrue: [^'/'].
	base := self hasPath ifTrue: [self segmentAt: 1] ifFalse: [''].
	^'/' , base]

{ #category : #accessing }
URL >> baseUri: aString [
	self hasPath
		ifTrue: [self segmentAt: 1 put: aString]
		ifFalse: [self addSegment: aString]]

{ #category : #inquiries }
URL >> baseUrl [
	^self root / self baseUri]

{ #category : #accessing }
URL >> beHttp [
	self scheme: 'http']

{ #category : #accessing }
URL >> beHttps [
	self scheme: 'https']

{ #category : #accessing }
URL >> beWs [
	self scheme: 'ws']

{ #category : #accessing }
URL >> beWss [
	self scheme: 'wss']

{ #category : #services }
URL >> browse [
	ShellDLL current openWebPage: self asString]

{ #category : #inquiries }
URL >> credentials [
	^UserCredentials new username: user; password: password]

{ #category : #private }
URL >> decodeString: aString [
	^aString notNil ifTrue: [PercentEncoder decode: aString]]

{ #category : #services }
URL >> defaultPort [
	(self isHttps or: [self isWss]) ifTrue: [^443].
	(self isHttp or: [self isWs]) ifTrue: [^80].
	^nil]

{ #category : #accessing }
URL >> encodedFragment: aString [
	| encoded |
	encoded := self decodeString: aString.
	self fragment: encoded]

{ #category : #accessing }
URL >> encodedPassword: aString [
	| decoded |
	decoded := self decodeString: aString.
	self password: decoded]

{ #category : #accessing }
URL >> encodedPath: aString [
	| decoded |
	decoded := self decodeString: aString.
	self path: decoded]

{ #category : #accessing }
URL >> encodedQueryAt: aString put: anotherString [
	| name value |
	name := self decodeString: aString.
	value := self decodeString: anotherString.
	self queryAt: name put: value]

{ #category : #accessing }
URL >> encodedUser: aString [
	| decoded |
	decoded := self decodeString: aString.
	self user: decoded]

{ #category : #private }
URL >> encodeString: aString [
	^aString notNil ifTrue: [PercentEncoder encode: aString]]

{ #category : #services }
URL >> externalCopy [
	^self asString externalCopy]

{ #category : #inquiries }
URL >> firstSegment [
	self isSlash ifTrue: [^nil].
	^self hasPath ifTrue: [self segmentAt: 1]]

{ #category : #accessing }
URL >> fragment [
	^fragment]

{ #category : #accessing }
URL >> fragment: aString [
	fragment := aString]

{ #category : #testing }
URL >> hasExplicitPort [
	^port notNil]

{ #category : #comparing }
URL >> hash [
	^scheme
		hashWith: host
		with: port
		with: fragment
		with: query
		with: segments]

{ #category : #inquiries }
URL >> hashFragment [
	^self fragment ifNotNil: [:f | '#' , f]]

{ #category : #testing }
URL >> hasPath [
	^segments notEmpty]

{ #category : #testing }
URL >> hasQuery [
	^query notEmpty]

{ #category : #testing }
URL >> hasTrailingSlash [
	^segments notEmpty and: [segments last = '/']]

{ #category : #accessing }
URL >> host [
	^host]

{ #category : #accessing }
URL >> host: aString [
	host := (aString notNil and: [aString beginsWith: '['])
		ifTrue: [aString allButFirst allButLast]
		ifFalse: [aString].
	host notNil ifTrue: [host := host asLowercase]]

{ #category : #initialization }
URL >> initialize [
	super initialize.
	segments := OrderedCollection new.
	query := OrderedCollection new]

{ #category : #testing }
URL >> isAbsolute [
	^scheme notNil and: [host notNil]]

{ #category : #testing }
URL >> isEmpty [
	^host isNil and: [segments isEmpty]]

{ #category : #testing }
URL >> isHttp [
	^scheme = 'http']

{ #category : #testing }
URL >> isHttps [
	^scheme = 'https']

{ #category : #testing }
URL >> isRelative [
	^self isAbsolute not]

{ #category : #testing }
URL >> isSecure [
	^self isHttps or: [self isWss]]

{ #category : #testing }
URL >> isSlash [
	^segments size = 1 and: [segments first = '/']]

{ #category : #testing }
URL >> isWebSocketURL [
	^self isWss or: [self isWs]]

{ #category : #testing }
URL >> isWs [
	^scheme = 'ws']

{ #category : #testing }
URL >> isWss [
	^scheme = 'wss']

{ #category : #accessing }
URL >> password [
	^password]

{ #category : #accessing }
URL >> password: aString [
	password := aString notNil ifTrue: [Password on: aString]]

{ #category : #inquiries }
URL >> path [
	^String streamContents: [:strm | self printPathOn: strm]]

{ #category : #accessing }
URL >> path: aString [
	| path |
	path := $/ split: aString.
	path := path reject: #isEmpty.
	(aString endsWith: '/') ifTrue: [path := path , #('/')].
	self segments: path]

{ #category : #inquiries }
URL >> pathAndQuery [
	^String
		streamContents: [:strm | self printPathOn: strm; printQueryOn: strm]]

{ #category : #accessing }
URL >> port [
	^port ifNil: [self defaultPort]]

{ #category : #accessing }
URL >> port: anInteger [
	port := anInteger]

{ #category : #copying }
URL >> postCopy [
	super postCopy.
	segments := segments copy.
	query := query copy]

{ #category : #printing }
URL >> printAuthorityOn: aStream [
	(user notNil and: [password notNil]) ifTrue: [
		aStream
			nextPutAll: user;
			nextPut: $:;
			nextPutAll: password cleartext;
			nextPut: $@]]

{ #category : #printing }
URL >> printFragmentOn: aStream [
	fragment notNil ifTrue: [aStream nextPut: $#; nextPutAll: fragment]]

{ #category : #printing }
URL >> printHostOn: aStream [
	host notNil ifTrue: [aStream nextPutAll: host]]

{ #category : #printing }
URL >> printOn: aStream [
	self
		printSchemeOn: aStream;
		printAuthorityOn: aStream;
		printHostOn: aStream;
		printPortOn: aStream;
		printPathOn: aStream;
		printQueryOn: aStream;
		printFragmentOn: aStream]

{ #category : #printing }
URL >> printParametersOn: rtf [
	self hasQuery ifFalse: [^self].
	rtf
		cr;
		cr;
		useColor: Color darkGray while: [rtf bold: 'Query parameters'];
		cr.
	self queryOptions
		do: [:option | 
			rtf
				bold: option key;
				nextPutAll: ': ' , option value]
		separatedBy: [rtf cr]]

{ #category : #printing }
URL >> printPathOn: aStream [
	self printSegments: segments on: aStream]

{ #category : #printing }
URL >> printPortOn: aStream [
	(host notNil and: [port notNil])
		ifTrue: [aStream nextPut: $:; nextPutAll: port asString]]

{ #category : #printing }
URL >> printQueryOn: aStream [
	self hasQuery ifFalse: [^self].
	aStream nextPut: $?.
	query isString ifTrue: [^aStream nextPutAll: query].
	self queryOptions
		do: [:option | self printQueryOption: option on: aStream]
		separatedBy: [aStream nextPut: $&]]

{ #category : #printing }
URL >> printQueryOption: option on: aStream [
	| name value |
	name := self encodeString: option key asString.
	value := self encodeString: option value asString.
	aStream
		nextPutAll: name;
		nextPut: $=;
		nextPutAll: value]

{ #category : #printing }
URL >> printSchemeOn: aStream [
	(host notNil and: [scheme notNil])
		ifTrue: [aStream nextPutAll: scheme; nextPutAll: '://']]

{ #category : #printing }
URL >> printSegments: aCollection on: aStream [
	aCollection
		do: [:segment | segment != '/'
			ifTrue: [aStream nextPut: $/; nextPutAll: segment]].
	(aCollection notEmpty and: [aCollection last = '/'])
		ifTrue: [aStream nextPut: $/]]

{ #category : #printing }
URL >> printTextOn: rtf [
	"
	'https://www.google.com/search?source=hp&ei=bJ3IXIj6H9W_0PEPwNS8-Aw&q=URL+syntax&btnK=Buscar+con+Google&oq=URL+syntax&gs_l=psy-ab.3..0j0i22i30l9.3477.12005..12251...6.0..0.270.3929.1j0j16......0....1..gws-wiz.....0..0i131j0i10.8reQ92JYeZw' asURL asText
	"
	rtf
		useColor: Color darkGray while: [self printSchemeOn: rtf];
		useColor: Color violet while: [self printAuthorityOn: rtf];
		useColor: Color darkBlue while: [self printHostOn: rtf];
		useColor: Color darkRed while: [self printPortOn: rtf];
		useColor: Color darkCyan while: [self printPathOn: rtf];
		useColor: Color darkPink while: [self printQueryOn: rtf];
		useColor: Color red while: [self printFragmentOn: rtf];
		useColor: Color darkPink while: [self printParametersOn: rtf]]

{ #category : #printing }
URL >> printWithoutPort [
	^String streamContents: [:strm | 
		self
			printSchemeOn: strm;
			printAuthorityOn: strm;
			printHostOn: strm;
			printPathOn: strm;
			printQueryOn: strm;
			printFragmentOn: strm]]

{ #category : #accessing }
URL >> protocol [
	^scheme]

{ #category : #accessing }
URL >> protocol: aString [
	self scheme: aString]

{ #category : #private }
URL >> query [
	^query]

{ #category : #accessing }
URL >> query: anOrderedCollection [
	anOrderedCollection isNil ifTrue: [^self].
	query := anOrderedCollection]

{ #category : #inquiries }
URL >> queryAt: aString [
	| option |
	option := query detect: [:o | o key = aString] ifNone: nil.
	^option notNil ifTrue: [option value]]

{ #category : #accessing }
URL >> queryAt: name put: value [
	query add: name trimBlanks -> value trimBlanks]

{ #category : #accessing }
URL >> queryOptions [
	^query]

{ #category : #inquiries }
URL >> queryString [
	query isString ifTrue: [^query].
	^String streamContents: [:strm | self printQueryOn: strm]]

{ #category : #inquiries }
URL >> relativeUri [
	segments size < 2 ifTrue: [^'/'].
	^String
		streamContents: [:strm | self printSegments: segments allButFirst on: strm]]

{ #category : #accessing }
URL >> removeSegment: aString [
	segments remove: aString ifAbsent: nil]

{ #category : #accessing }
URL >> removeSubpath: aString [
	| subpath index |
	subpath := $/ split: aString.
	subpath := subpath reject: #isEmpty.
	index := segments indexOfSubcollection: subpath.
	index = 0 ifTrue: [^self].
	segments := (segments copyTo: index - 1)
		, (segments copyFrom: index + subpath size)]

{ #category : #accessing }
URL >> removeTrailingSlash [
	self hasTrailingSlash ifTrue: [segments removeLast]]

{ #category : #accessing }
URL >> replaceQueryAt: name with: value [
	| option |
	option := query detect: [:o | o key = name] ifNone: nil.
	^option notNil ifTrue: [option value: value]]

{ #category : #inquiries }
URL >> root [
	^self class new
		scheme: scheme;
		host: host;
		port: port]

{ #category : #accessing }
URL >> scheme [
	^scheme]

{ #category : #accessing }
URL >> scheme: aString [
	scheme := aString notNil ifTrue: [aString asLowercase]]

{ #category : #inquiries }
URL >> segmentAt: anInteger [
	^segments at: anInteger]

{ #category : #accessing }
URL >> segmentAt: anInteger put: aString [
	| segment |
	segment := (aString first = $/ andNot: [aString = '/'])
		ifTrue: [aString allButFirst]
		ifFalse: [aString].
	segments at: anInteger put: segment]

{ #category : #accessing }
URL >> segments [
	^segments]

{ #category : #accessing }
URL >> segments: aCollection [
	segments := aCollection asOrderedCollection]

{ #category : #accessing }
URL >> user [
	^user]

{ #category : #accessing }
URL >> user: aString [
	user := aString]

