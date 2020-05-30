"
    Copyright (c) 2020 Aucerna.
	Copyright (c) 2009-2018 Stefan Marr <git@stefan-marr.de>
    See license in root and /Performance/Benchmarks directories.
"

Class {
	#name : #HandlerTaskDataRecord,
	#superclass : #RBObject,
	#instVars : [
		'workIn',
		'deviceIn'
	],
	#category : #AWFY
}

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord class >> create [
 ^ super new create 
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> asString [

      ^ 'HandlerTaskDataRecord(', workIn asString, ', ', deviceIn asString, ')'
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> create [

    workIn := deviceIn := RBObject NoWork
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> deviceIn [
 ^ deviceIn 
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> deviceIn: aPacket [
 deviceIn := aPacket 
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> deviceInAdd: packet [

      deviceIn := self append: packet head: deviceIn
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> workIn [
 ^ workIn 
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> workIn: aWorkQueue [
 workIn := aWorkQueue 
]

{ #category : #'as yet unclassified' }
HandlerTaskDataRecord >> workInAdd: packet [

      workIn := self append: packet head: workIn
]

