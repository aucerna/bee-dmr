"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #UrlGroup,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'urls',
		'session',
		'queue',
		'logging'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
UrlGroup class >> new [
	^super new initialize]

{ #category : #'instance creation' }
UrlGroup class >> on: anHttpServerSession [
	^self new session: anHttpServerSession]

{ #category : #'adding / removing' }
UrlGroup >> addUrl: anURL [
	urls add: anURL.
	id isNil ifTrue: [^self].
	self registerUrl: anURL]

{ #category : #properties }
UrlGroup >> authentication [
	^self
		queryProperty: HttpServerAuthenticationProperty
		info: HTTP_SERVER_AUTHENTICATION_INFO new]

{ #category : #actions }
UrlGroup >> bind [
	| info |
	info := HTTP_BINDING_INFO new
		RequestQueueHandle: queue asParameter;
		Flags: HTTP_PROPERTY_FLAGS present.
	self setProperty: HttpServerBindingProperty info: info]

{ #category : #properties }
UrlGroup >> clearAuthentication [
	| info |
	info := HTTP_SERVER_AUTHENTICATION_INFO new
		Flags: HTTP_PROPERTY_FLAGS absent.
	self setProperty: HttpServerAuthenticationProperty info: info]

{ #category : #actions }
UrlGroup >> close [
	| identifier return |
	id isNil ifTrue: [^self].
	identifier := id.
	id := nil.
	return := HttpApiDLL current closeUrlGroup: identifier.
	return = 0 ifFalse: [self winError: return].
	urls removeAll]

{ #category : #actions }
UrlGroup >> create [
	| identifier return |
	identifier := LARGE_INTEGER external.
	return := HttpApiDLL current
		createUrlGroup: session id
		pUrlGroupId: identifier asParameter.
	return = 0 ifFalse: [self winError: return].
	id := identifier makeLocal.
	urls notEmpty ifTrue: [urls do: [:url | self registerUrl: url]]]

{ #category : #initialization }
UrlGroup >> initialize [
	super initialize.
	urls := OrderedCollection new.
	logging := W3CLogging new]

{ #category : #logging }
UrlGroup >> logging [
	^logging]

{ #category : #accessing }
UrlGroup >> name [
	^name]

{ #category : #accessing }
UrlGroup >> name: aString [
	name := aString]

{ #category : #printing }
UrlGroup >> printOn: aStream [
	aStream
		nextPutAll: 'Url Group: ';
		nextPutAll: (name ifNil: ['Unnamed']).
	urls isEmpty ifTrue: [^self].
	aStream cr.
	urls
		do: [:url | aStream nextPutAll: url asString]
		separatedBy: [aStream cr]]

{ #category : #properties }
UrlGroup >> queryProperty: anInteger info: aWindowsStructure [
	| info length return |
	info := aWindowsStructure externalCopy.
	length := ExternalInt32 external.
	return := HttpApiDLL current
		queryUrlGroupProperty: id
		Property: anInteger
		pPropertyInformation: info asParameter
		PropertyInformationLength: 0
		pReturnLength: length asParameter.
	return = ERROR_MORE_DATA ifTrue: [
		return := HttpApiDLL current
			queryUrlGroupProperty: id
			Property: anInteger
			pPropertyInformation: info asParameter
			PropertyInformationLength: length asUnsignedInteger
			pReturnLength: length asParameter].
	return = 0 ifFalse: [self winError: return].
	length free.
	^info makeLocal]

{ #category : #accessing }
UrlGroup >> queue [
	^queue]

{ #category : #accessing }
UrlGroup >> queue: anHttpRequestQueue [
	queue := anHttpRequestQueue]

{ #category : #private }
UrlGroup >> registerUrl: anURL [
	| memory return |
	memory := anURL asString externalCopy.
	return := HttpApiDLL current
		addUrlToUrlGroup: id
		pFullyQualifiedUrl: memory asParameter
		UrlContext: 0.
	return = 0 ifFalse: [self winError: return].
	memory free]

{ #category : #'adding / removing' }
UrlGroup >> removeUrl: anURL [
	urls remove: anURL ifAbsent: [^self].
	id isNil ifTrue: [^self].
	self unregisterUrl: anURL]

{ #category : #accessing }
UrlGroup >> session [
	^session]

{ #category : #accessing }
UrlGroup >> session: anHttpServerSession [
	session := anHttpServerSession]

{ #category : #properties }
UrlGroup >> setProperty: anInteger info: aWindowsStructure [
	HttpApiDLL current
		HttpSetUrlGroupProperty: id
		Property: anInteger
		PropertyInformation: aWindowsStructure]

{ #category : #logging }
UrlGroup >> setupLogging [
	| info |
	(logging isEnabled and: [logging needsSetup]) ifFalse: [^self].
	info := HTTP_LOGGING_INFO fromLogging: logging.
	self setProperty: HttpServerLoggingProperty info: info]

{ #category : #private }
UrlGroup >> unregisterUrl: anURL [
	| memory return |
	memory := anURL asString externalCopy.
	return := HttpApiDLL current
		removeUrlFromUrlGroup: id
		pFullyQualifiedUrl: memory asParameter
		Flags: 0.
	return = 0 ifFalse: [self winError: return].
	memory free]

{ #category : #properties }
UrlGroup >> useBasicAuthentication: realm [
	| auth info |
	auth := HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS new realm: realm.
	info := HTTP_SERVER_AUTHENTICATION_INFO new
		Flags: HTTP_PROPERTY_FLAGS present;
		AuthSchemes: HTTP_AUTH_ENABLE_BASIC;
		ReceiveMutualAuth: false;
		ReceiveContextHandle: true;
		DisableNTLMCredentialCaching: true;
		BasicParams: auth.
	self setProperty: HttpServerAuthenticationProperty info: info]

{ #category : #logging }
UrlGroup >> useCustomLogging [
	logging := logging asCustomLogging.
	logging enable]

{ #category : #properties }
UrlGroup >> useDigestAuthentication: realm [
	| auth info |
	auth := HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS new
		domain: realm;
		realm: realm.
	info := HTTP_SERVER_AUTHENTICATION_INFO new
		Flags: HTTP_PROPERTY_FLAGS present;
		AuthSchemes: HTTP_AUTH_ENABLE_DIGEST;
		ReceiveMutualAuth: false;
		ReceiveContextHandle: true;
		DisableNTLMCredentialCaching: true;
		DigestParams: auth.
	self setProperty: HttpServerAuthenticationProperty info: info]

{ #category : #logging }
UrlGroup >> useIISLogging [
	logging := logging asIISLogging.
	logging enable]

{ #category : #logging }
UrlGroup >> useNCSALogging [
	logging := logging asNCSALogging.
	logging enable]

{ #category : #properties }
UrlGroup >> useNegociateAuthentication [
	| info |
	info := HTTP_SERVER_AUTHENTICATION_INFO new
		Flags: HTTP_PROPERTY_FLAGS present;
		AuthSchemes: HTTP_AUTH_ENABLE_NEGOTIATE.
	self setProperty: HttpServerAuthenticationProperty info: info]

{ #category : #logging }
UrlGroup >> useRawLogging [
	logging := logging useRawLogging.
	logging enable]

{ #category : #logging }
UrlGroup >> useW3CLogging [
	logging := logging asW3CLogging.
	logging enable]

