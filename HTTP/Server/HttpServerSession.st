"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpServerSession,
	#superclass : #Object,
	#instVars : [
		'id',
		'logging'
	],
	#category : #'HTTP\Server'
}

{ #category : #'instance creation' }
HttpServerSession class >> new [
	^super new initialize]

{ #category : #properties }
HttpServerSession >> authentication [
	^self
		queryProperty: HttpServerAuthenticationProperty
		info: HTTP_SERVER_AUTHENTICATION_INFO new]

{ #category : #properties }
HttpServerSession >> authentication: anHTTP_SERVER_AUTHENTICATION_INFO [
	self
		setProperty: HttpServerAuthenticationProperty
		info: anHTTP_SERVER_AUTHENTICATION_INFO]

{ #category : #actions }
HttpServerSession >> close [
	| identifier return |
	identifier := id.
	id := nil.
	return := HttpApiDLL current closeServerSession: identifier.
	return = 0 ifFalse: [self winError: return]]

{ #category : #actions }
HttpServerSession >> create [
	| version return |
	version := HTTPAPI_VERSION major: 2 minor: 0.
	id := LARGE_INTEGER external.
	return := HttpApiDLL current
		HttpCreateServerSession: version asParameter
		pServerSessionId: id asParameter
		Reserved: 0.
	return = 0 ifFalse: [self winError: return].
	id := id makeLocal]

{ #category : #actions }
HttpServerSession >> enable: aBoolean [
	| info |
	info := HTTP_STATE_INFO new active: aBoolean.
	self state: info]

{ #category : #accessing }
HttpServerSession >> id [
	^id]

{ #category : #initialization }
HttpServerSession >> initialize [
	super initialize.
	logging := W3CLogging new]

{ #category : #testing }
HttpServerSession >> isEnabled [
	^self state isEnabled]

{ #category : #logging }
HttpServerSession >> logging [
	^logging]

{ #category : #printing }
HttpServerSession >> printOn: aStream [
	| identifier |
	identifier := id notNil
		ifTrue: [id asUnsignedInteger hex]
		ifFalse: ['invalid'].
	aStream nextPutAll: 'Http Session: '; nextPutAll: identifier]

{ #category : #properties }
HttpServerSession >> qosBandwidth [
	| info |
	info := HTTP_QOS_SETTING_INFO forBandwidth.
	self queryProperty: info QosType info: info.
	^info qosSetting]

{ #category : #properties }
HttpServerSession >> qosBandwidth: anInteger [
	| info |
	info := HTTP_QOS_SETTING_INFO forBandwidth: anInteger.
	self setProperty: info QosType info: info]

{ #category : #properties }
HttpServerSession >> qosConnectionLimit [
	| info |
	info := HTTP_QOS_SETTING_INFO forConnectionLimit.
	self queryProperty: info QosType info: info.
	^info qosSetting]

{ #category : #properties }
HttpServerSession >> qosConnectionLimit: anInteger [
	| info |
	info := HTTP_QOS_SETTING_INFO forConnectionLimit: anInteger.
	self setProperty: info QosType info: info]

{ #category : #properties }
HttpServerSession >> qosFlowRate [
	| info |
	info := HTTP_QOS_SETTING_INFO forFlowRate.
	self queryProperty: info QosType info: info.
	^info qosSetting]

{ #category : #properties }
HttpServerSession >> qosFlowRateBurstSize [
	^self qosFlowRate BurstSize]

{ #category : #properties }
HttpServerSession >> qosFlowRateBurstSize: anInteger [
	| info |
	info := HTTP_QOS_SETTING_INFO forFlowRateBurstSize: anInteger.
	self setProperty: info QosType info: info]

{ #category : #properties }
HttpServerSession >> qosFlowRateMaxBandwidth [
	^self qosFlowRate MaxBandwidth]

{ #category : #properties }
HttpServerSession >> qosFlowRateMaxBandwidth: anInteger [
	| info |
	info := HTTP_QOS_SETTING_INFO forFlowRateMaxBandwidth: anInteger.
	self setProperty: info QosType info: info]

{ #category : #properties }
HttpServerSession >> qosFlowRateMaxPeakBandwidth [
	^self qosFlowRate MaxPeakBandwidth]

{ #category : #properties }
HttpServerSession >> qosFlowRateMaxPeakBandwidth: anInteger [
	| info |
	info := HTTP_QOS_SETTING_INFO forFlowRateMaxPeakBandwidth: anInteger.
	self setProperty: info QosType info: info]

{ #category : #properties }
HttpServerSession >> queryProperty: anInteger info: aWindowsStructure [
	| bytes |
	bytes := HttpApiDLL current
		HttpQueryServerSessionProperty: id
		Property: anInteger.
	^aWindowsStructure fillFrom: bytes]

{ #category : #properties }
HttpServerSession >> setProperty: anInteger info: aWindowsStructure [
	HttpApiDLL current
		HttpSetServerSessionProperty: id
		Property: anInteger
		PropertyInformation: aWindowsStructure]

{ #category : #logging }
HttpServerSession >> setupLogging [
	| info |
	(logging isEnabled and: [logging needsSetup]) ifFalse: [^self].
	info := HTTP_LOGGING_INFO fromLogging: logging.
	self setProperty: HttpServerLoggingProperty info: info]

{ #category : #properties }
HttpServerSession >> state [
	^self queryProperty: HttpServerStateProperty info: HTTP_STATE_INFO new]

{ #category : #properties }
HttpServerSession >> state: anHTTP_STATE_INFO [
	self setProperty: HttpServerStateProperty info: anHTTP_STATE_INFO]

{ #category : #properties }
HttpServerSession >> timeouts [
	^self
		queryProperty: HttpServerTimeoutsProperty
		info: HTTP_TIMEOUT_LIMIT_INFO new]

{ #category : #properties }
HttpServerSession >> timeouts: anHTTP_TIMEOUT_LIMIT_INFO [
	self
		setProperty: HttpServerTimeoutsProperty
		info: anHTTP_TIMEOUT_LIMIT_INFO]

{ #category : #logging }
HttpServerSession >> useCustomLogging [
	logging := logging asCustomLogging.
	logging enable]

{ #category : #logging }
HttpServerSession >> useIISLogging [
	logging := logging asIISLogging.
	logging enable]

{ #category : #logging }
HttpServerSession >> useNCSALogging [
	logging := logging asNCSALogging.
	logging enable]

{ #category : #logging }
HttpServerSession >> useRawLogging [
	logging := logging useRawLogging.
	logging enable]

{ #category : #logging }
HttpServerSession >> useW3CLogging [
	logging := logging asW3CLogging.
	logging enable]

