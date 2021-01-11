"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #WebServiceClient,
	#superclass : #Object,
	#instVars : [
		'name',
		'configuration',
		'requester',
		'active'
	],
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
WebServiceClient class >> for: aString configuration: aWebServiceConfiguration [
	^self new name: aString; configuration: aWebServiceConfiguration]

{ #category : #'instance creation' }
WebServiceClient class >> new [
	^super new initialize]

{ #category : #'instance creation' }
WebServiceClient class >> on: anHttpClient [
	^self new requester: anHttpClient]

{ #category : #services }
WebServiceClient >> activate [
	active := true.
	self initializeRequester]

{ #category : #accessing }
WebServiceClient >> baseUri [
	^configuration baseUri]

{ #category : #accessing }
WebServiceClient >> baseUri: aString [
	configuration baseUri: aString.
	requester := nil]

{ #category : #services }
WebServiceClient >> checkService [
	^self checkUsing: configuration]

{ #category : #services }
WebServiceClient >> checkUsing: anHttpClientConfiguration [
	^(self shallowCopy configuration: anHttpClientConfiguration) check]

{ #category : #accessing }
WebServiceClient >> configuration [
	^configuration]

{ #category : #accessing }
WebServiceClient >> configuration: anHttpClientConfiguration [
	configuration := anHttpClientConfiguration.
	self initializeRequester]

{ #category : #services }
WebServiceClient >> deactivate [
	active := false.
	requester := ObjectStub on: [self requester]]

{ #category : #initialization }
WebServiceClient >> deactivatedError [
	^HttpClientError
		signal: 'The HTTP client to ' , configuration url asString
			, ' was deactivated']

{ #category : #accessing }
WebServiceClient >> hostname [
	^configuration hostname]

{ #category : #accessing }
WebServiceClient >> hostname: aString [
	configuration hostname: aString.
	requester := nil]

{ #category : #initialization }
WebServiceClient >> initialize [
	super initialize.
	active := true.
	configuration := HttpClientConfiguration new]

{ #category : #initialization }
WebServiceClient >> initializeRequester [
	requester := HttpClient fromConfiguration: configuration.
	requester useJsonFormat]

{ #category : #testing }
WebServiceClient >> isActive [
	^active]

{ #category : #accessing }
WebServiceClient >> name [
	^name]

{ #category : #accessing }
WebServiceClient >> name: aString [
	name := aString]

{ #category : #accessing }
WebServiceClient >> port [
	^configuration port]

{ #category : #accessing }
WebServiceClient >> port: anInteger [
	configuration port: anInteger.
	requester := nil]

{ #category : #printing }
WebServiceClient >> printOn: aStream [
	aStream nextPutAll: self name; nextPutAll: ' web service']

{ #category : #accessing }
WebServiceClient >> requester [
	active ifFalse: [self deactivatedError].
	requester isNil ifTrue: [self initializeRequester].
	^requester]

{ #category : #accessing }
WebServiceClient >> requester: anHttpClient [
	requester := anHttpClient.
	configuration := anHttpClient configuration]

{ #category : #accessing }
WebServiceClient >> url [
	^configuration url]

{ #category : #configuration }
WebServiceClient >> useCredentials: credentials while: aBlock [
	| current parts temporary |
	current := configuration.
	parts := $: split: credentials.
	temporary := HttpClientConfiguration new
		url: configuration url copy;
		username: parts first;
		password: parts second.
	self configuration: temporary.
	^aBlock ensure: [self configuration: current]]

{ #category : #accessing }
WebServiceClient >> username: aString [
	requester username: aString]

{ #category : #services }
WebServiceClient >> useSingleSignOn: aBoolean [
	configuration useSingleSignOn: aBoolean.
	requester useSingleSignOn: aBoolean]

{ #category : #private }
WebServiceClient >> useToken: anAssociation [
	requester authenticator useToken: anAssociation]

{ #category : #services }
WebServiceClient >> useVaultNamed: aString [
	requester useVaultNamed: aString]

