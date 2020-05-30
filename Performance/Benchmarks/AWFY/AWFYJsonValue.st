"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #AWFYJsonValue,
	#superclass : #Object,
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
AWFYJsonValue >> asArray [

    self error: 'Unsupported operation, not an array: ', self asString
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> asObject [

    self error: 'Unsupported operation, not an object: ', self asString
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isArray [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isBoolean [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isFalse [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isNull [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isNumber [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isObject [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isString [
 ^ false 
]

{ #category : #'as yet unclassified' }
AWFYJsonValue >> isTrue [
 ^ false 
]

