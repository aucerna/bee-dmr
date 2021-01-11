"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpResponseError,
	#superclass : #HttpClientError,
	#instVars : [
		'response'
	],
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
HttpResponseError class >> signal: reason data: body [
	| response |
	response := HttpResponse new body: body; reason: reason.
	^self signalForResponse: response]

{ #category : #'instance creation' }
HttpResponseError class >> signalForResponse: anHttpResponse [
	^self new response: anHttpResponse; signal]

{ #category : #'instance creation' }
HttpResponseError class >> signalNotFound: body [
	| response |
	response := HttpResponse new notFound; body: body.
	^self signalForResponse: response]

{ #category : #accessing }
HttpResponseError >> data [
	^response hasJsonEntity
		ifTrue: [response jsonEntity]
		ifFalse: [response data]]

{ #category : #testing }
HttpResponseError >> hasData [
	^response hasData]

{ #category : #testing }
HttpResponseError >> hasJsonEntity [
	^response hasJsonEntity]

{ #category : #testing }
HttpResponseError >> isBadRequest [
	^response isBadRequest]

{ #category : #testing }
HttpResponseError >> isConflict [
	^response isConflict]

{ #category : #testing }
HttpResponseError >> isDenied [
	^response isDenied]

{ #category : #testing }
HttpResponseError >> isForbidden [
	^response isForbidden]

{ #category : #testing }
HttpResponseError >> isNotFound [
	^response isNotFound]

{ #category : #testing }
HttpResponseError >> isResponseError [
	^true]

{ #category : #testing }
HttpResponseError >> isResumable [
	^self isNotFound]

{ #category : #testing }
HttpResponseError >> isUnauthorized [
	^response isUnauthorized]

{ #category : #printing }
HttpResponseError >> printTextOn: rtf [
	| data |
	rtf
		append: self status asString;
		nextPut: Character emdash;
		append: self description.
	signalContext notNil
		ifTrue: [rtf
			crtab;
			bold: 'Error context: ';
			append: signalContext asString].
	self hasData ifFalse: [^self].
	data := self data.
	data isDictionary
		ifTrue: [
			data keysAndValuesDo: [:k :v | 
				v isString ifTrue: [
					rtf
						crtab;
						bold: k , ': ';
						italic: v]]]
		ifFalse: [rtf cr; italic: self data asString trimBlanks doubleQuoted]]

{ #category : #accessing }
HttpResponseError >> response [
	^response]

{ #category : #accessing }
HttpResponseError >> response: anHttpResponse [
	response := anHttpResponse.
	description := anHttpResponse reason]

{ #category : #accessing }
HttpResponseError >> status [
	^response status]

