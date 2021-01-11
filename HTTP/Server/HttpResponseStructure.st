"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpResponseStructure,
	#superclass : #HttpApiStructure,
	#category : #'HTTP\Server'
}

{ #category : #accessing }
HttpResponseStructure >> Headers [
	^self subclassResponsibility]

{ #category : #accessing }
HttpResponseStructure >> headers [
	| headers struct |
	headers := Dictionary new.
	struct := self Headers.
	struct KnownHeaders withIndexDo: [:h :i | | name |
		h hasData ifTrue: [
			name := struct headerNameAt: i - 1.
			headers at: name put: h rawValue]].
	struct unknownHeaders do: [:h | headers at: h name put: h rawValue].
	^headers]

{ #category : #accessing }
HttpResponseStructure >> Headers: anHTTP_RESPONSE_HEADERS [
	self subclassResponsibility]

{ #category : #accessing }
HttpResponseStructure >> pReason [
	^self subclassResponsibility]

{ #category : #accessing }
HttpResponseStructure >> pReason: anExternalMemory [
	self subclassResponsibility]

{ #category : #output }
HttpResponseStructure >> reason [
	^String fromMemory: self pReason length: self ReasonLength]

{ #category : #input }
HttpResponseStructure >> reason: aString [
	| utf8 |
	utf8 := aString notNil ifTrue: [aString utf8 externalCopy].
	self pReason: utf8; ReasonLength: aString sizeInBytes]

{ #category : #accessing }
HttpResponseStructure >> ReasonLength [
	^self subclassResponsibility]

{ #category : #accessing }
HttpResponseStructure >> ReasonLength: anInteger [
	self subclassResponsibility]

{ #category : #accessing }
HttpResponseStructure >> unknownHeaders: aCollection [
	| headers |
	headers := self Headers unknownHeaders: aCollection.
	self Headers: headers]

{ #category : #accessing }
HttpResponseStructure >> updateHeadersFrom: anHttpResponse [
	| headers |
	headers := self Headers updateFrom: anHttpResponse headers.
	self Headers: headers]

{ #category : #accessing }
HttpResponseStructure >> Version: anHTTP_VERSION [
	self subclassResponsibility]

{ #category : #input }
HttpResponseStructure >> version1 [
	| version |
	version := HTTP_VERSION major: 1 minor: 1.
	self Version: version]

