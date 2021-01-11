"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpClientTest,
	#superclass : #TestCase,
	#category : #'HTTP\Tests'
}

{ #category : #private }
HttpClientTest >> baseUri [
	^self selector asString]

{ #category : #private }
HttpClientTest >> handleRequest: anHttpRequest [
	^HttpResponse forRequest: anHttpRequest]

{ #category : #private }
HttpClientTest >> name [
	^self class name , ' - ' , self selector asString]

{ #category : #all }
HttpClientTest >> testBasicRequest [
	| url server |
	url := 'http://localhost:1234/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url
		evaluating: [:request | request response ok; textData: 'Bee says hi!'];
		start.
	[| client |
		client := HttpClient to: url.
		client timeout: 1.
		self assert: (client get: '/') = 'Bee says hi!']
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testCancelSendingData [
	| url server |
	url := 'http://localhost:1234/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url
		evaluating: [:request | request response ok; textData: 'Data received'];
		start.
	[| client data cancelled |
		client := HttpClient to: url.
		client when: #percentSent: evaluate: [:p | (p between: 20 and: 80) not].
		data := ByteArray new: 2 mbytes.
		cancelled := false.
		self
			deny: ([client post: '/' withBinary: data]
				on: HttpRequestCancelled
				do: [:e | cancelled := true]) = 'Data received';
			assert: cancelled]
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testCookie [
	| server |
	server := HttpServer new.
	server
		respondRequestsTo: 'http://localhost:1234/get-cookie' asURL
		evaluating: [:request | request response
			ok;
			setCookie: 'my-cookie' with: '1234'];
		respondRequestsTo: 'http://localhost:1234/test-cookie' asURL
		evaluating: [:request | 
			(request cookieAt: 'my-cookie') = '1234'
				ifTrue: [request response ok]
				ifFalse: [request response error]];
		start.
	[| client response |
		client := HttpClient to: 'http://localhost:1234'.
		response := client GET: '/get-cookie'.
		self
			assert: response isOk;
			assert: (response cookieAt: 'my-cookie') = '1234'.
		response := [client GET: '/test-cookie'] on: HttpClientError do: [].
		self assert: response notNil; assert: response isOk.
		client := HttpClient to: 'http://localhost:1234'.
		client useSocketConnection.
		response := client GET: '/get-cookie'.
		self
			assert: response isOk;
			assert: (response cookieAt: 'my-cookie') = '1234'.
		response := [client GET: '/test-cookie'] on: HttpClientError do: [].
		self assert: response notNil; assert: response isOk]
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testKeepConnection [
	| url server |
	url := 'http://localhost:1234/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url evaluating: [:request | 
			self assert: request headers connection = 'Keep-Alive'.
			request response ok; textData: 'Bee says hi!'];
		start.
	[| client |
		client := HttpClient to: url.
		client useWindowsCredentials.
		self assert: (client get: '/') = 'Bee says hi!']
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testLoggingMessages [
	| url log server |
	url := 'http://localhost:1234/test' asURL.
	log := Directory tempDir \ 'httpclientlog.txt'.
	server := HttpServer new.
	server
		respondRequestsTo: url
		evaluating: [:r | r response ok; textData: 'Hi client!'];
		start.
	[| client logged messages request response |
		client := HttpClient to: url.
		client useTextFormat; logFilename: log; timeout: 2.
		client post: '/' with: 'Hello server!'.
		logged := log asFile contents.
		self assert: logged size > 0.
		messages := JsonParser parse: logged.
		self assert: messages size = 2.
		request := messages first.
		self
			assert: request Class = 'HttpRequest';
			assert: request Verb = 'POST';
			assert: request Url = 'http://localhost:1234/test/';
			assert: request Body = 'Hello server!'.
		response := messages second.
		self
			assert: response Class = 'HttpResponse';
			assert: response Status = '200';
			assert: response Body = 'Hi client!']
		ensure: [
			server stop.
			log removeFile]]

{ #category : #all }
HttpClientTest >> testNoAutomaticRedirect [
	| server |
	server := HttpServer new.
	server
		respondRequestsTo: 'http://localhost:1234/redirect' asURL
		evaluating: [:request | request response
			redirectTo: 'http://localhost:1234/goal'];
		respondRequestsTo: 'http://localhost:1234/goal' asURL
		evaluating: [:request | request response ok; textData: 'Goal!'];
		start.
	[| client response |
		client := HttpClient to: 'http://localhost:1234/redirect'.
		client timeout: 1; redirectAutomatically: false.
		response := client GET: '/'.
		self
			deny: response isOk;
			deny: response data = 'Goal!';
			assert: response location = 'http://localhost:1234/goal']
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testSocketBasedClient [
	| url server |
	url := 'http://localhost:1234/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url
		evaluating: [:request | request response ok; textData: 'Bee says hi!'];
		start.
	[| client |
		client := HttpClient to: url.
		client useSocketConnection.
		self assert: (client get: '/') = 'Bee says hi!']
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testSocketBasedClientToSocketBasedServer [
	| url server |
	url := 'http://localhost:1234/test' asURL.
	server := BeeHttpServer new.
	server
		respondRequestsTo: url
		evaluating: [:request | request response ok; textData: 'Bee says hi!'];
		start.
	[| client |
		client := HttpClient to: url.
		client useSocketConnection.
		self assert: (client get: '/') = 'Bee says hi!']
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testTP52414 [
	| url server stream |
	url := 'http://localhost:9000/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url evaluating: [:request | 
			self assert: request data asString = 'This is testTP52414'.
			request response ok];
		start.
	stream := (Directory scratchDir \ 'TP52414.txt') newFile.
	stream nextPutAll: 'This is testTP52414'; close.
	[| client |
		client := HttpClient to: url.
		client useBinaryFormat.
		self assert: (client POST: url asString with: stream file) isOk]
		ensure: [server stop]]

{ #category : #all }
HttpClientTest >> testTP55279 [
	| url server stream |
	stream := '' writeStream.
	16 kbytes + 1 timesRepeat: [stream nextPutAll: 1 asString].
	stream close.
	url := 'http://localhost:9000/test' asURL.
	server := HttpServer new.
	server
		respondRequestsTo: url evaluating: [:request | 
			self assert: request data asString = stream contents.
			request response ok];
		start.
	[| client |
		client := HttpClient to: url.
		self
			assert: (client
				useBinaryFormat;
				POST: url asString with: stream contents) isOk]
		ensure: [server stop]]

