"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #HttpClientError,
	#superclass : #Error,
	#category : #'HTTP\Client'
}

{ #category : #'instance creation' }
HttpClientError class >> signal: aString status: anInteger format: aSymbol [
	^self new signal: aString status: anInteger format: aSymbol]

{ #category : #actions }
HttpClientError >> defaultAction [
	description := self description asString.
	super defaultAction]

{ #category : #testing }
HttpClientError >> hasData [
	^false]

{ #category : #testing }
HttpClientError >> isDenied [
	^false]

{ #category : #testing }
HttpClientError >> isForbidden [
	^false]

{ #category : #testing }
HttpClientError >> isNotFound [
	^false]

{ #category : #testing }
HttpClientError >> isResponseError [
	^false]

{ #category : #testing }
HttpClientError >> isUnauthorized [
	^false]

{ #category : #printing }
HttpClientError >> printTextOn: rtf [
	rtf append: self description]

{ #category : #accessing }
HttpClientError >> signalContext [
	^signalContext]

{ #category : #accessing }
HttpClientError >> signalContext: context [
	signalContext := context]

