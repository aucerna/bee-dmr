"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #'OpenAPI.Header',
	#superclass : #'OpenAPI.Parameter',
	#category : #OpenAPI
}

{ #category : #accessing }
OpenAPI.Header >> in [
	^'header']

{ #category : #accessing }
OpenAPI.Header >> in: aString [
	self shouldNotImplement]

{ #category : #accessing }
OpenAPI.Header >> name: aString [
	self shouldNotImplement]

