"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpMessageTest,
	#superclass : #TestCase,
	#category : #'HTTP\Tests'
}

{ #category : #all }
HttpMessageTest >> testCookieWithoutValue [
	| message cookie |
	message := HttpResponse new.
	message headers setCookie: 'name; domain=world'.
	cookie := message cookie.
	self
		assert: cookie name = 'name';
		assert: cookie domain = 'world']

{ #category : #all }
HttpMessageTest >> testFormEntity [
	| message form entity |
	message := HttpRequest new.
	form := OrderedDictionary new.
	form
		at: 'input1' put: '123';
		at: 'input2' put: 'abc'.
	message formEntity: form.
	self
		assert: message mediaType = MediaType form utf8;
		assert: message body = 'input1=123&input2=abc' utf8.
	entity := message formEntity.
	self assert: entity = form]

{ #category : #all }
HttpMessageTest >> testHtmlEntity [
	| message document entity |
	message := HttpRequest new.
	document := HtmlDocument new.
	message htmlEntity: document.
	self
		assert: message mediaType = MediaType html utf8;
		assert: message body = document asString utf8.
	entity := message htmlEntity.
	self assert: (entity isKindOf: HtmlDocument)]

{ #category : #all }
HttpMessageTest >> testJsonEntity [
	| message json entity |
	message := HttpRequest new.
	json := JsonObject new Name: 'John'; Lastname: 'Dow'.
	message jsonEntity: json.
	self
		assert: message mediaType = MediaType json utf8;
		assert: message body = json asString utf8.
	entity := message jsonEntity.
	self
		assert: (entity isKindOf: JsonObject);
		assert: entity Name = 'John';
		assert: entity Lastname = 'Dow']

{ #category : #all }
HttpMessageTest >> testTextEntity [
	| message |
	message := HttpRequest new.
	message textData: 'Plain text'.
	self
		assert: message mediaType = MediaType text utf8;
		assert: message body = 'Plain text' utf8]

