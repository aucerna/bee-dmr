"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #MediaTypeParserTest,
	#superclass : #TestCase,
	#category : #'HTTP\Tests'
}

{ #category : #private }
MediaTypeParserTest >> testBasicType [
	| type |
	type := MediaTypeParser parse: 'text/plain'.
	self
		assert: type notNil;
		assert: type type = 'text';
		assert: type subtype = 'plain']

{ #category : #private }
MediaTypeParserTest >> testParameter [
	| type |
	type := MediaTypeParser parse: 'application/json; charset=utf-8'.
	self
		assert: type notNil;
		assert: type type = 'application';
		assert: type subtype = 'json';
		assert: (type parametersAt: 'charset') = 'utf-8']

{ #category : #private }
MediaTypeParserTest >> testSuffix [
	| type |
	type := MediaTypeParser parse: 'application/ld+json'.
	self
		assert: type notNil;
		assert: type type = 'application';
		assert: type subtype = 'ld';
		assert: type suffix = 'json']

{ #category : #private }
MediaTypeParserTest >> testTree [
	| type |
	type := MediaTypeParser parse: 'application/vnd.ms-excel'.
	self
		assert: type notNil;
		assert: type type = 'application';
		assert: type tree = 'vnd';
		assert: type subtype = 'ms-excel']

