"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #ParseException,
	#superclass : #Object,
	#instVars : [
		'offset',
		'line',
		'column',
		'msg'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
ParseException class >> with: aMessageString at: offset line: line column: column [

    ^ self new initializeWith: aMessageString
                           at: offset
                         line: line
                       column: column
]

{ #category : #'as yet unclassified' }
ParseException >> asString [
 ^ msg + ':', line, ':', column 
]

{ #category : #'as yet unclassified' }
ParseException >> column [
 ^ column 
]

{ #category : #'as yet unclassified' }
ParseException >> initializeWith: message at: anOffset line: aLine column: aColumn [

    msg    := message.
    offset := anOffset.
    line   := aLine.
    column := aColumn.
]

{ #category : #'as yet unclassified' }
ParseException >> line [
 ^ line 
]

{ #category : #'as yet unclassified' }
ParseException >> message [
 ^ msg 
]

{ #category : #'as yet unclassified' }
ParseException >> offset [
 ^ offset 
]

