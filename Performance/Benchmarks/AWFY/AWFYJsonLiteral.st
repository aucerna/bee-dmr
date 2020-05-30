"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #AWFYJsonLiteral,
	#superclass : #AWFYJsonValue,
	#instVars : [
		'value',
		'isNull',
		'isTrue',
		'isFalse'
	],
	#classVars : [
		'FALSE',
		'NULL',
		'TRUE'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
AWFYJsonLiteral class >> FALSE [
 ^ FALSE 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral class >> initialize [

    NULL  := self new initializeWith: 'null'.
    TRUE  := self new initializeWith: 'true'.
    FALSE := self new initializeWith: 'false'.
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral class >> NULL [
 ^ NULL 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral class >> TRUE [
 ^ TRUE 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> asString [
 ^ value 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> initializeWith: val [

    value   := val.
    isNull  := 'null'  = val.
    isTrue  := 'true'  = val.
    isFalse := 'false' = val.
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> isBoolean [
 ^ isTrue || isFalse 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> isFalse [
 ^ isFalse 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> isNull [
 ^ isNull 
]

{ #category : #'as yet unclassified' }
AWFYJsonLiteral >> isTrue [
 ^ isTrue 
]

