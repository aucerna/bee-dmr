"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #Base64EncodingTest,
	#superclass : #TestCase,
	#category : #'Cryptography\Tests'
}

{ #category : #testing }
Base64EncodingTest >> testDecoding [
	| encoded decoded result |
	encoded := 'T24tbGluZSBUZXN0aW5nIFBhZ2VzIGJ5IGRldi5GWUljZW50ZXIuY29tDQpXZWxjb21lIHRvIGRldi5GWUljZW50ZXIuY29tIG9uLWxpbmUgbGVhcm5pbmcgYW5kIHRlc3RpbmcgcGFnZXMuDQpDbGljayB0aGUgU3RhcnQgYnV0dG9uIHRvIHBsYXkgcmVndWxhciBleHByZXNzaW9uLCBkYXRlIGZvcm1hdHRpbmcsIA0KVVJMIGVuY29kaW5nLCBhbmQgbWFueSBtb3JlIHByb2dyYW1taW5nIHRlY2huaXF1ZXMuLi4='.
	decoded := Crypt32DLL current decodeBase64: encoded.
	result := 'On-line Testing Pages by dev.FYIcenter.com
Welcome to dev.FYIcenter.com on-line learning and testing pages.
Click the Start button to play regular expression, date formatting, 
URL encoding, and many more programming techniques...'.
	self assert: decoded asString = result withCrLf]

{ #category : #testing }
Base64EncodingTest >> testEncoding [
	| decoded encoded result |
	decoded := 'On-line Testing Pages by dev.FYIcenter.com
Welcome to dev.FYIcenter.com on-line learning and testing pages.
Click the Start button to play regular expression, date formatting, 
URL encoding, and many more programming techniques...'.
	encoded := Crypt32DLL current encodeBase64: decoded.
	result := Crypt32DLL current decodeBase64: encoded.
	self assert: decoded = (String fromBytes: result)]

{ #category : #testing }
Base64EncodingTest >> testEncoding1 [
	| encoder array encoded |
	encoder := Crypt32DLL current.
	array := ByteArray with: 1.
	encoded := encoder encodeBase64: array.
	self assert: encoded = 'AQ==']

{ #category : #testing }
Base64EncodingTest >> testEncoding2 [
	| encoder array encoded |
	encoder := Crypt32DLL current.
	array := ByteArray with: 2 with: 1.
	encoded := encoder encodeBase64: array.
	self assert: encoded = 'AgE=']

{ #category : #testing }
Base64EncodingTest >> testEncoding3 [
	| encoder array encoded |
	encoder := Crypt32DLL current.
	array := ByteArray with: 2r01010101 with: 2r00100100 with: 2r00010001.
	encoded := encoder encodeBase64: array.
	self assert: encoded = 'VSQR']

{ #category : #testing }
Base64EncodingTest >> testEncodingB [
	| encoder string encoded |
	encoder := Crypt32DLL current.
	string := 'On-line Testing Pages by dev.FYIcenter.com Welcome to dev.FYIcenter.com on-line learning and testing pages. Click the Start button to play regular expression, date formatting, URL encoding, and many more programming techniques...'.
	encoded := encoder encodeBase64: string asByteArray.
	self
		assert: encoded withoutSeparators
			= 'T24tbGluZSBUZXN0aW5nIFBhZ2VzIGJ5IGRldi5GWUljZW50ZXIuY29tIFdlbGNvbWUgdG8gZGV2
LkZZSWNlbnRlci5jb20gb24tbGluZSBsZWFybmluZyBhbmQgdGVzdGluZyBwYWdlcy4gQ2xpY2sg
dGhlIFN0YXJ0IGJ1dHRvbiB0byBwbGF5IHJlZ3VsYXIgZXhwcmVzc2lvbiwgZGF0ZSBmb3JtYXR0
aW5nLCBVUkwgZW5jb2RpbmcsIGFuZCBtYW55IG1vcmUgcHJvZ3JhbW1pbmcgdGVjaG5pcXVlcy4u
Lg==' withoutSeparators]

